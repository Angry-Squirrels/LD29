package player;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import utils.Collider;
import weapons.BaseWeapon;
import weapons.Staff;

/**
 * ...
 * @author Ynk33
 */
class Hero extends FlxGroup
{
	public static inline var RUN_SPEED:Int = 500;
	public static inline var GRAVITY:Int = 980;
	public static inline var JUMP_SPEED:Int = 650;
	
	private var head:FlxSprite;
	private var body:FlxSprite;
	private var legs:FlxSprite;
	public var hitbox:Collider;
	
	private var jumpTime:Float = -1;
	private var timesJumped:Int = 0;
	private var jumpKeys:Array<String>;
	private var leftKeys:Array<String>;
	private var rightKeys:Array<String>;
	
	private var currentWeapon:BaseWeapon;
	public var onJumpThrough : Bool;
	
	public function new(_x:Int, _y:Int) 
	{
		super();
		
		// create hitbox
		hitbox = new Collider(_x, _y, this);
		hitbox.makeGraphic(64, 128, FlxColor.GREEN);
		add(hitbox);
		
		this.onJumpThrough = false;
		
		// create composed FlxSprite Hero
		head = new FlxSprite();
		body = new FlxSprite();
		legs = new FlxSprite();
		head.makeGraphic(7, 7, FlxColor.WHITE);
		body.makeGraphic(15, 15, FlxColor.RED);
		legs.makeGraphic(5, 10, FlxColor.BLUE);
		add(head);
		add(body);
		add(legs);
		
		// set parameters
		hitbox.drag.set(RUN_SPEED * 8, RUN_SPEED * 8);
		hitbox.maxVelocity.set(RUN_SPEED, JUMP_SPEED);
		hitbox.acceleration.set(0, GRAVITY);
		
		// set keys
		jumpKeys = ["SPACE", "Z", "UP"];
		leftKeys = ["LEFT", "Q"];
		rightKeys = ["RIGHT", "D"];
		
		// create weapon
		this.currentWeapon = new Staff(this);
		this.add(currentWeapon);
		
		placeMembers();
	}
	
	public override function update():Void
	{
		hitbox.acceleration.x = 0;
		
		if (FlxG.keys.anyPressed(leftKeys))
		{
			flipHero(true);
			hitbox.acceleration.x = -hitbox.drag.x;
		}
		else if (FlxG.keys.anyPressed(rightKeys))
		{
			flipHero(false);
			hitbox.acceleration.x = hitbox.drag.x;
		}
		
		jump();
		
		// limit to the map
		if (hitbox.x <= 0)
		{
			hitbox.x = 0;
		}
		
		// check attack
		if (FlxG.mouse.justPressed)
		{
			currentWeapon.fire();
		}
		
		placeMembers();
		
		super.update();
	}
	
	public override function kill():Void
	{
		if (!this.alive)
		{
			return;
		}
		
		super.kill();
	}
	
	private function jump():Void
	{
		if (FlxG.keys.anyJustPressed(jumpKeys) && hitbox.isTouching(FlxObject.FLOOR))
		{
			if (hitbox.velocity.y == 0)
			{
				hitbox.velocity.y = -hitbox.maxVelocity.y;
			}
		}
	}
	
	private function placeMembers():Void
	{
		head.x = hitbox.x + 1 + (body.width - head.width) / 2;
		head.y = hitbox.y + 1;
		body.x = hitbox.x + 1;
		body.y = hitbox.y + 1 + head.height;
		legs.x = hitbox.x + 1 + (body.width - legs.width) / 2;
		legs.y = hitbox.y + 1 + head.height + body.height;
		
		currentWeapon.skin.x = body.x + body.width;
		currentWeapon.skin.y = body.y - currentWeapon.skin.height + 5;
	}
	
	private function flipHero(_facingLeft:Bool):Void
	{
		head.flipX = _facingLeft;
		body.flipX = _facingLeft;
		legs.flipX = _facingLeft;
		currentWeapon.flipWeapon(_facingLeft);
	}
}