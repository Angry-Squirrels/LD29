package weapons;
import flixel.addons.weapon.FlxWeapon;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.util.loaders.SparrowData;

/**
 * ...
 * @author Ynk33
 */
class BaseWeapon extends FlxGroup
{
	private var bulletFactory:FlxWeapon;
	private var bulletWidth:Int;
	
	private var fireRate:Float; // time between 2 shots in seconds
	private var elapsedTime:Float;
	
	private var parent:FlxSprite;
	public var skin:FlxSprite;
	
	public function new(_parent:FlxSprite) 
	{
		super();
		
		this.parent = _parent;
		
		elapsedTime = 0;
	}
	
	public override function update():Void
	{
		elapsedTime += FlxG.elapsed;
		
		super.update();
	}
	
	private function applyDamage(_obj1:FlxObject, _obj2:FlxObject)
	{
		// destroy bullet
		_obj1.kill();
	}
	
	public function fire():Void
	{
		if (elapsedTime > fireRate)
		{
			elapsedTime = 0;
			this.bulletFactory.fire();
		}
	}
	
	public function flipWeapon(_facingLeft:Bool):Void
	{
		skin.flipX = _facingLeft;
		
		if (bulletFactory != null)
		{
			if (_facingLeft)
			{
				bulletFactory.setBulletDirection(FlxWeapon.BULLET_LEFT, 0);
				bulletFactory.setBulletOffset(-bulletWidth, 0);
			}
			else
			{
				bulletFactory.setBulletDirection(FlxWeapon.BULLET_RIGHT, 0);
				bulletFactory.setBulletOffset(parent.width, 0);
			}
		}
	}
	
	public function moveWeapon(_x:Float, _y:Float)
	{
		skin.x = _x;
		skin.y = _y;
		
		if (this.bulletFactory.currentBullet != null)
		{
			this.bulletFactory.currentBullet.x = skin.flipX ? skin.x - bulletWidth : skin.x + parent.width;
			this.bulletFactory.currentBullet.y = skin.y;
		}
		
		bulletFactory.bounds.x = _x - bulletWidth - 5;
		bulletFactory.bounds.y = _y - bulletWidth - 5;
	}
	
	public override function kill()
	{
		if (!alive)
		{
			return;
		}
		
		bulletFactory = null;
		
		super.kill();
	}
}