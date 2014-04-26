package ;
import flixel.FlxSprite;
import flixel.tweens.misc.NumTween;
import haxe.xml.Fast;
import player.Hero;

/**
 * ...
 * @author TBaudon
 */
class Door extends FlxSprite
{
	
	public var direction : String;

	public function new(data:Fast, x : Int, y:Int) 
	{
		super(x, y);
		
		var elem = data.node.properties.elements;
		var node = elem.next();
		direction = node.att.value;
		
		switch(direction) {
			case 'up' :
				makeGraphic(64*4, 64, 0xffffff00);
			case 'right' :
				makeGraphic(64, 64 * 4, 0xffffff00);
			case 'down' :
				makeGraphic(64*4, 64, 0xffffff00);
			case 'left' :
				makeGraphic(64, 64*4, 0xffffff00);
		}
	}
	
	public function enter(hero : Hero) {
		switch(direction) {
			case 'up' :
				Reg.spawnX = cast hero.hitbox.x;
				Reg.spawnY = 48 * 64;
			case 'right' :
				Reg.spawnX = 64;
				Reg.spawnY = cast hero.hitbox.y;
			case 'down' :
				Reg.spawnX = cast hero.hitbox.x;
				Reg.spawnY = 64;
			case 'left' :
				Reg.spawnX = 48*64;
				Reg.spawnY = cast hero.hitbox.y;
		}
	}
	
}