package ennemies;
import flixel.FlxBasic;
import haxe.xml.Fast;

/**
 * ...
 * @author damrem
 */
class SpawningPoint extends FlxBasic
{
	public var x:Int;
	public var y:Int;
	
	public var type:String;
	
	public var used:Bool;
	
	public function new(data:Fast, X:Int, Y:Int) 
	{
		super();
		x = X;
		y = Y;
		var elem = data.node.properties.elements;
		var node = elem.next();
		type = node.att.value;		
		trace(this);
	}
	
	override public function toString():String
	{
		return "[SpawningPoint (" + x + ", " + y + ", " + type + ")]";
	}
	
	
}