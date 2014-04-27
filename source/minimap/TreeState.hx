package minimap;
import flash.display.CapsStyle;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSpriteUtil.FillStyle;
import flixel.util.FlxSpriteUtil.LineStyle;
import universe.LevelTree;
import universe.LevelDef;

/**
 * ...
 * @author damrem
 */
class TreeState extends FlxState
{
	public static var verbose:Bool=true;
	
	var line:LineStyle = { thickness:1, color:0xff0000, pixelHinting:true, scaleMode:LineScaleMode.NORMAL, capsStyle:CapsStyle.NONE, jointStyle:JointStyle.MITER, miterLimit:1 };
	var fill:FillStyle = { hasFill:true, color:0xff0000, alpha:1 };
	var tree:LevelTree;
		
	static inline var BOX_SIZE:Int = 25;
	
	override public function create() 
	{
		super.create();
		//tree = createTree();
		add(new FullMap());
	}
	
	var treeContainer:FlxSpriteGroup;
	function createTree()
	{
		if(verbose) trace("createTree");

		
		if (treeContainer == null)	
		{
			trace("create");
			treeContainer = new FlxSpriteGroup();
			add(treeContainer);
		}
		else
		{
			trace("remove");
			for (child in treeContainer.members)
			{
				trace(child);
				/*for (grandchild in child)
				{
					child.remove(grandchild);
				}*/
				treeContainer.remove(child);
				
			}
		}
		
		
		var _tree = new LevelTree(25, new PlayState());
		
		for (i in 0..._tree.defs.length)
		{
			//if(verbose) trace("i:" + i);
			var def:LevelDef = _tree.defs[i];
			//add(createBox(space.alt, space.long));
			treeContainer.add(def.getMiniRooms());
		}
		
		return _tree;
	}
	
	/*
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
	*/
	
	override public function update()
	{
		super.update();
		if (FlxG.mouse.justReleased)
		{
			//remove(tree);
			//clear();
			tree = createTree();
			//if(verbose) trace(tree.spaces[5].neighbors);
			//if(verbose) trace(FlxG.mouse.
		}
	}
	
}