package;
import ennemies.BaseEnnemy;
import ennemies.EnemySpawner;
import ennemies.FlyingEnnemy;
import flash.errors.Error;
import flash.Lib;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxStringUtil;
import flixel.util.loaders.SparrowData;
import player.Halo;
import player.Hero;
import universe.LevelTree;
import states.DieState;
import universe.LevelDef;
import utils.MusicManager;
import flixel.group.FlxGroup;
/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public static var verbose:Bool;
	public var level:Level;
	var hero:Hero;
	var map:FlxSprite;
	var runningIntro : Bool;
	var introText : FlxText;
	var lastRoom : Bool = true;

	public var enemySpawner:EnemySpawner;
	public var enemies:FlxGroup;
	
	private var halo:Halo;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		if(verbose) trace("create(");
		super.create();
		
		Reg.playState = this;
		
		if (Reg.levelTree == null)	Reg.levelTree = new LevelTree(15, this);
		
		level = Reg.levelTree.currentLevel;
		level.setCurrentState(this);
		level.draw();
		

		Reg.currentTileMap = level.collisionableTileLayers;
		
		FlxG.worldBounds.set(0, 0, level.fullWidth, level.fullHeight);
		
		
		for (member in level.backgroundTiles.members)
		{
			if(verbose) trace(member);
		}
		if(verbose) trace(level.definition.mask);
		
		add(level.backgroundTiles);
		add(level.foregroundTiles);
		
		//	si le niveau n'a pas encore de spawner ni de difficulté, on les définit
		if (level.definition.difficulty == 0)
		{
			level.definition.difficulty = Reg.heroStats.roomExplored;			
		}
		if (enemySpawner == null)
		{
			enemySpawner = new EnemySpawner(this);
		}
		enemies = new FlxGroup();
		
		level.loadObjects(this);
		
		
		add(level.crystals);

		initGame();
		spawnHero();
		enemySpawner.generateEnemies(level.definition.difficulty);
		
		FlxG.camera.follow(this.hero.hitbox);
		FlxG.camera.setBounds(FlxG.worldBounds.x, FlxG.worldBounds.y, FlxG.worldBounds.width, FlxG.worldBounds.height);
		FlxG.camera.fade(0xff000000, 0.1, true);
		
		MusicManager.playMusic();
		
		halo = new Halo(hero.hitbox);
		add(halo);
		
		addUi();
	}
	
	var healthBar : FlxSprite;
	var crystalTxt : FlxText;
	var healthTxt : FlxText;
	function addUi() 
	{
		var healthBarBg = new FlxSprite(10, 10);
		healthBarBg.makeGraphic(250, 12, 0xff222222);
		healthBarBg.scrollFactor.x = 0;
		healthBarBg.scrollFactor.y = 0;
		add(healthBarBg);
		
		healthBar = new FlxSprite(12, 12);
		healthBar.makeGraphic(246, 8, 0xffcc3300);
		healthBar.scrollFactor.x = 0;
		healthBar.scrollFactor.y = 0;
		add(healthBar);
		healthBar.origin.x = 0;
		healthBar.origin.y = 0;
		
		healthTxt = new FlxText(20, 10, 0, hero.hitbox.health + " / " + Reg.heroStats.maxHealth);
		healthTxt.scrollFactor.x = 0;
		healthTxt.scrollFactor.y = 0;
		add(healthTxt);
		
		var crystal = new FlxSprite(-15, 10);
		var dat = new SparrowData("assets/images/Items/crystal.xml", "assets/images/Items/crystal.png");
		crystal.loadGraphicFromTexture(dat, false, "LD29_crystal0003");
		crystal.scrollFactor.x = 0;
		crystal.scrollFactor.y = 0;
		crystal.scale.x = 0.7;
		crystal.scale.y = 0.7;
		add(crystal);
		
		crystalTxt = new FlxText(30, 30, 0, "x " + Reg.heroStats.coinCollected, 24);
		crystalTxt.scrollFactor.x = 0;
		crystalTxt.scrollFactor.y = 0;
		add(crystalTxt);
		
		add(new MiniMap());
	}
	
	function updateUI() {
		var ratio = Reg.heroStats.health / Reg.heroStats.maxHealth;
		crystalTxt.text = "x " + Reg.heroStats.coinCollected;
		healthBar.scale.x = ratio;
		if (hero.hitbox.health < 0) hero.hitbox.health = 0;
		healthTxt.text = hero.hitbox.health + " / " + Reg.heroStats.maxHealth;
	}
	
	var introTextIndex:Int = 0;
	var canSkip : Bool;
	var introDoor : IntroDoor;
	function initGame() 
	{
		var curDef : LevelDef = Reg.levelTree.currentLevel.definition;
		
		var alt = curDef.alt;
		var long = curDef.long;
		
		if (alt == 0 && long == 0) {
			
			introDoor = new IntroDoor( -10, 64 * 15, curDef.explored);
			introDoor.immovable = true;
			add(introDoor);
			introText = new FlxText(introDoor.x + 100, introDoor.y + 50, 250, "", 16);
			add(introText);
			
			if (!curDef.explored) {
				runningIntro = true;
				FlxG.camera.fade(0xff000000, 1, true, onEndIntroFadeIn);
				
				// init hero
				
				spawnX = 140;
				spawnY = 17 * 64 + 10;
				
				Reg.heroStats.initHealth();
			}
		}
	}
	
	public function speakDoor(text : String) {
		introText.text = text;
		add(introText);
	}
	
	function onEndIntroFadeIn() 
	{
		introDoor.close();
	}
	
	
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		if (verbose) trace("destroy(");
		remove(level.backgroundTiles);
		remove(level.foregroundTiles);
		super.destroy();
	}
	
	function introDoorCollide(obj : Dynamic, obja:Dynamic) {
		//introDoor.open();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		
		level.collideWithLevel(this.hero.hitbox);
		
		if(introDoor != null)
			FlxG.collide(introDoor, hero.hitbox, introDoorCollide);
			
		if (FlxG.keys.justPressed.R) FlxG.resetState();
		
		FlxG.overlap(level.doors, this.hero.hitbox, touchDoor);
		FlxG.collide(enemies, enemies);
		FlxG.overlap(level.crystals, this.hero.hitbox, collectCrystal);
		
		halo.place();
		
		updateUI();
	}	
	
	function collectCrystal(crystal: Crystal, player:FlxSprite) 
	{
		crystal.kill();
		Reg.heroStats.coinCollected++;
	}
	
	function touchDoor(door: Door, player:FlxSprite) 
	{
		if (!door.entered) {
			if(verbose) trace("touchDoor");
			level.explore();
			Reg.vitX = hero.hitbox.velocity.x;
			Reg.vitY = hero.hitbox.velocity.y;
			Reg.heroFlip = hero.getFlip();
			if (level.definition.isLast && door.direction == 'up') {
				MusicManager.stopMusic();
				FlxG.camera.fade(0xffffffff, 1, false, gotoOutro);
			}
			else {
				door.enter(this.hero);
				FlxG.camera.fade(0xff000000, 0.1, false, fadeComplete);
			}
		}
	}

	function fadeComplete() {
		FlxG.resetState();
	}
	
	function gotoOutro() {
		FlxG.switchState(new OutState());
	}
	
	function spawnHero():Void 
	{
		var door : Door = null;
		
		this.hero = new Hero(0, 0);
		hero.hitbox.velocity.x = Reg.vitX;
		hero.hitbox.velocity.y = Reg.vitY;
		hero.flipHero(Reg.heroFlip);
		if (Reg.vitY < 0) hero.setState(Hero.FALL);
		add(this.hero);
		
		switch(Reg.exitDirection) {
			case 'left' :
				door = level.getDoor('right');
				if (door != null) {
					spawnX = cast door.x - 80;
					spawnY = cast door.y - Reg.spawnOffsetY;
				}
			case 'right' :
				door = level.getDoor('left');
				if (door != null) {
					spawnX = cast door.x + 80;
					spawnY = cast door.y - Reg.spawnOffsetY;
				}
			case 'down' : 
				door = level.getDoor('up');
				if (door != null) {
					spawnX = cast door.x  - Reg.spawnOffsetX;
					spawnY = cast door.y + 64;
				}
			case 'up' :
				door = level.getDoor('down');
				if (door != null){
					spawnX = cast door.x - Reg.spawnOffsetX;
					spawnY = cast door.y - 128; 
				}
		}
		
		hero.hitbox.x = spawnX;
		hero.hitbox.y = spawnY;
	}
	
	var damagestxts : Array<FlxText> = new Array<FlxText>();
	public function showDamage(amount: Int, target:FlxSprite)  {
		var damageTxt = new FlxText(target.getMidpoint().x, target.y - 30, 0, "-" + amount, 20);
		if(target == hero.hitbox)
			damageTxt.color = 0xffff6600;
		else
			damageTxt.color = 0xff66cc00;
		add(damageTxt);
		damageTxt.solid = true;
		damageTxt.acceleration.y = 1000;
		damageTxt.velocity.y = -1000;
		FlxTween.tween(damageTxt, { alpha:0 }, 0.4, { complete:damageShown } );
		damagestxts.push(damageTxt);
	}
	
	function damageShown(target : FlxTween ) {
		damagestxts.shift().destroy();
	}
	
	var hittedEnemy : BaseEnnemy;
	var enemyNameTxt : FlxText;
	var enemyBarBg : FlxSprite;
	var enemyBar : FlxSprite;
	var spawnY:Int;
	var spawnX:Int;
	public function showEnnemyBar(enemy : BaseEnnemy) {
		if (enemyNameTxt == null) {
			
			var barrX = 430;
			var barrY = 427;
			
			enemyNameTxt = new FlxText(barrX, barrY, 0, "", 12);
			add(enemyNameTxt);
			enemyNameTxt.scrollFactor.x = 0;
			enemyNameTxt.scrollFactor.y = 0;
			
			enemyBarBg = new FlxSprite(barrX, barrY + 20);
			enemyBarBg.scrollFactor.x = 0;
			enemyBarBg.scrollFactor.y = 0;
			enemyBarBg.makeGraphic(250, 12, 0xff222222);
			add(enemyBarBg);
			
			enemyBar = new FlxSprite(barrX + 2, enemyBarBg.y + 2);
			enemyBar.makeGraphic(246, 8, 0xff66cc00);
			enemyBar.origin.x = 0;
			enemyBar.origin.y = 0;
			enemyBar.scrollFactor.x = 0;
			enemyBar.scrollFactor.y = 0;
			add(enemyBar);
		}
		
		if (hittedEnemy != null)
			hideEnnemyBar();
			
		enemyNameTxt.visible = true;
		enemyBarBg.visible = true;
		enemyBar.visible = true;
		hittedEnemy = enemy;
		enemyBar.scale.x = enemy.body.health / enemy.maxHealth;
		if (enemyBar.scale.x < 0)
			enemyBar.scale.x = 0;
		enemyNameTxt.text = enemy.name + " lvl " + enemy.difficulty;
	}
	
	public function hideEnnemyBar() {
		enemyNameTxt.visible = false;
		enemyBarBg.visible = false;
		enemyBar.visible = false;
		hittedEnemy = null;
	}
}