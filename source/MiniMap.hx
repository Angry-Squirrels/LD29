package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author TBaudon
 */
class MiniMap extends FlxSprite
{
	
	var lineStyle:LineStyle;
	var fillStyle:FillStyle ;

	public function new() 
	{
		super(690, 370);
		makeGraphic(90, 90, 0xcc000000);
		scrollFactor.x = 0;
		scrollFactor.y = 0;
		
		var mapX = 10 * Reg.levelTree.currentLevel.definition.long - 40;
		var mapY = -10 * Reg.levelTree.currentLevel.definition.alt - 40;
		
		var roomLineStyle:LineStyle = { color: FlxColor.BLACK, thickness: 1 };
		var roomFillStyle:FillStyle = { color: FlxColor.TRANSPARENT, alpha: 0.5 };
		
		for (def in Reg.levelTree.defs) {
			var drawDoors : Bool = false;
			
			var drawX = def.long * 10 - mapX;
			var drawY = -def.alt * 10 - mapY;
			
			if(def.explored) {
				FlxSpriteUtil.drawRect(this, drawX, drawY, 10, 10, 0x66cccccc, roomLineStyle, roomFillStyle);
				drawDoors = true;
			}
			
			if (def == Reg.levelTree.currentLevel.definition) {
				FlxSpriteUtil.drawRect(this, drawX, drawY, 10, 10, 0xcccccccc, roomLineStyle, roomFillStyle);
				drawDoors = true;
			}
			
			if (drawDoors) {
				if (def.leftMask == 1) 
					FlxSpriteUtil.drawRect(this, drawX - 1, drawY + 3, 2, 4, 0xccffff00);
				if (def.topMask == 1) 
					FlxSpriteUtil.drawRect(this, drawX + 3, drawY - 1, 4, 2, 0xccffff00);
				if (def.bottomMask == 1) 
					FlxSpriteUtil.drawRect(this, drawX + 3, drawY + 9, 4, 2, 0xccffff00);
				if (def.rightMask == 1) 
					FlxSpriteUtil.drawRect(this, drawX + 9, drawY + 3, 2, 4, 0xccffff00);
			}
		}
		
		var lineStyle:LineStyle = { color: FlxColor.WHITE, thickness: 1 };
		var fillStyle:FillStyle = { color: FlxColor.TRANSPARENT, alpha: 0.5 };
		FlxSpriteUtil.drawRect(this, 0, 0, 89, 89, 0, lineStyle, fillStyle);
	}
	
}