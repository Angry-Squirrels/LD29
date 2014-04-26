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
	private var bulletWidth:Int;
	public var skin:FlxSprite;
	
	public function new() 
	{
		super();
		
		//this.loadGraphic(spritePath);
	}
	
	public function fire():Void
	{
		this.bulletFactory.fire();
	}
	
	public function flipWeapon(_facingLeft:Bool):Void
	{
		skin.flipX = _facingLeft;
		
		if (bulletFactory != null)
		{
			if (_facingLeft)
			{
				bulletFactory.setBulletDirection(FlxWeapon.BULLET_LEFT, 0);
				bulletFactory.setBulletOffset(- (64 + bulletWidth), 0);
			}
			else
			{
				bulletFactory.setBulletDirection(FlxWeapon.BULLET_RIGHT, 0);
				bulletFactory.setBulletOffset(0, 0);
			}
		}
	}
	
	public function moveWeapon(_x:Int, _y:Int)
	{
		skin.x = _x;
		skin.y = _y;
		
		bulletFactory.bounds.x = _x - 128;
		bulletFactory.bounds.y = _y - 128;
	}
	
}