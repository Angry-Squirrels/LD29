package states;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxG;

/**
 * ...
 * @author TBaudon
 */
class UpgradeState extends FlxState
{
	var pointleft:FlxText;
	var life:FlxText;
	var atk:FlxText;
	var def:FlxText;
	var heroStats : HeroStats;
	
	var marginX : Int = 180;
	var marginY : Int = 50;
	
	var start : FlxButton;
	var addDefBTN:flixel.ui.FlxButton;
	var removeDefBTN:flixel.ui.FlxButton;
	var removeLifeBTN:flixel.ui.FlxButton;
	var addLifeBTN:flixel.ui.FlxButton;
	var removeAtkBTN:flixel.ui.FlxButton;
	var addAtkBTN:flixel.ui.FlxButton;
	
	override public function create() {
		
		heroStats = Reg.heroStats;
		
		var instructions : FlxText = new FlxText(marginX + 5, marginY, 0, "Upgrade your hero!", 32);
		add(instructions);
		
		pointleft = new FlxText(marginX, marginY + 90, 0, "Coins left : " + heroStats.statPoinrLeft, 12);
		add(pointleft);
		
		life = new FlxText(marginX, marginY + 120, 0, "Life points : " + heroStats.baseLifePoint, 12);
		add(life);
		
		atk = new FlxText(marginX, marginY + 150, 0, "Damage points : " + heroStats.baseDamegePoint, 12);
		add(atk);
		
		def = new FlxText(marginX, marginY + 180, 0, "Defense points : " + heroStats.baseDefensePoint, 12);
		add(def);
		
		addLifeBTN = new FlxButton(marginX + 350, life.y, "Buy", buyLife);
		add(addLifeBTN);
		
		addAtkBTN = new FlxButton(marginX  + 350, atk.y, "Buy", buyAtk);
		add(addAtkBTN);

		addDefBTN = new FlxButton(marginX  + 350, def.y, "Buy", buyDef);
		add(addDefBTN);
		
		start = new FlxButton(addDefBTN.x , addDefBTN.y + 30, "Start", begin);
		add(start);
		start.active = false;
		
		updateText();
	}
	
	function begin() 
	{
		FlxG.camera.fade(0xff000000, 1, false, onFadeEnd);
		start.active = false;
		addLifeBTN.active = false;
		addAtkBTN.active = false;
		addDefBTN.active = false;
	}
	
	function onFadeEnd() {
		Reg.resetGame();
		FlxG.switchState(new PlayState());
	}
	
	function updateText() {
		pointleft.text = "Coins left : " + heroStats.coinCollected;
		life.text = "Life level : " + heroStats.baseLifePoint;
		atk.text = "Damage level : " + heroStats.baseDamegePoint;
		def.text = "Defense level : " + heroStats.baseDefensePoint;
		
		if (heroStats.statPoinrLeft == 0)
			start.active = true;
		else
			start.active = false;
	}
	
	function canAfford(ammount: Int) : Bool {
		return Reg.heroStats.coinCollected - ammount >= 0;
	}
	
	function buyLife() 
	{
		var cost = Reg.heroStats.baseLifePoint * 10; 
		if (canAfford(cost))
		{
			heroStats.baseLifePoint++;
			heroStats.coinCollected-=cost;
		}
		
		updateText();
	}
	
	function buyAtk() 
	{
		var cost = Reg.heroStats.baseDamegePoint * 10; 
		if (canAfford(cost))
		{
			heroStats.baseDamegePoint++;
			heroStats.coinCollected-=cost;
		}
		
		updateText();
	}
	
	function buyDef() 
	{
		var cost = Reg.heroStats.baseDefensePoint * 10; 
		if (canAfford(cost))
		{
			heroStats.baseDefensePoint++;
			heroStats.coinCollected-=cost;
		}
		
		updateText();
	}
	
}