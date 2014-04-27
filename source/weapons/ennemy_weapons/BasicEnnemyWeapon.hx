package weapons.ennemy_weapons;
import flixel.FlxSprite;
import weapons.BaseWeapon;

/**
 * ...
 * @author Ynk33
 */
class BasicEnnemyWeapon extends BaseWeapon
{
	
	public function new(_parent:FlxSprite) 
	{
		super(_parent);
		
		bulletWidth = 50;
		
		this.bulletFactory = new FlxWeapon("staff", skin);
		this.bulletFactory.bulletDamage = 1;
		this.bulletFactory.setBulletLifeSpan(0.1);
		this.bulletFactory.setBulletDirection(FlxWeapon.BULLET_RIGHT, 0);
		this.bulletFactory.makePixelBullet(2, bulletWidth, 150, FlxColor.YELLOW);
		add(this.bulletFactory.group);
	}
	
}