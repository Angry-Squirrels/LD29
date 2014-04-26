package universe;
import flixel.FlxG;


import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxTextField;

/**
 * ...
 * @author damrem
 */
class Space
{
	public var alt:UInt;
	public var long:Int;
	//public var mask:String;
	public var topMask:UInt;
	public var bottomMask:UInt;
	public var leftMask:UInt;
	public var rightMask:UInt;
	var _mask:String;
	
	static inline var BOX_SIZE:Int = 25;
	
	public var neighbors:Array<Space>;
	
	public function new(?Alt:UInt, ?Long:Int) 
	{
		//trace(this, Alt, Long, Mask);
		alt = Alt;
		long = Long;
		neighbors = new Array<Space>();
	}

	public function getNeighborAt(direction:String):Space
	{
		switch(direction)
		{
			case Direction.TOP:
				for (neighbor in neighbors)
				{
					if (neighbor.alt == alt + 1 && neighbor.long == long)	return neighbor;
				}
			case Direction.BOTTOM:
				for (neighbor in neighbors)
				{
					if (neighbor.alt == alt - 1 && neighbor.long == long)	return neighbor;
				}
			case Direction.LEFT:
				for (neighbor in neighbors)
				{
					if (neighbor.alt == alt && neighbor.long == long - 1)	return neighbor;
				}
			case Direction.RIGHT:
				for (neighbor in neighbors)
				{
					if (neighbor.alt == alt && neighbor.long == long + 1)	return neighbor;
				}
		}
		return null;
	}
	
	public function toString():String
	{
		return "[Space("+alt+", "+long+", "+mask+")]";
	}
	
	function get_mask():String 
	{
		return topMask + "" + bottomMask + "" + leftMask + "" + rightMask;
	}
	
	public var mask(get_mask, null):String;
	
	public function getBox():FlxSpriteGroup
	{
		
		
		var X = FlxG.stage.stageWidth / 2 + long * BOX_SIZE;
		var Y = FlxG.stage.stageHeight - 50 - alt * BOX_SIZE;
		var group:FlxSpriteGroup = new FlxSpriteGroup(X, Y);
		//trace("x=" + sprite.x);
		
		group.makeGraphic(BOX_SIZE, BOX_SIZE);
		
		
		var top:FlxTextField = new FlxTextField(10, 
		0, 
		10,
		""+topMask);
		group.add(top);
		
		var bottom:FlxTextField = new FlxTextField(10, 
		15, 
		10,
		""+bottomMask);
		group.add(bottom);
		
		var left:FlxTextField = new FlxTextField(0, 
		10, 
		10,
		""+leftMask);
		group.add(left);
		
		var right:FlxTextField = new FlxTextField(15, 
		10, 
		10,
		""+rightMask);
		group.add(right);
		
		
		return group;
	}
	
}