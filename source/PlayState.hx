package;

import flash.Lib;
import flixel.FlxG;
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
		
		level = new Level("assets/data/levels/map.tmx");
		add(level.backgroundTiles);
		add(level.foregroundTiles);
		
		this.hero = new Hero(50, 50);
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
		
		this.hero.acceleration.x = 0;
		
		if (FlxG.keys.pressed.RIGHT)
			this.hero.velocity.x += 100;
		if (FlxG.keys.pressed.LEFT)
			this.hero.velocity.x -= 100;
		
		if (FlxG.keys.pressed.UP)
			this.hero.velocity.y = -1000;
		
		super.update();
		
		this.level.collideWithLevel(this.hero.hitbox);
	}	
}