package weapons.hero_weapons;
import flixel.FlxSprite;
import flixel.util.loaders.SparrowData;
import weapons.BaseWeapon;

/**
 * ...
 * @author Ynk33
 */
class BaseHeroWeapon extends BaseWeapon
{
	private var spritePath:String;
	private var spriteXML:String;
	public var skin:FlxSprite;
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
	
	public override function fire():Void
	{
		firing = true;
		skin.animation.play("fire");
		skin.animation.curAnim.frameRate = 30;
		skin.animation.callback = checkEndOfFire;
		
		super.fire();
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
	
	public override function flipWeapon(_facingLeft:Bool):Void
	{
		skin.flipX = _facingLeft;
		
		super.flipWeapon(_facingLeft);
	}
	
	public override function moveWeapon(_x:Float, _y:Float)
	{
		if (this.bulletFactory.currentBullet != null)
		{
			this.bulletFactory.currentBullet.x += _x - skin.x;
			this.bulletFactory.currentBullet.y += _y - skin.y;
		}
		
		bulletFactory.bounds.x = _x - parent.width;
		bulletFactory.bounds.y = _y - parent.width;
		
		skin.x = _x;
		skin.y = _y;
	}
}