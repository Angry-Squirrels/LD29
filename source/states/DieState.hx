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
		
		Timer.delay(showRooms, 3000);
	}
	
	function showRooms() 
	{
		//FlxG.switchState(new PlayState());
		var roomText = new FlxText(150, 230, 0, "Room explored : " + Reg.heroStats.roomExplored, 18);
		roomText.x = (800 - roomText.width) / 2;
		add(roomText);
		Timer.delay(showKills, 1000);
	}
	
	function showKills() 
	{
		var killText = new FlxText(150, 260, 0, "Enemy killed : " + Reg.heroStats.enemyKilled, 18);
		killText.x = (800 - killText.width) / 2;
		add(killText);
	}
	
	
	
}