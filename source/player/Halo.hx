package player;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;

/**
 * ...
 * @author Ynk33
 */
class Halo extends FlxGroup
{
	private var mainSprite:FlxSprite;
	private var topSprite:FlxSprite;
	private var leftSprite:FlxSprite;
	private var bottomSprite:FlxSprite;
	private var rightSprite:FlxSprite;
	
	private var hero:FlxSprite;
	
	public function new(_hero:FlxSprite) 
	{
		super();
		
		hero = _hero;
		
		mainSprite = new FlxSprite();
		topSprite = new FlxSprite();
		leftSprite = new FlxSprite();
		rightSprite = new FlxSprite();
		bottomSprite = new FlxSprite();
		mainSprite.loadGraphic(FlxAssets.getBitmapData("assets/images/Effects/halo.png"));
		topSprite.makeGraphic(1500, 500, FlxColor.BLACK);
		leftSprite.makeGraphic(500, 1500, FlxColor.BLACK);
		rightSprite.makeGraphic(500, 1500, FlxColor.BLACK);
		bottomSprite.makeGraphic(1500, 500, FlxColor.BLACK);
		
		add(mainSprite);
		add(topSprite);
		add(leftSprite);
		add(rightSprite);
		add(bottomSprite);
		
		place();
	}
	
	public function place():Void
	{
		mainSprite.x = hero.x - (mainSprite.width - hero.width) / 2;
		mainSprite.y = hero.y - (mainSprite.height - hero.height) / 2;
		
		topSprite.x = mainSprite.x - (topSprite.width - mainSprite.width);
		topSprite.y = mainSprite.y - topSprite.height;
		
		leftSprite.x = mainSprite.x - leftSprite.width;
		leftSprite.y = mainSprite.y;
		
		rightSprite.x = mainSprite.x + mainSprite.width;
		rightSprite.y = mainSprite.y - rightSprite.width;
		
		bottomSprite.x = mainSprite.x;
		bottomSprite.y = mainSprite.y + mainSprite.height;
	}
}