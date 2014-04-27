package universe;
import flash.display.CapsStyle;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxTextField;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil.FillStyle;
import flixel.util.FlxSpriteUtil.LineStyle;



/**
 * ...
 * @author damrem
 */
class LevelDef
{
	public static var verbose:Bool;
	public var alt:Int;
	public var long:Int;
	private var _explored : Bool;
	//public var mask:String;
	public var topMask:UInt;
	public var bottomMask:UInt;
	public var leftMask:UInt;
	public var rightMask:UInt;
	var _mask:String;
	
	public var level:Level;
	public var branchLevel:UInt;
	
	public var debugColor:UInt = 0x80ff0000;
	
	static inline var DEBUGBOX_SIZE:Int = 25;
	static public inline var MINIBOX_SIZE:UInt = 25;
	
	
	public var neighbors:Array<LevelDef>;
	
	public function new(?Alt:UInt, ?Long:Int, BranchLevel:UInt=0) 
	{
		branchLevel = BranchLevel;
		//if(verbose) trace(this, Alt, Long, Mask);
		alt = Alt;
		long = Long;
		neighbors = new Array<LevelDef>();
	}

	public function getNeighborAt(direction:String):LevelDef
	{
		if(verbose) trace("getNeighborAt(" + direction);
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
				if(verbose) trace(neighbors);
				for (neighbor in neighbors)
				{
					if (neighbor.alt == alt && neighbor.long == long + 1)	return neighbor;
				}
		}
		return null;
	}
	
	public function toString():String
	{
		return "[Space("+alt+", "+long+"; "+branchLevel+")]";
	}
	
	function get_mask():String 
	{
		return topMask + "" + bottomMask + "" + leftMask + "" + rightMask;
	}
	
	public var mask(get_mask, null):String;
	
	function get_explored():Bool 
	{
		return _explored;
	}
	
	function set_explored(value:Bool):Bool 
	{
		this.miniDoors.visible = value;
		this.miniRooms.visible = value;
		return _explored = value;
	}
	
	public var explored(get_explored, set_explored):Bool;
	
	var line:LineStyle = { thickness:1, color:0xff0000, pixelHinting:true, scaleMode:LineScaleMode.NORMAL, capsStyle:CapsStyle.NONE, jointStyle:JointStyle.MITER, miterLimit:1 };
	var fill:FillStyle = { hasFill:true, color:0xff0000, alpha:1 };
	
	var COLORS:Array<UInt> = [0x80ff0000, 0x8000ff00, 0x800000ff];
	
	public function getDebugBox():FlxSpriteGroup
	{
		
		
		var X = FlxG.stage.stageWidth / 2 + long * DEBUGBOX_SIZE;
		var Y = FlxG.stage.stageHeight - 50 - alt * DEBUGBOX_SIZE;
		var group:FlxSpriteGroup = new FlxSpriteGroup(X, Y);
		//if(verbose) trace("x=" + sprite.x);
		
		var box:FlxSprite = new FlxSprite(1, 1);
		//box.angle = branchLevel * 30;
		box.makeGraphic(DEBUGBOX_SIZE-2, DEBUGBOX_SIZE-2, debugColor);
		
		//var box:FlxShapeBox = new FlxShapeBox(0, 0, BOX_SIZE, BOX_SIZE, line, fill);
		group.add(box);
		
		//var coord:FlxTextField = new FlxTextField(0, 0, BOX_SIZE, alt+","+long);
		//group.add(coord);
		
		
		var top:FlxTextField = new FlxTextField(7, -7, 10, topMask==1?"x":"");
		group.add(top);
		
		var bottom:FlxTextField = new FlxTextField(7, 18, 10, bottomMask==1?"x":"");
		group.add(bottom);
		
		var left:FlxTextField = new FlxTextField(-5, 7, 10, leftMask==1?"x":"");
		group.add(left);
		
		var right:FlxTextField = new FlxTextField(20, 7, 10, rightMask==1?"x":"");
		group.add(right);
		
		
		return group;
	}
	
	var miniRooms:FlxSpriteGroup;
	var miniDoors:FlxSpriteGroup;
	public function getMiniRooms():FlxSpriteGroup
	{
		var X = FlxG.stage.stageWidth / 2 + long * MINIBOX_SIZE;
		var Y = FlxG.stage.stageHeight - 50 - alt * MINIBOX_SIZE;
		
		if (miniRooms == null)
		{
		
			var box:FlxSprite = new FlxSprite(1, 1);
			box.angle = FlxRandom.intRanged( -5, 5);
			box.makeGraphic(MINIBOX_SIZE-2, MINIBOX_SIZE-2, 0xffff0000);
			miniRooms = new FlxSpriteGroup(X, Y);
			miniRooms.add(box);
		}
		
		return miniRooms;
	}
	
	
	public function getMiniDoors():FlxSpriteGroup
	{
		var X = FlxG.stage.stageWidth / 2 + long * MINIBOX_SIZE;
		var Y = FlxG.stage.stageHeight - 50 - alt * MINIBOX_SIZE;
		
		if (miniDoors == null)
		{
			miniDoors = new FlxSpriteGroup(X, Y);
			miniDoors.scrollFactor.set(0, 0);
			
			if (topMask >= 1)
			{
				var top:FlxSprite = new FlxSprite(10, -5);
				top.angle = FlxRandom.intRanged( -5, 5);
				top.makeGraphic(5, 10, 0xffffffff);
				miniDoors.add(top);
			}
			
			if (bottomMask >= 1)
			{
				var bottom:FlxSprite = new FlxSprite(10, 20);
				bottom.angle = FlxRandom.intRanged( -5, 5);
				bottom.makeGraphic(5, 10, 0xffffffff);
				miniDoors.add(bottom);
			}
			
			if (leftMask >= 1)
			{
				var left:FlxSprite = new FlxSprite( -5, 10);
				left.angle = FlxRandom.intRanged( -5, 5);
				left.makeGraphic(10, 5, 0xffffffff);
				miniDoors.add(left);
			}
			
			if (rightMask >= 1)
			{
				var right:FlxSprite = new FlxSprite(20, 10);
				right.angle = FlxRandom.intRanged( -5, 5);
				right.makeGraphic(10, 5, 0xffffffff);
				miniDoors.add(right);
			}
		}
		return miniDoors;
	}
	
}