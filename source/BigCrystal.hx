package ;
import flixel.FlxSprite;
import flixel.util.loaders.SparrowData;
import haxe.xml.Fast;
import flixel.FlxG;

/**
 * ...
 * @author Ynk33
 */
class BigCrystal extends FlxSprite
{
	public function new(xml:Fast, _x:Int, _y:Int) 
	{
		super(_x, _y);
		var data = new SparrowData("assets/images/Items/crystal_ore.xml", "assets/images/Items/crystal_ore.png");
		loadGraphicFromTexture(data);
		animation.addByPrefix("shine", "LD29_crystal_ore", 20);
		animation.play("shine", true, 20);
		
		Reg.bigCrystalsGroup.add(this);
		
		this.health = 3;
	}
	
	public override function kill()
	{
		if (!alive)
		{
			return;
		}
		
		Reg.bigCrystalsGroup.remove(this);
		
		FlxG.sound.play("assets/sounds/bigcrystal_break.mp3", 1, false);
		FlxG.sound.play("assets/sounds/crystal_pop.mp3", 1, false);
		
		for (i in 0 ... 10) new Crystal(cast (x + width / 2), cast (y + height / 2));
		
		super.kill();
	}
}