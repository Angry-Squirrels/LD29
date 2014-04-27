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
	private var parent:FlxSprite;
	
	public function new(_parent:FlxSprite) 
	{
		super();
		
		this.parent = _parent;
	}
	
	public override function update()
	{
		FlxG.overlap(this.bulletFactory.group, Reg.ennemyGroup, applyDamage);
		
		super.update();
	}
	
	private function applyDamage(_obj1:FlxObject, _obj2:FlxObject)
	{
		// destroy bullet
		_obj1.kill();
		
		// apply damage to the ennemy
		_obj2.hurt(this.bulletFactory.bulletDamage);
	}
	
	public function fire():Void
	{
		this.bulletFactory.fire();
	}
	
	public function flipWeapon(_facingLeft:Bool):Void
	{
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
		if (this.bulletFactory.currentBullet != null)
		{
			this.bulletFactory.currentBullet.x += _x;
			this.bulletFactory.currentBullet.y += _y;
		}
		
		bulletFactory.bounds.x = _x - parent.width;
		bulletFactory.bounds.y = _y - parent.width;
	}
}