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
class Staff extends BaseWeapon
{
	private static var spritePath:String = "";
	
	public function new(_parent:Hero) 
	{
		super(_parent.hitbox);
		
		skin = new FlxSprite(0, 0);
		skin.makeGraphic(10, 50, FlxColor.BLACK);
		add(skin);
		
		bulletWidth = 50;
		
		this.bulletFactory = new FlxWeapon("staff", skin);
		this.bulletFactory.bulletDamage = 1;
		this.bulletFactory.setBulletLifeSpan(0.1);
		this.bulletFactory.setBulletDirection(FlxWeapon.BULLET_RIGHT, 0);
		this.bulletFactory.makePixelBullet(2, bulletWidth, 150, FlxColor.YELLOW);
		add(this.bulletFactory.group);
	}
	
	public override function kill()
	{
		if (!alive)
		{
			return;
		}
	}
}