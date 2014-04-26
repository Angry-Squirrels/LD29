package weapons;
import flixel.addons.weapon.FlxWeapon;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * ...
 * @author Ynk33
 */
class BaseWeapon extends FlxGroup
{
	private static var spritePath:String = "";
	private var bulletFactory:FlxWeapon;
	public var skin:FlxSprite;
	
	public function new() 
	{
		super();
		
		//this.loadGraphic(spritePath);
	}
	
	public function fire():Void
	{
		
	}
	
	public function flipWeapon(_facingLeft:Bool):Void
	{
		skin.flipX = _facingLeft;
		if (bulletFactory != null)
		{
			if (_facingLeft)
			{
				bulletFactory.setBulletDirection(FlxWeapon.BULLET_LEFT, 0);
			}
			else
			{
				bulletFactory.setBulletDirection(FlxWeapon.BULLET_RIGHT, 0);
			}
		}
	}
	
}