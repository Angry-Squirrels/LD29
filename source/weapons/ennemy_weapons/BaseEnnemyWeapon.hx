package weapons.ennemy_weapons;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.addons.weapon.FlxWeapon;
import weapons.BaseWeapon;
import player.Hero;
import flixel.FlxObject;
import utils.Collider;
import flixel.FlxG;

/**
 * ...
 * @author Ynk33
 */
class BaseEnnemyWeapon extends BaseWeapon
{
	public function new(_parent:FlxSprite, _bulletWidth:Int, _bulletDamage:Float) 
	{
		super(_parent);
		
		bulletWidth = _bulletWidth;
		fireRate = 0;
		
		skin = new FlxSprite();
		skin.makeGraphic(10, 10, FlxColor.BLACK);
		add(skin);
		
		
		this.bulletFactory = new FlxWeapon("ennemy_weapon", skin);
		this.bulletFactory.bulletDamage = _bulletDamage;
		this.bulletFactory.setBulletLifeSpan(0.1);
		this.bulletFactory.setBulletDirection(FlxWeapon.BULLET_RIGHT, 0);
		this.bulletFactory.makePixelBullet(2, bulletWidth, Std.int(_parent.height), FlxColor.TRANSPARENT);
		add(this.bulletFactory.group);
	}
	
	public override function fire():Void
	{
		super.fire();
	}
	
	public override function update()
	{
		FlxG.overlap(this.bulletFactory.group, Reg.hero, applyDamage);
		
		super.update();
	}
	
	private override function applyDamage(_obj1:FlxObject, _obj2:FlxObject)
	{
		super.applyDamage(_obj1, _obj2);
		
		// apply damage to the hero
		if (Type.getClassName(Type.getClass(_obj2)) == "utils.Collider")
		{
			var collider = cast(_obj2, Collider);
			var hero = cast(collider.parent, Hero);
			hero.hurt(this.bulletFactory.bulletDamage);
			FlxG.sound.play("assets/sounds/ennemy_hit.mp3");
		}
	}
	
	public override function flipWeapon(_facingLeft:Bool):Void
	{
		super.flipWeapon(_facingLeft);
	}
	
	public function blockWeaponFor(_time:Float):Void
	{
		elapsedTime = fireRate - _time;
	}
	
}