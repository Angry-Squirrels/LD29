package ennemies;
import flixel.FlxSprite;
import flixel.util.loaders.SparrowData;
/**
 * ...
 * @author damrem
 */
class Splat extends FlxSprite
{

	public function new(Callback) 
	{
		super();
		trace(this.getScreenXY());
		
		var animData = new SparrowData("assets/images/Effects/splat.xml", "assets/images/Effects/splat.png");
		loadGraphicFromTexture(animData);
		animation.addByPrefix("splat", "splat", 12);
		
		if (Callback != null)	animation.callback = Callback;
	}
	
	public function play()
	{
		animation.play("splat");
		animation.curAnim.frameRate = 30;
	}
	
}