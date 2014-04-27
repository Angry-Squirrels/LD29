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
		
		pointleft = new FlxText(marginX, marginY + 90, 0, "Point left : " + heroStats.statPoinrLeft, 12);
		add(pointleft);
		
		life = new FlxText(marginX, marginY + 120, 0, "Life points : " + heroStats.baseLifePoint, 12);
		add(life);
		
		atk = new FlxText(marginX, marginY + 150, 0, "Damage points : " + heroStats.baseDamegePoint, 12);
		add(atk);
		
		def = new FlxText(marginX, marginY + 180, 0, "Defense points : " + heroStats.baseDefensePoint, 12);
		add(def);
		
		removeLifeBTN = new FlxButton(marginX + 250, life.y, "-", remoLife);
		add(removeLifeBTN);
		addLifeBTN = new FlxButton(marginX + 350, life.y, "+", addLife);
		add(addLifeBTN);
		
		removeAtkBTN = new FlxButton(marginX + 250, atk.y, "-", remoAtk);
		add(removeAtkBTN);
		addAtkBTN = new FlxButton(marginX  + 350, atk.y, "+", addAtk);
		add(addAtkBTN);
		
		removeDefBTN = new FlxButton(marginX  + 250, def.y, "-", remoDef);
		add(removeDefBTN);
		addDefBTN = new FlxButton(marginX  + 350, def.y, "+", addDef);
		add(addDefBTN);
		
		start = new FlxButton(addDefBTN.x , addDefBTN.y + 30, "Start", begin);
		add(start);
		start.active = false;
	}
	
	function begin() 
	{
		FlxG.camera.fade(0xff000000, 1, false, onFadeEnd);
		start.active = false;
		removeLifeBTN.active = false;
		addLifeBTN.active = false;
		removeAtkBTN.active = false;
		addAtkBTN.active = false;
		removeDefBTN.active = false;
		addDefBTN.active = false;
	}
	
	function onFadeEnd() {
		FlxG.switchState(new PlayState());
	}
	
	function updateText() {
		pointleft.text = "Point left : " + heroStats.statPoinrLeft;
		life.text = "Life points : " + heroStats.baseLifePoint;
		atk.text = "Damage points : " + heroStats.baseDamegePoint;
		def.text = "Defense points : " + heroStats.baseDefensePoint;
		
		if (heroStats.statPoinrLeft == 0)
			start.active = true;
		else
			start.active = false;
	}
	
	function remoLife() 
	{
		if (heroStats.baseLifePoint > 1)
		{
			heroStats.baseLifePoint--;
			heroStats.statPoinrLeft++;
		}
		
		updateText();
	}
	
	function addLife() 
	{
		if (heroStats.statPoinrLeft > 0)
		{
			heroStats.baseLifePoint++;
			heroStats.statPoinrLeft--;
		}
		
		updateText();
	}
	
	function remoAtk() 
	{
		if (heroStats.baseDamegePoint > 1)
		{
			heroStats.baseDamegePoint--;
			heroStats.statPoinrLeft++;
		}
		
		updateText();
	}
	
	function addAtk() 
	{
		if (heroStats.statPoinrLeft > 0)
		{
			heroStats.baseDamegePoint++;
			heroStats.statPoinrLeft--;
		}
		
		updateText();
	}
	
	
	function remoDef() 
	{
		if (heroStats.baseDefensePoint> 1)
		{
			heroStats.baseDefensePoint--;
			heroStats.statPoinrLeft++;
		}
		
		updateText();
	}
	
	function addDef() 
	{
		if (heroStats.statPoinrLeft > 0)
		{
			heroStats.baseDefensePoint++;
			heroStats.statPoinrLeft--;
		}
		
		updateText();
	}
	
}