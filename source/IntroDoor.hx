package ;
import flixel.FlxSprite;
import flixel.util.loaders.SparrowData;

/**
 * ...
 * @author TBaudon
 */
class IntroDoor extends FlxSprite
{

	public function new(x: Int, y: Int) 
	{
		super(x, y);
		var dat = new SparrowData("assets/images/story_door.xml", "assets/images/story_door.png");
		loadGraphicFromTexture(dat, false);
		animation.addByPrefix("closeMain", "LD29_story_door", 12, false);
		animation.play("closeMain");
	}
	
}