package player;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.loaders.SparrowData;
import states.DieState;
import utils.Collider;
import weapons.BaseWeapon;
import weapons.hero_weapons.BaseHeroWeapon;
import weapons.hero_weapons.Staff;

/**
 * ...
 * @author Ynk33
 */
class Hero extends FlxGroup
{
	public static inline var RUN_SPEED:Int = 500;
	public static inline var JUMP_SPEED:Int = 620;
	
	public static inline var IDLE:Int = 0;
	public static inline var RUN:Int = 1;
	public static inline var JUMP:Int = 2;
	public static inline var FALL:Int = 3;
	public static inline var LAND:Int = 4;
	
	private var currentState:Int;
	
	private var head:FlxSprite;
	public var body:FlxSprite;
	public var hitbox:Collider;
	
	private var jumpTime:Float = -1;
	private var timesJumped:Int = 0;
	private var jumpKeys:Array<String>;
	private var leftKeys:Array<String>;
	private var rightKeys:Array<String>;
	
	private var currentWeapon:BaseHeroWeapon;
	public var canJumpThrough : Bool;
	
	public function new(_x:Int, _y:Int) 
	{
		super();
		
		// create hitbox
		hitbox = new Collider(_x, _y, this);
		hitbox.makeGraphic(80, 118, FlxColor.GREEN);
		add(hitbox);
		
		this.canJumpThrough = false;
		
		// create composed FlxSprite Hero
		head = new FlxSprite();
		body = new FlxSprite();
		
		// load animation
		var headAnimation = new SparrowData("assets/Hero/hero_head.xml", "assets/Hero/hero_head.png");
		head.loadGraphicFromTexture(headAnimation);
		head.animation.addByPrefix("idle", "LD29_hero_head_waitR", 75);
		head.animation.addByPrefix("run", "LD29_hero_head_runR", 12);
		head.animation.addByPrefix("jump", "LD29_hero_head_jumpR", 6, false);
		head.animation.addByPrefix("fall", "LD29_hero_head_airR", 1);
		head.animation.addByPrefix("land", "LD29_hero_head_fallR", 10, false);
		
		var bodyAnimation = new SparrowData("assets/Hero/hero_body.xml", "assets/Hero/hero_body.png");
		body.loadGraphicFromTexture(bodyAnimation);
		body.animation.addByPrefix("idle", "LD29_hero_body_waitR", 75);
		body.animation.addByPrefix("run", "LD29_hero_body_runR", 12);
		body.animation.addByPrefix("jump", "LD29_hero_body_jumpR", 6, false);
		body.animation.addByPrefix("fall", "LD29_hero_body_airR", 1);
		body.animation.addByPrefix("land", "LD29_hero_body_fallR", 10, false);
		
		add(body);
		add(head);
		
		currentState = Hero.IDLE;
		
		// set parameters
		hitbox.drag.set(RUN_SPEED * 8, JUMP_SPEED * 8);
		hitbox.maxVelocity.set(RUN_SPEED, JUMP_SPEED);
		hitbox.acceleration.set(0, Reg.GRAVITY);
		
		// set keys
		jumpKeys = ["SPACE", "Z", "UP"];
		leftKeys = ["LEFT", "Q"];
		rightKeys = ["RIGHT", "D"];
		
		// create weapon
		this.currentWeapon = new Staff(this);
		this.add(currentWeapon);
		currentWeapon.flipWeapon(hitbox.flipX);
		
		placeMembers();
		
		Reg.hero = this;
		
		hitbox.health = Reg.heroStats.health;
	}
	
