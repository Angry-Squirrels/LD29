package ennemies;
import flixel.FlxSprite;
import flixel.util.FlxPath;
import flixel.util.FlxPoint;
import flixel.util.FlxMath;
import player.Hero;
import utils.EnnemyPath;
import weapons.BaseWeapon;

/**
 * ...
 * @author Ynk33
 */
class BaseEnnemy extends FlxSprite
{
	private inline static var ACTION_PATROL:Int = 0;
	private inline static var ACTION_RUSH:Int = 1;
	private inline static var ACTION_ATTACK:Int = 2;
	
	private var path:FlxPath;
	private var hero:Hero;
	private var currentState:Int;
	
	private var move_speed:Int;
	private var patrol_speed:Int;
	
	private var distanceToDetect:Int;
	private var minDistance:Int;
	private var pathToHero:Array<FlxPoint>;
	
	private var weapon:BaseWeapon;
	
	public function new(_hero:Hero)
	{
		super();
		
		hero = _hero;
		Reg.ennemyGroup.add(this);
		currentState = BaseEnnemy.ACTION_PATROL;
		
		path = new FlxPath();
	}
	
	public override function update()
	{
		if (detectHero())
		{
			var delta = hero.hitbox.x - this.x;
			flipEnnemy(delta < 0);
		}
		
		super.update();
	}
	
	private function findAPath():Array<FlxPoint>
	{
		var heroPoint = hero.hitbox.getMidpoint();
		heroPoint.y -= 32;
		return Reg.currentTileMap.findPath(this.getMidpoint(), heroPoint);
	}
	
	private function detectHero():Bool
	{
		return FlxMath.getDistance(this.getMidpoint(), hero.hitbox.getMidpoint()) <= distanceToDetect;
	}
	
	private function followHero():Bool
	{
		var distance = FlxMath.getDistance(this.getMidpoint(), hero.hitbox.getMidpoint());
		return ((distance <= distanceToDetect) && (distance >= minDistance));
	}
	
	private function canAttack():Bool
	{
		return FlxMath.getDistance(this.getMidpoint(), hero.hitbox.getMidpoint()) <= minDistance;
	}
	
	private function flipEnnemy(_facingLeft:Bool):Void
	{
		flipX = _facingLeft;
		
		if (weapon != null)
		{
			weapon.flipWeapon(_facingLeft);
		}
	}
}