package states;
import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import haxe.Timer;

/**
 * ...
 * @author TBaudon
 */
class DieState extends FlxState
{
	var btn:flixel.ui.FlxButton;

	override public function create() {
	
		FlxG.camera.fade(0xff000000, 2, true);
		
		var dead : FlxText = new FlxText(0, 100, 0, "You died...", 42);
		dead.x = (800 - dead.width) / 2;
		dead.color = 0xffff0000;
		add(dead);
		
		Timer.delay(showCoins, 3000);
	}
	/*
	function showRooms() 
	{
		//FlxG.switchState(new PlayState());
		var roomText = new FlxText(150, 170, 0, "Room explored : " + Reg.heroStats.roomExplored, 18);
		roomText.x = (800 - roomText.width) / 2;
		add(roomText);
		Timer.delay(showKills, 1000);
	}
	
	function showKills() 
	{
		var killText = new FlxText(150, 200, 0, "Enemy killed : " + Reg.heroStats.enemyKilled, 18);
		killText.x = (800 - killText.width) / 2;
		add(killText);
		Timer.delay(showCoins, 1000);
	}
	
	function showXp() 
	{
		var xpText = new FlxText(150, 230, 0, "xp : " + Reg.heroStats.experience, 18);
		xpText.x = (800 - xpText.width) / 2;
		add(xpText);
		Timer.delay(showCoins, 1000);
	}*/
	
	function showCoins() 
	{
		var final : Int = Reg.heroStats.coinCollected; 
		
		Reg.heroStats.coinCollected = final+100;
							
		var total = new FlxText(150, 220, 0, "Coins collected : " + Reg.heroStats.coinCollected, 18);
		total.x = (800 - total.width) / 2;
		add(total);
		Timer.delay(showBtn, 1000);
	}
	
	function showBtn() 
	{
		btn = new FlxButton(0, 330, "Continue", onClick);
		btn.x = (800 - btn.width) / 2;
		add(btn);
	}
	
	function onClick() 
	{
		FlxG.camera.fade(0xff000000, 0.3, false, gotoUpgrade);
		btn.active = false;
	}
	
	function gotoUpgrade() 
	{
		FlxG.switchState(new UpgradeState());
	}
	
	
	
}