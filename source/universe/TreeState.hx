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
	public static var verbose:Bool;
	
	var line:LineStyle = { thickness:1, color:0xff0000, pixelHinting:true, scaleMode:LineScaleMode.NORMAL, capsStyle:CapsStyle.NONE, jointStyle:JointStyle.MITER, miterLimit:1 };
	var fill:FillStyle = { hasFill:true, color:0xff0000, alpha:1 };
	var tree:LevelTree;
		
	static inline var BOX_SIZE:Int = 25;
	
	override public function create() 
	{
		super.create();
		tree = createTree();
		
	}
	
	function createTree()
	{
		if(verbose) trace("createTree");
		
		var _tree = new LevelTree(10, new PlayState());
		
		for (i in 0..._tree.defs.length)
		{
			//if(verbose) trace("i:" + i);
			var def:LevelDef = _tree.defs[i];
			//add(createBox(space.alt, space.long));
			add(def.getBox());
		}
		
		return _tree;
	}
	
	function createBox(altitude:UInt, longitude:Int):FlxSprite
	{
		var sprite = new FlxSprite();
		sprite.x = FlxG.stage.stageWidth / 2 + longitude * BOX_SIZE;
		//if(verbose) trace("x=" + sprite.x);
		sprite.y = FlxG.stage.stageHeight - 50 - altitude * BOX_SIZE;
		
		sprite.makeGraphic(BOX_SIZE, BOX_SIZE);
		sprite.alpha = 0.5;
		return sprite;
		//return new FlxShapeBox(X, Y, 10, 10, line, fill);
		
	}
	
	override public function update()
	{
		super.update();
		if (FlxG.mouse.justReleased)
		{
			//remove(tree);
			clear();
			tree = createTree();
			//if(verbose) trace(tree.spaces[5].neighbors);
			//if(verbose) trace(FlxG.mouse.
		}
	}
	
}