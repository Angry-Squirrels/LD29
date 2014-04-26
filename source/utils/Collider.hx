package utils;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import player.Hero;

/**
 * ...
 * @author Ynk33
 */
class Collider extends FlxSprite
{
	public var parent:FlxBasic;
	
	public function new(_x:Int, _y:Int, _parent:FlxBasic) 
	{
		super(_x, _y);
		this.parent = _parent;
	}
	
}