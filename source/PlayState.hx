package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	var level : Level;
	
	var hero : FlxSprite;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		level = new Level("assets/data/levels/map.tmx");
		add(level.backgroundTiles);
		add(level.foregroundTiles);
		
		this.hero = new FlxSprite(50, 50);
		this.hero.makeGraphic(20, 20, 0xffffffff);
		this.hero.maxVelocity.x = 160;
		this.hero.maxVelocity.y = 400;
		this.hero.acceleration.y = 400;
		FlxG.camera.follow(this.hero);
		add(this.hero);
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
		
		this.level.collideWithLevel(this.hero);
	}	
}