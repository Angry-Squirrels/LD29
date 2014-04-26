package weapons;

import flixel.addons.weapon.FlxWeapon;
import flixel.addons.weapon.FlxBullet;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import bullets.BasicCACBullet;
import player.Hero;

/**
 * ...
 * @author Ynk33
 */
class Staff extends BaseWeapon
{
	private static var spritePath:String = "";
	
	public function new(_parent:Hero) 
	{
		super();
		
		skin = new FlxSprite(0, 0);
		skin.makeGraphic(5, 15, FlxColor.BLACK);
		add(skin);
		
		this.bulletFactory = new FlxWeapon("staff", skin, BasicCACBullet);
		this.bulletFactory.bulletDamage = 1;
		this.bulletFactory.setFireRate(1);
		this.bulletFactory.setBulletLifeSpan(0.1);
		this.bulletFactory.setBulletDirection(FlxWeapon.BULLET_RIGHT, 0);
		this.bulletFactory.makePixelBullet(2, 10, 35, FlxColor.YELLOW);
	}
	
	public override function fire()
	{
		if (this.bulletFactory.fire())
		{
			add(this.bulletFactory.currentBullet);
		}
	}
	
	public override function kill()
	{
		if (!alive)
		{
			return;
		}
	}
}