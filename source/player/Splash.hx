package player;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.loaders.SparrowData;

/**
 * ...
 * @author Ynk33
 */
class Splash extends FlxSprite
{

	public function new(_point:FlxPoint) 
	{
		super(Std.int(_point.x), Std.int(_point.y));
		
		var animData = new SparrowData("assets/images/Effects/bim.xml", "assets/images/Effects/bim.png");
		loadGraphicFromTexture(animData);
		animation.addByPrefix("bim", "LD29_bim", 6, false);
		animation.callback = animCallback;
	}
	
	public function play()
	{
		animation.play("bim");
		animation.curAnim.frameRate = 30;
	}
	
	private function animCallback(_anim:String, _frameNumber:Int, _frameIndex:Int):Void
	{
		if (_frameNumber == 5)
		{
			kill();
		}
	}
	
}