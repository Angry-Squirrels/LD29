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
		
		for (def in Reg.levelTree.defs) {
			if(def.explored)
				FlxSpriteUtil.drawRect(this, def.long * 10 - mapX, -def.alt * 10 - mapY, 10, 10, 0x66cccccc);
			if (def == Reg.levelTree.currentLevel.definition)
				FlxSpriteUtil.drawRect(this, def.long * 10 - mapX, -def.alt * 10 - mapY, 10, 10, 0xcccccccc);
		}
		
		var lineStyle:LineStyle = { color: FlxColor.WHITE, thickness: 1 };
		var fillStyle:FillStyle = { color: FlxColor.TRANSPARENT, alpha: 0.5 };
		FlxSpriteUtil.drawRect(this, 0, 0, 89, 89, 0, lineStyle, fillStyle);
	}
	
}