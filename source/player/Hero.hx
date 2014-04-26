package player;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;

/**
 * ...
 * @author Ynk33
 */
class Hero extends FlxGroup
{
	public static inline var RUN_SPEED:Int = 90;
	public static inline var GRAVITY:Int = 620;
	public static inline var JUMP_SPEED:Int = 250;
	
	private var head:FlxSprite;
	private var body:FlxSprite;
	private var legs:FlxSprite;
	public var hitbox:FlxSprite;
	
	private var jumpTime:Float = -1;
	private var timesJumped:Int = 0;
	private var jumpKeys:Array<String>;
	private var leftKeys:Array<String>;
	private var rightKeys:Array<String>;
	
	public function new() 
	{
		super();
		
		// create hitbox
		hitbox = new FlxSprite();
		hitbox.makeGraphic(17, 33, FlxColor.GREEN);
		add(hitbox);
		
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
		placeMembers();
		
		// set parameters
		hitbox.drag.set(RUN_SPEED * 8, RUN_SPEED * 8);
		hitbox.maxVelocity.set(RUN_SPEED, JUMP_SPEED);
		hitbox.acceleration.set(0, GRAVITY);
		
		// set keys
		jumpKeys = ["SPACE", "Z", "UP"];
		leftKeys = ["LEFT", "Q"];
		rightKeys = ["RIGHT", "D"];
	}
	
	public override function update():Void
	{
		hitbox.acceleration.x = 0;
		
		if (FlxG.keys.anyPressed(leftKeys))
		{
			head.flipX = true;
			body.flipX = true;
			legs.flipX = true;
			hitbox.acceleration.x = -hitbox.drag.x;
		}
		else if (FlxG.keys.anyPressed(rightKeys))
		{
			head.flipX = false;
			body.flipX = false;
			legs.flipX = false;
			hitbox.acceleration.x = hitbox.drag.x;
		}
		
		jump();
		
		// limit to the map
		if (hitbox.x <= 0)
		{
			hitbox.x = 0;
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
		if (FlxG.keys.anyPressed(jumpKeys))
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
	}
}