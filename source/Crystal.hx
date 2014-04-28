package ;
import flixel.FlxSprite;
import flixel.util.loaders.SparrowData;

/**
 * ...
 * @author TBaudon
 */
class Crystal extends FlxSprite
{

	public function new(x: Int, y: Int) 
	{
		super(x,y);
		var data = new SparrowData("assets/images/Items/crystal.xml", "assets/images/Items/crystal.png");
		loadGraphicFromTexture(data);
		animation.addByPrefix("shine", "LD29_crystal", 12);
		animation.play("shine", true, 20);
		acceleration.set(0, Reg.GRAVITY);
	}
	
	override public function update() {
		super.update();
		
		var level = Reg.levelTree.currentLevel;
		level.collideWithLevel(this);
		level.crystals.add(this);
	}
	
}