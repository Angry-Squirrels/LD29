package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.loaders.SparrowData;
import flixel.util.FlxRandom;

/**
 * ...
 * @author TBaudon
 */
class Crystal extends FlxSprite
{
	var level:Level;

	public function new(x: Int, y: Int) 
	{
		super(x,y);
		var data = new SparrowData("assets/images/Items/crystal.xml", "assets/images/Items/crystal.png");
		loadGraphicFromTexture(data);
		animation.addByPrefix("shine", "LD29_crystal", 12);
		animation.play("shine", true, 20);
		acceleration.set(0, Reg.GRAVITY);
		
		level = Reg.levelTree.currentLevel;
		level.crystals.add(this);
		
		this.drag.set(150, 0);
		
		this.velocity.x = FlxRandom.intRanged( -400, 400);
		this.velocity.y = FlxRandom.intRanged( -400, -100);
		
		Reg.playState.add(this);
	}
	
	override public function update() {
		super.update();
		
		
		
		level.collideWithLevel(this);
	}
	
}