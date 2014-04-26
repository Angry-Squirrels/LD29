package ennemies;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * ...
 * @author Ynk33
 */
class BaseEnnemy extends FlxSprite
{

	public function new() 
	{
		super();
		
		makeGraphic(100, 100, FlxColor.MAUVE);
		
		this.health = 3;
		
		Reg.ennemyGroup.add(this);
	}
	
}