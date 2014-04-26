package;

import flash.Lib;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import player.Hero;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	var level : Level;
	var hero:Hero;
	var map:FlxSprite;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		level = new Level("assets/data/levels/" + Reg.currentMap +".tmx", this);
		add(level.backgroundTiles);
		add(level.foregroundTiles);
		
		level.loadObjects();
		
		this.hero = new Hero(Reg.spawnX, Reg.spawnY);
		FlxG.worldBounds.set(0, 0, level.fullWidth, level.fullHeight);
		add(this.hero);
		
		FlxG.camera.follow(this.hero.hitbox);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		this.level.collideWithLevel(this.hero.hitbox, test);
		
		FlxG.overlap(level.doors, this.hero.hitbox, touchDoor);
	}	
	
	function test(obja:FlxObject, objb:FlxObject) {
	}
	
	function touchDoor(door: Door, player:FlxSprite) 
	{
		//Reg.currentMap = door.dest;
		
		//Reg.spawnX = door.destX * 32;
		//Reg.spawnY = door.destY * 32;
		door.enter(this.hero);
		FlxG.resetState();
	}
}