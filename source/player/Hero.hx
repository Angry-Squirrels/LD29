package player;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * ...
 * @author Ynk33
 */
class Hero extends FlxSprite
{
	public static inline var RUN_SPEED:Int = 90;
	public static inline var GRAVITY:Int = 620;
	public static inline var JUMP_SPEED:Int = 250;
	
	private var head:FlxSprite;
	private var body:FlxSprite;
	private var legs:FlxSprite;
	
	public function new(_x:Int, _y:Int,) 
	{
		super(_x, _y);
		
		head = new FlxSprite();
		body = new FlxSprite();
		legs = new FlxSprite();
		
		head.makeGraphic(7, 7, FlxColor.WHITE);
		body.makeGraphic(15, 15, FlxColor.RED);
		legs.makeGraphic(5, 10, FlxColor.BLUE);
		
		add(head);
		add(body);
		add(legs);
		
		head.x = (body.width - head.width) / 2;
		head.y = 0;
		body.x = 0;
		body.y = head.height;
		legs.x = (body.width - legs.width) / 2;
		legs.y = head.height + body.height;
	}
	
	public override function update()
	{
		super.update();
	}
	
	public override function kill()
	{
		if (!this.alive)
		{
			return;
		}
		
		super.kill();
	}
	
}