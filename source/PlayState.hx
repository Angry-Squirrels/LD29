package;
import ennemies.BaseEnnemy;
import ennemies.EnemySpawner;
import ennemies.FlyingEnnemy;
import flash.errors.Error;
import flash.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import haxe.Timer;
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

	public var enemySpawner:EnemySpawner;
	public var enemies:FlxGroup;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		if(verbose) trace("create(");
		super.create();
		
		Reg.playState = this;
		
		if(Reg.levelTree == null)	Reg.levelTree = new LevelTree(10, this);
		
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
		
		spawnHero();
		
		add(new Crystal(cast hero.hitbox.x, cast hero.hitbox.y));
		
		enemySpawner.generateEnemies();
		initGame();
		
		
		/*
		var ennemy:FlyingEnnemy = new FlyingEnnemy(hero);
		ennemy.place(100, 100);
		add(ennemy);
		*/
		
		FlxG.camera.follow(this.hero.hitbox);
		FlxG.camera.setBounds(FlxG.worldBounds.x, FlxG.worldBounds.y, FlxG.worldBounds.width, FlxG.worldBounds.height);
		FlxG.camera.fade(0xff000000, 0.1, true);
		
		MusicManager.playMusic();
		
		addUi();
	}
	
	var healthBar : FlxSprite;
	function addUi() 
	{
		var healthBarBg = new FlxSprite(10, 10);
		healthBarBg.makeGraphic(250, 12, 0xff000000);
		healthBarBg.scrollFactor.x = 0;
		healthBarBg.scrollFactor.y = 0;
		add(healthBarBg);
		
		healthBar = new FlxSprite(12, 12);
		healthBar.makeGraphic(246, 8, 0xffcc0000);
		healthBar.scrollFactor.x = 0;
		healthBar.scrollFactor.y = 0;
		add(healthBar);
		healthBar.origin.x = 0;
		healthBar.origin.y = 0;
		
		add(new MiniMap());
	}
	
	function updateUI() {
		var ratio = Reg.heroStats.health / Reg.heroStats.maxHealth;
		healthBar.scale.x = ratio;
	}
	
	var introTextIndex:Int = 0;
	var canSkip : Bool;
	function initGame() 
	{
		var curDef : LevelDef = Reg.levelTree.currentLevel.definition;
		
		var alt = curDef.alt;
		var long = curDef.long;
		
		if (alt == 0 && long == 0) {
			if (!curDef.explored) {
				runningIntro = true;
				FlxG.camera.fade(0xff000000, 1, true, onEndIntroFadeIn);
				introText = new FlxText(10, 10, 0, Reg.introTexts[introTextIndex], 16);
				add(introText);
				introTimer = Timer.delay(changeIntroText, 3000);
				
				// init hero
				Reg.heroStats.initHealth();
			}
		}
	}
	
	function onEndIntroFadeIn() 
	{
		canSkip = true;
	}
	
	var introTimer : Timer;
	function changeIntroText() 
	{
		if (introTextIndex < Reg.introTexts.length-1 && introText != null) {
			introTextIndex++;
			introTimer = Timer.delay(changeIntroText, 2000);
			introText.text = Reg.introTexts[introTextIndex];
		}
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		if (verbose) trace("destroy(");
		trace(introTimer);
		if (introTimer != null)
			introTimer.stop();
		remove(level.backgroundTiles);
		remove(level.foregroundTiles);
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		
		level.collideWithLevel(this.hero.hitbox);
		
		if (runningIntro) {
			hero.hitbox.velocity.x = 700;
			introText.x = hero.hitbox.x + 50;
			introText.y = hero.hitbox.y  - 25;
			
			if (canSkip && FlxG.keys.pressed.X)
				touchDoor(cast level.doors.getFirstExisting(), hero.hitbox);
			
		}
		
		if (FlxG.keys.pressed.K)
			FlxG.switchState(new DieState());
		
		FlxG.overlap(level.doors, this.hero.hitbox, touchDoor);
		FlxG.collide(enemies, enemies);
		FlxG.overlap(level.crystals, this.hero.hitbox, collectCrystal);
		
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
			door.enter(this.hero);
			FlxG.camera.fade(0xff000000, 0.1, false, fadeComplete);
		}
	}

	function fadeComplete() {
		FlxG.resetState();
	}
	
	function spawnHero():Void 
	{
		var door : Door = null;
		var spawnX : Int = 0;
		var spawnY : Int = 17 * 64 + 10;
		
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
		
		
		this.hero = new Hero(spawnX, spawnY);
		hero.hitbox.velocity.x = Reg.vitX;
		hero.hitbox.velocity.y = Reg.vitY;
		add(this.hero);
	}
}