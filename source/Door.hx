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
				makeGraphic(64 * 4, 64, 0xff000000);
				this.y -= 60;
			case 'right' :
				makeGraphic(64, 64 * 4, 0xff000000);
				this.x += 60;
			case 'down' :
				makeGraphic(64 * 4, 64, 0xff000000);
				this.y += 60;
			case 'left' :
				makeGraphic(64, 64 * 4, 0xff000000);
				this.x -= 60;
		}
	}
	
	public function enter(hero : Hero) {
		Reg.spawnOffsetX = cast (this.x - hero.hitbox.x);
		Reg.spawnOffsetY = cast (this.y - hero.hitbox.y);
		Reg.exitDirection = this.direction;
	}
	
}