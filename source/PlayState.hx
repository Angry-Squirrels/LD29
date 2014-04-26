package;

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
		
		hero = new Hero();
		add(hero);
		
		map = new FlxSprite(0, 100);
		map.makeGraphic(500, 10, FlxColor.BEIGE);
		map.immovable = true;
		add(map);
		
		FlxG.camera.setBounds(0, 0, 640, 480);
		FlxG.worldBounds.set(0, 0, 640, 480);
		FlxG.camera.follow(hero.hitbox, 1);
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
		
		FlxG.collide(hero, map);
	}	
}