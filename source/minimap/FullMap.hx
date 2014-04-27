package minimap;
import flash.display.CapsStyle;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSpriteUtil.FillStyle;
import flixel.util.FlxSpriteUtil.LineStyle;
import flixel.util.FlxColor;
/**
 * ...
 * @author damrem
 */
class FullMap extends FlxSpriteGroup
{
	public static var verbose:Bool=true;
	
	var line:LineStyle = { thickness:1, color:0xff0000, pixelHinting:true, scaleMode:LineScaleMode.NORMAL, capsStyle:CapsStyle.NONE, jointStyle:JointStyle.MITER, miterLimit:1 };
	var fill:FillStyle = { hasFill:true, color:0xff0000, alpha:1 };
		
	static inline var BOX_SIZE:Int = 25;
	
	public function new() 
	{		
		super();
		
		var defs = Reg.levelTree.defs;
		
		for (def in defs)
		{
			if (def != null)
			{
				def.getMiniDoors().visible = false;
				add(
				def
				.getMiniDoors()
				);
			}
		}
		
		for (def in defs)
		{
			def.getMiniRooms().visible = false;
			add(def.getMiniRooms());
		}
	}
	
	
	
}