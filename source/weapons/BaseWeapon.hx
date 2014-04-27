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
	private var spritePath:String;
	private var spriteXML:String;
	private var bulletFactory:FlxWeapon;
	private var bulletWidth:Int;
	public var skin:FlxSprite;
	private var parent:FlxSprite;
	public var firing:Bool = false;
	public var currentAnim:String;
	public var currentAnimFrameRate:Int;
	
	public function new(_parent:FlxSprite) 
	{
		super();
		
		this.parent = _parent;
		
		// load animation
		var animation = new SparrowData(spriteXML, spritePath);
		skin = new FlxSprite();
		skin.loadGraphicFromTexture(animation);
		skin.animation.addByPrefix("idle", "LD29_hero_arm_1_waitR", 75);
		skin.animation.addByPrefix("run", "LD29_hero_arm_1_runR", 12);
		skin.animation.addByPrefix("jump", "LD29_hero_arm_1_jumpR", 6, false);
		skin.animation.addByPrefix("fall", "LD29_hero_arm_1_airR", 1);
		skin.animation.addByPrefix("land", "LD29_hero_arm_1_fallR", 10, false);
		skin.animation.addByPrefix("fire", "LD29_hero_arm_fire", 6, false);
		add(skin);
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
		firing = true;
		skin.animation.play("fire");
		skin.animation.curAnim.frameRate = 30;
		skin.animation.callback = checkEndOfFire;
		this.bulletFactory.fire();
	}
	
	private function checkEndOfFire(_name:String, _frameNumber:Int, _frameIndex:Int):Void
	{
		if (_frameNumber == 5)
		{
			firing = false;
			
			trace (currentAnim);
			skin.animation.play(currentAnim);
			skin.animation.curAnim.frameRate = currentAnimFrameRate;
			skin.animation.curAnim.curIndex = parent.animation.frameIndex;
			skin.animation.callback = null;
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
		if (this.bulletFactory.currentBullet != null)
		{
			this.bulletFactory.currentBullet.x += _x - skin.x;
			this.bulletFactory.currentBullet.y += _y - skin.y;
		}
		
		skin.x = _x;
		skin.y = _y;
		
		bulletFactory.bounds.x = _x - parent.width;
		bulletFactory.bounds.y = _y - parent.width;
		
	}
	
}