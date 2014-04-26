package;

import ennemies.BaseEnnemy;
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
		
		spawnHero();
		
		var ennemy:BaseEnnemy = new BaseEnnemy();
		ennemy.x = 200;
		ennemy.y = 3036;
		add(ennemy);
		
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
		
		if (FlxG.keys.pressed.DOWN) {
			this.hero.canJumpThrough = true;
		}else {
			this.hero.canJumpThrough = false;
		}
		
		this.level.collideWithLevel(this.hero.hitbox);
		
		FlxG.overlap(level.doors, this.hero.hitbox, touchDoor);
	}	
	
	function touchDoor(door: Door, player:FlxSprite) 
	{
		door.enter(this.hero);
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
				spawnX = cast door.x - 64;
				spawnY = cast door.y ;
			case 'right' :
				door = level.getDoor('left');
				spawnX = cast door.x + 64;
				spawnY = cast door.y;
			case 'down' : 
				door = level.getDoor('up');
				spawnX = cast door.x ;
				spawnY = cast door.y  + 64;
			case 'up' :
				door = level.getDoor('down');
				spawnX = cast door.x;
				spawnY = cast door.y - 64; 
		}
		
		
		this.hero = new Hero(spawnX, spawnY);
		FlxG.worldBounds.set(0, 0, level.fullWidth, level.fullHeight);
		add(this.hero);
	}
}