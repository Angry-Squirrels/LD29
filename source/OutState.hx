package ;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author TBaudon
 */
class OutState extends FlxState
{

	var theEnd : FlxText;
	
	public function new() 
	{
		super();
		
		bgColor = 0xffffffff;
		
		theEnd = new FlxText(0, 0, 0, "The End", 24);
		theEnd.color = 0xff000000;
		theEnd.x = (800 - theEnd.width) / 2;
		theEnd.y = (480 - theEnd.height) / 2;
		theEnd.alpha = 0;
		add(theEnd);
		FlxTween.tween(theEnd, { alpha:1 }, 1, { complete: endComplete } );
	}
	
	function endComplete() {
		
	}
	
}