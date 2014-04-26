package universe;
import flixel.addons.display.shapes.FlxShapeBox;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxSpriteUtil.FillStyle;
import flixel.util.FlxSpriteUtil.LineStyle;
import flixel.FlxG;
import flash.display.LineScaleMode;
import flash.display.CapsStyle;
import flash.display.JointStyle;

/**
 * ...
 * @author damrem
 */
class TreeState extends FlxState
{
	var line:LineStyle = { thickness:1, color:0xff0000, pixelHinting:true, scaleMode:LineScaleMode.NORMAL, capsStyle:CapsStyle.NONE, jointStyle:JointStyle.MITER, miterLimit:1 };
	var fill:FillStyle = { hasFill:true, color:0xff0000, alpha:1 };
		
	
	
	override public function create() 
	{
		super.create();
		
	}
	
	function createTree()
	{
		var tree = new LevelTree(100);
		
		for (i in 0...tree.spaces.length)
		{
			//trace("i:" + i);
			var space:Space = tree.spaces[i];
			add(createBox(space.alt, space.long));
		}
	}
	
	function createBox(altitude:UInt, longitude:Int):FlxSprite
	{
		var sprite = new FlxSprite();
		sprite.x = FlxG.stage.stageWidth / 2 + longitude * 10;
		//trace("x=" + sprite.x);
		sprite.y = FlxG.stage.stageHeight - 50 - altitude * 10;
		
		sprite.makeGraphic(10, 10);
		sprite.alpha = 0.5;
		return sprite;
		//return new FlxShapeBox(X, Y, 10, 10, line, fill);
		
	}
	
	override public function update()
	{
		super.update();
		if (FlxG.mouse.justReleased)
		{
			clear();
			createTree();
		}
	}
	
}