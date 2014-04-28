package weapons.hero_weapons;

import flixel.addons.weapon.FlxWeapon;
import flixel.addons.weapon.FlxBullet;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import player.Hero;
import weapons.BaseWeapon;

/**
 * ...
 * @author Ynk33
 */
class Staff extends BaseHeroWeapon
{
	private var hero:Hero;
	
	public function new(_parent:Hero) 
	{
		spritePath = "assets/Weapons/hero_arm.png";
		spriteXML = "assets/Weapons/hero_arm.xml";
		
		super(_parent.body);
		
		hero = _parent;
		
		bulletWidth = 40;
		fireRate = 0.25;
		
		this.bulletFactory = new FlxWeapon("staff");
		this.bulletFactory.bulletDamage = 1;
		this.bulletFactory.setBulletLifeSpan(0.1);
		this.bulletFactory.setBulletDirection(FlxWeapon.BULLET_RIGHT, 0);
		this.bulletFactory.makePixelBullet(2, bulletWidth, 150, FlxColor.YELLOW);
		add(this.bulletFactory.group);
	}
	
	public override function flipWeapon(_facingLeft:Bool):Void
	{
		skin.flipX = _facingLeft;
		
		if (bulletFactory != null)
		{
			if (_facingLeft)
			{
				bulletFactory.setBulletDirection(FlxWeapon.BULLET_LEFT, 0);
				bulletFactory.setBulletOffset(0, 0);
			}
			else
			{
				bulletFactory.setBulletDirection(FlxWeapon.BULLET_RIGHT, 0);
				bulletFactory.setBulletOffset(0, 0);
			}
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