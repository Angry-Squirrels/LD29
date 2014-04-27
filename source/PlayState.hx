package;
import flixel.FlxBasic;
import ennemies.BaseEnnemy;
import ennemies.FlyingEnnemy;
import flash.Lib;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import player.Hero;
import flash.errors.Error;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public static var verbose:Bool;
	var level:Level;
	var hero:Hero;
	var map:FlxSprite;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		if(verbose) trace("create(");
		super.create();
		
		if(Reg.levelTree == null)	Reg.levelTree = new LevelTree(10, this);
		//add(Reg.levelTree);
		
		level = Reg.levelTree.currentLevel;
		if(verbose) trace(level);
		level.draw();
		Reg.currentTileMap = level.collisionableTileLayers;
		
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
		
		/*var ennemy:FlyingEnnemy = new FlyingEnnemy(hero);
		ennemy.x = 200;
		ennemy.y = 500;
		add(ennemy);*/
		
		FlxG.camera.follow(this.hero.hitbox);
		FlxG.camera.fade(0xff000000, 0.1, true);
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
		
		if (FlxG.keys.pressed.DOWN) {
			this.hero.canJumpThrough = true;
		}else {
			this.hero.canJumpThrough = false;
		}
		
		level.collideWithLevel(this.hero.hitbox);
		
		FlxG.overlap(level.doors, this.hero.hitbox, touchDoor);
	}	
	
	var doorTouched:Bool = false;
	function touchDoor(door: Door, player:FlxSprite) 
	{
		if (!doorTouched)
		{
			if(verbose) trace("touchDoor");
			Reg.vitX = hero.hitbox.velocity.x;
			Reg.vitY = hero.hitbox.velocity.y;
			door.enter(this.hero);
			//remove(door);
			FlxG.camera.fade(0xff000000, 0.1, false, fadeComplete);
			doorTouched = true;
		}
		
}
function fadeComplete() {
		FlxG.resetState();
	}
	
	function spawnHero():Void 
	{
		var door : Door = null;
		var spawnX : Int = 100;
		var spawnY : Int = 100;
		
		switch(Reg.exitDirection) {
			case 'left' :
				door = level.getDoor('right');
				if (door != null) {
					spawnX = cast door.x - 64;
					spawnY = cast door.y - Reg.spawnOffsetY;
				}
			case 'right' :
				door = level.getDoor('left');
				if (door != null) {
					spawnX = cast door.x + 64;
					spawnY = cast door.y - Reg.spawnOffsetY;
				}
			case 'down' : 
				door = level.getDoor('up');
				if (door != null) {
					spawnX = cast door.x  - Reg.spawnOffsetX;
					spawnY = cast door.y  + 64 ;
				}
			case 'up' :
				door = level.getDoor('down');
				if (door != null){
					spawnX = cast door.x - Reg.spawnOffsetX;
					spawnY = cast door.y - 64 ; 
				}
		}
		
		
		this.hero = new Hero(spawnX, spawnY);
		FlxG.worldBounds.set(0, 0, level.fullWidth, level.fullHeight);
		hero.hitbox.velocity.x = Reg.vitX;
		hero.hitbox.velocity.y = Reg.vitY;
		add(this.hero);
	}
}