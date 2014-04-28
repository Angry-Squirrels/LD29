package weapons.hero_weapons;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.loaders.SparrowData;
import flixel.FlxG;
import weapons.BaseWeapon;
import ennemies.BaseEnnemy;
import utils.Collider;

/**
 * ...
 * @author Ynk33
 */
class BaseHeroWeapon extends BaseWeapon
{
	private var spritePath:String;
	private var spriteXML:String;
	public var firing:Bool = false;
	public var currentAnim:String;
	public var currentAnimFrameRate:Int;
	
	public function new(_parent:FlxSprite) 
	{
		super(_parent);
		
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
	
	private override function applyDamage(_obj1:FlxObject, _obj2:FlxObject)
	{
		super.applyDamage(_obj1, _obj2);
		
		// apply damage to the ennemy
		if (Type.getClassName(Type.getClass(_obj2)) == "utils.Collider")
		{
			var collider = cast(_obj2, Collider);
			var ennemy = cast(collider.parent, BaseEnnemy);
			ennemy.hurt(this.bulletFactory.bulletDamage);
			FlxG.sound.play("assets/sounds/hero_hit.mp3", 0.6);
		}
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
		
		super.fire();
	}
	
	private function checkEndOfFire(_name:String, _frameNumber:Int, _frameIndex:Int):Void
	{
		if (_frameNumber == 5)
		{
			firing = false;
			
			if (skin.animation.curAnim == null || skin.animation.curAnim.name != currentAnim)
			{
				skin.animation.play(currentAnim);
				skin.animation.curAnim.frameRate = currentAnimFrameRate;
				skin.animation.curAnim.curIndex = parent.animation.frameIndex;
			}
			
			skin.animation.callback = null;
		}
	}
	
	public override function moveWeapon(_x:Float, _y:Float)
	{
		skin.x = _x;
		skin.y = _y;
		
		if (this.bulletFactory.currentBullet != null)
		{
			this.bulletFactory.currentBullet.x = skin.flipX ? skin.x - bulletWidth + 32 : skin.x + parent.width - 32;
			this.bulletFactory.currentBullet.y = skin.y;
		}
		
		bulletFactory.bounds.x = _x - bulletWidth - 5;
		bulletFactory.bounds.y = _y - bulletWidth - 5;
	}
}