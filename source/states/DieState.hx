package states;
import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import haxe.Timer;

/**
 * ...
 * @author TBaudon
 */
class DieState extends FlxState
{

	override public function create() {
	
		FlxG.camera.fade(0xff000000, 2, true);
		
		var dead : FlxText = new FlxText(0, 150, 0, "You died...", 42);
		dead.x = (800 - dead.width) / 2;
		dead.color = 0xffff0000;
		add(dead);
		
		Timer.delay(showScore, 3000);
	}
	
	function showScore() 
	{
		FlxG.switchState(new PlayState());
	}
	
	
	
}