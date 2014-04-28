package weapons.hero_weapons;

import flixel.addons.weapon.FlxWeapon;
import flixel.addons.weapon.FlxBullet;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import player.Hero;
import weapons.BaseWeapon;
import flixel.FlxG;
import flixel.system.FlxAssets;

/**
 * ...
 * @author Ynk33
 */
class Staff extends BaseHeroWeapon
{
	private var hero:Hero;
	
	private var bulletSpeed:Int;
	
	private var firedBullets:Array<FlxBullet>;
	
	public function new(_parent:Hero) 
	{
		spritePath = "assets/Weapons/hero_arm.png";
		spriteXML = "assets/Weapons/hero_arm.xml";
		
		super(_parent.body);
		
		hero = _parent;
		
		bulletSpeed = 600;
		fireRate = 0.25;
		
		this.bulletFactory = new FlxWeapon("staff", skin);
		this.bulletFactory.bulletDamage = 1;
		this.bulletFactory.setBulletLifeSpan(0.1);
		this.bulletFactory.setBulletDirection(FlxWeapon.BULLET_RIGHT, bulletSpeed);
		this.bulletFactory.makeImageBullet(5, FlxAssets.getBitmapData("assets/images/Effects/LD29_onde.png"));
		add(this.bulletFactory.group);
		
		firedBullets = new Array<FlxBullet>();
	}
	
	public override function update():Void
	{
		for (bullet in firedBullets)
		{
			bullet.alpha -= 0.2;
		}
		
		super.update();
	}
	
	public override function fire():Void
	{
		firing = true;
		skin.animation.play("fire");
		skin.animation.curAnim.frameRate = 30;
		skin.animation.callback = checkEndOfFire;
		
		if (elapsedTime > fireRate)
		{
			FlxG.sound.play("assets/sounds/hero_swoosh.mp3", 0.6);
		}
	}
	
	private override function checkEndOfFire(_anim:String, _frameNumber:Int, _frameIndex:Int):Void
	{
		if (_anim == "fire")
		{
			if (_frameNumber == 4)
			{
				super.fire();
				this.bulletFactory.currentBullet.flipX = skin.flipX;
				this.bulletFactory.currentBullet.alpha = 1;
				if (firedBullets.indexOf(this.bulletFactory.currentBullet) == -1)
				{
					firedBullets.push(this.bulletFactory.currentBullet);
				}
			}
		}
		
		super.checkEndOfFire(_anim, _frameNumber, _frameIndex);
	}
	
	public override function flipWeapon(_facingLeft:Bool):Void
	{
		skin.flipX = _facingLeft;
		
		if (bulletFactory != null)
		{
			if (_facingLeft)
			{
				bulletFactory.setBulletDirection(FlxWeapon.BULLET_LEFT, bulletSpeed);
				bulletFactory.setBulletOffset(0, 20);
			}
			else
			{
				bulletFactory.setBulletDirection(FlxWeapon.BULLET_RIGHT, bulletSpeed);
				bulletFactory.setBulletOffset(85, 20);
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