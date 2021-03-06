package weapons.hero_weapons;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.loaders.SparrowData;
import flixel.FlxG;
import player.Splash;
import weapons.BaseWeapon;
import ennemies.BaseEnnemy;
import utils.Collider;
import flixel.util.FlxMath;

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
	}
	
	public override function update()
	{
		FlxG.overlap(this.bulletFactory.group, Reg.ennemyGroup, applyDamage);
		FlxG.overlap(this.bulletFactory.group, Reg.bigCrystalsGroup, breakCrystal);
		
		super.update();
	}
	
	private override function applyDamage(_obj1:FlxObject, _obj2:FlxObject)
	{
		// apply damage to the ennemy
		if (Type.getClassName(Type.getClass(_obj2)) == "utils.Collider")
		{
			var point:FlxPoint = new FlxPoint(_obj1.x + (_obj2.x - _obj1.x) / 2, _obj1.y + (_obj2.y - _obj1.y) / 2);
			var splash:Splash = new Splash(point);
			add(splash);
			splash.play();
			
			var collider = cast(_obj2, Collider);
			var ennemy = cast(collider.parent, BaseEnnemy);
			ennemy.hurt(this.bulletFactory.bulletDamage);
			FlxG.sound.play("assets/sounds/hero_hit.mp3", 0.6);
		}
		
		super.applyDamage(_obj1, _obj2);
	}
	
	private function breakCrystal(_obj1:FlxObject, _obj2:FlxObject):Void
	{
		var point:FlxPoint = new FlxPoint(_obj1.x + (_obj2.x - _obj1.x) / 2, _obj1.y + (_obj2.y - _obj1.y) / 2);
		var splash:Splash = new Splash(point);
		add(splash);
		splash.play();
		
		_obj1.kill();
		_obj2.hurt(this.bulletFactory.bulletDamage);
	}
	
	private function checkEndOfFire(_name:String, _frameNumber:Int, _frameIndex:Int):Void
	{
		if (_frameNumber == 5)
		{
			firing = false;
			
			if (skin.animation.curAnim == null || skin.animation.curAnim.name != currentAnim)
			{
				skin.animation.play(currentAnim);
				if (skin.animation.curAnim != null)
				{
					skin.animation.curAnim.frameRate = currentAnimFrameRate;
					skin.animation.curAnim.curIndex = parent.animation.frameIndex;
				}
			}
			
			skin.animation.callback = null;
		}
	}
	
	public override function moveWeapon(_x:Float, _y:Float)
	{
		if (this.bulletFactory.currentBullet != null)
		{
			this.bulletFactory.currentBullet.x += _x - skin.x;
			this.bulletFactory.currentBullet.y += _y - skin.y;
		}
		
		skin.x = _x;
		skin.y = _y;
		
		bulletFactory.bounds = FlxG.camera.bounds;
	}
}