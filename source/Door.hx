package ;
import flixel.FlxSprite;
import flixel.tweens.misc.NumTween;
import haxe.xml.Fast;

/**
 * ...
 * @author TBaudon
 */
class Door extends FlxSprite
{
	
	public var dest:String;
	public var destX:Int;
	public var destY:Int;

	public function new(data:Fast, x : Int, y:Int) 
	{
		super(x, y);
		makeGraphic(32, 32, 0xffffff00);
		
		var elem = data.node.properties.elements;
		var node = elem.next();
		destX = Std.parseInt(node.att.value);
		node = elem.next();
		destY = Std.parseInt(node.att.value);
		node = elem.next();
		dest = node.att.value;
		node = elem.next();
		destX = Std.parseInt(node.att.value);
		node = elem.next();
		destY = Std.parseInt(node.att.value);
		
	}
	
}