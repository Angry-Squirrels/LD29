package weapons;
import flixel.addons.weapon.FlxWeapon;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxG;

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
	private var parent:FlxSprite;
	
	public function new(_parent:FlxSprite) 
	{
		super();
		
		this.parent = _parent;
		
		//this.loadGraphic(spritePath);
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
		skin.flipX = _facingLeft;
		
		if (bulletFactory != null)
		{
			if (_facingLeft)
			{
				bulletFactory.setBulletDirection(FlxWeapon.BULLET_LEFT, 0);
				bulletFactory.setBulletOffset(- (parent.width + bulletWidth), 0);
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
		if (this.bulletFactory.currentBullet != null)
		{
			this.bulletFactory.currentBullet.x += _x - skin.x;
			this.bulletFactory.currentBullet.y += _y - skin.y;
		}
		
		skin.x = _x;
		skin.y = _y;
		
		bulletFactory.bounds.x = _x - 128;
		bulletFactory.bounds.y = _y - 128;
		
	}
	
}