	public override function update():Void
	{
		hitbox.acceleration.x = 0;
		
		if (FlxG.keys.anyPressed(leftKeys))
		{
			hitbox.acceleration.x = -hitbox.drag.x;
		}
		else if (FlxG.keys.anyPressed(rightKeys))
		{
			hitbox.acceleration.x = hitbox.drag.x;
		}
		
		if (FlxG.keys.pressed.DOWN) {
			canJumpThrough = true;
		}else {
			canJumpThrough = false;
		}
		
		if (hitbox.acceleration.x < 0)
			flipHero(true)
		else if(hitbox.acceleration.x>0)
			flipHero(false);
		
		jump();
		
		// limit to the map
		if (hitbox.x <= 0)
		{
			hitbox.x = 0;
		}
		
		switch (currentState)
		{
			case Hero.IDLE:
				playAnimation("idle");
				
				if (hitbox.velocity.y < 0)
				{
					currentState = Hero.JUMP;
				}
				else if (hitbox.velocity.y > 0)
				{
					currentState = Hero.FALL;
				}
				else if (hitbox.velocity.x != 0)
				{
					currentState = Hero.RUN;
				}
			case Hero.RUN:
				playAnimation("run", 20);
				
				if (hitbox.velocity.y < 0)
				{
					currentState = Hero.JUMP;
				}
				else if (hitbox.velocity.y > 0)
				{
					currentState = Hero.FALL;
				}
				else if (hitbox.velocity.x == 0)
				{
					currentState = Hero.IDLE;
				}
			case Hero.JUMP:
				if (hitbox.velocity.y > 0)
				{
					currentState = Hero.FALL;
				}
			case Hero.FALL:
				playAnimation("fall");
				
				if (hitbox.velocity.y == 0)
				{
					currentState = Hero.LAND;
					playAnimation("land", 30);
				}
			case Hero.LAND:
				if (hitbox.velocity.x != 0)
				{
					currentState = Hero.RUN;
				}
				if (head.animation.finished)
				{
					currentState = Hero.IDLE;
				}
		}
		
		// check attack
		if (FlxG.mouse.justPressed && currentState != Hero.LAND)
		{
			currentWeapon.fire();
		}
		
		placeMembers();
		
		super.update();
	}
	
	public function hurt(_damage:Float):Void
	{
		hitbox.hurt(_damage);
		
		FlxG.camera.flash(0xffbb0000, 0.1);
		FlxG.camera.shake(0.05, 0.1);
		
		Reg.heroStats.health = cast hitbox.health;
		
		if (!hitbox.alive)
		{
			kill();
		}
	}
	
	public override function kill():Void
	{
		if (!this.alive)
		{
			return;
		}
		
		FlxG.camera.fade(0xff000000, 1, false, gotoGameOver);
		
		super.kill();
	}
	
	function gotoGameOver() 
	{
		FlxG.switchState(new DieState());
	}
	
	private function jump():Void
	{
		if (FlxG.keys.anyJustPressed(jumpKeys) && hitbox.isTouching(FlxObject.FLOOR))
		{
			if (hitbox.velocity.y == 0)
			{
				currentState = Hero.JUMP;
				playAnimation("jump", 20);
				hitbox.velocity.y = -hitbox.maxVelocity.y;
			}
		}
	}
	
	private function playAnimation(_anim:String, _speed:Int = 12):Void
	{
		if (head.animation.curAnim == null || head.animation.curAnim.name != _anim)
		{
			head.animation.play(_anim);
			body.animation.play(_anim);
			head.animation.curAnim.frameRate = _speed;
			body.animation.curAnim.frameRate = _speed;
			currentWeapon.currentAnim = _anim;
			currentWeapon.currentAnimFrameRate = _speed;
		}
		if (!currentWeapon.firing)
		{
			if (currentWeapon.skin.animation.curAnim == null || currentWeapon.skin.animation.curAnim.name != _anim)
			{
				currentWeapon.skin.animation.play(_anim);
				currentWeapon.skin.animation.curAnim.curFrame = head.animation.curAnim.curFrame;
				currentWeapon.skin.animation.curAnim.frameRate = _speed;
			}
		}
	}
	
	private function placeMembers():Void
	{
		head.x = body.x = hitbox.x + (hitbox.width - 128) / 2;
		head.y = body.y = hitbox.y - 10;
		
		currentWeapon.moveWeapon(head.x, head.y);
	}
	
	private function flipHero(_facingLeft:Bool):Void
	{
		head.flipX = _facingLeft;
		body.flipX = _facingLeft;
		currentWeapon.flipWeapon(_facingLeft);
	}
}