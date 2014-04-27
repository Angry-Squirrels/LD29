package;
import ennemies.FlyingEnnemy;
import flash.errors.Error;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import haxe.Timer;
import player.Hero;
import universe.LevelTree;
import states.DieState;
import universe.LevelDef;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public static var verbose:Bool;
	var level:Level;
	var hero:Hero;
	var map:FlxSprite;
	var runningIntro : Bool;
	
	var introText : FlxText;
	
	public function new() {
		super();
	}
	
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
		if(verbose) trace(level);
		level.draw();
		Reg.currentTileMap = level.collisionableTileLayers;
		
		FlxG.worldBounds.set(0, 0, level.fullWidth, level.fullHeight);
		
		try
		{
			if(verbose) trace("backgroundTiles:" + level.backgroundTiles);
			
			if(verbose) trace(level.backgroundTiles.members);
			for (member in level.backgroundTiles.members)
			{
				if(verbose) trace(member);
			}
			if(verbose) trace(level.definition.mask);
			
			add(level.backgroundTiles);
			add(level.foregroundTiles);
		}
		catch (e:Error)
		{
			if(verbose) trace(e);
		}
		
		level.loadObjects(this);
		
		spawnHero();
		
		launchSpecialEvent();
		
		var ennemy:FlyingEnnemy = new FlyingEnnemy(hero);
		ennemy.place(100, 100);
		add(ennemy);
		
		FlxG.camera.follow(this.hero.hitbox);
		//FlxG.camera.bounds = FlxG.worldBounds;
		FlxG.camera.setBounds(FlxG.worldBounds.x, FlxG.worldBounds.y, FlxG.worldBounds.width, FlxG.worldBounds.height);
		FlxG.camera.fade(0xff000000, 0.1, true);
	}
	
	var introTextIndex:Int = 0;
	function launchSpecialEvent() 
	{
		var curDef : LevelDef = Reg.levelTree.currentLevel.definition;
		
		var alt = curDef.alt;
		var long = curDef.long;
		
		if (alt == 0 && long == 0) {
			if (!curDef.explored) {
				runningIntro = true;
				FlxG.camera.fade(0xff000000, 1, true);
				introText = new FlxText(10, 10, 0, Reg.introTexts[introTextIndex], 16);
				add(introText);
				Timer.delay(changeIntroText, 3000);
			}
		}
	}
	
	function changeIntroText() 
	{
		if (introTextIndex < Reg.introTexts.length-1) {
			introTextIndex++;
			Timer.delay(changeIntroText, 2000);
			introText.text = Reg.introTexts[introTextIndex];
		}
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		if(verbose) trace("destroy(");
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
		}
		
		if (FlxG.keys.pressed.K)
			FlxG.switchState(new DieState());
		
		FlxG.overlap(level.doors, this.hero.hitbox, touchDoor);
	}	
	
	function touchDoor(door: Door, player:FlxSprite) 
	{
		if (!door.entered){
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