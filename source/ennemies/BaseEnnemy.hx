package ennemies;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxPath;
import flixel.util.FlxPoint;
import flixel.util.FlxMath;
import player.Hero;
import utils.Collider;
import utils.EnnemyPath;
import weapons.BaseWeapon;
import weapons.ennemy_weapons.BaseEnnemyWeapon;

/**
 * ...
 * @author Ynk33
 */
class BaseEnnemy extends FlxGroup
{
	private inline static var ACTION_PATROL:Int = 0;
	private inline static var ACTION_RUSH:Int = 1;
	private inline static var ACTION_ATTACK:Int = 2;
	
	private var path:FlxPath;
	private var hero:Hero;
	private var currentState:Int;
	
	private var body:Collider;
	
	private var move_speed:Int;
	private var patrol_speed:Int;
	
	private var distanceToDetect:Int;
	private var minDistance:Int;
	private var pathToHero:Array<FlxPoint>;
	
	private var weapon:BaseEnnemyWeapon;
	
	private var xpAward : UInt;
	
	public function new(_hero:Hero)
	{
		super();
		
		add(body);
		
		hero = _hero;
		Reg.ennemyGroup.add(this);
		currentState = BaseEnnemy.ACTION_PATROL;
		
		path = new FlxPath();
	}
	
	public override function update()
	{
		if (weapon != null)
		{
			weapon.moveWeapon(body.x, body.y);
		}
		
		if (detectHero())
		{
			var delta = hero.hitbox.x - body.x;
			flipEnnemy(delta < 0);
		}
		
		super.update();
	}
	
	public function hurt(_damage:Float):Void
	{
		body.hurt(_damage);
		if (!body.alive)
		{
			kill();
		}
	}
	
	private function findAPath():Array<FlxPoint>
	{
		var heroPoint = hero.hitbox.getMidpoint();
		if (body.flipX)
		{
			heroPoint.x += minDistance - 20;
		}
		else
		{
			heroPoint.x -= minDistance - 20;
		}
		
		var _path = Reg.currentTileMap.findPath(body.getMidpoint(), heroPoint, false);
		
		return (_path == null ? _path : _path.length >= 2 ? [_path[0], _path[1]] : _path);
	}
	
	public function place(_x:Int, _y:Float):Void
	{
		body.x = _x;
		body.y = _y;
		
		if (weapon != null)
		{
			weapon.moveWeapon(_x, _y);
		}
	}
	
	private function detectHero():Bool
	{
		return FlxMath.getDistance(body.getMidpoint(), hero.hitbox.getMidpoint()) <= distanceToDetect;
	}
	
	private function followHero():Bool
	{
		var distance = FlxMath.getDistance(body.getMidpoint(), hero.hitbox.getMidpoint());
		return ((distance <= distanceToDetect) && (distance >= minDistance));
	}
	
	private function canAttack():Bool
	{
		return FlxMath.getDistance(body.getMidpoint(), hero.hitbox.getMidpoint()) <= minDistance;
	}
	
	private function flipEnnemy(_facingLeft:Bool):Void
	{
		body.flipX = _facingLeft;
		
		if (weapon != null)
		{
			weapon.flipWeapon(_facingLeft);
		}
	}
	
	public override function kill()
	{
		if (!alive)
		{
			return;
		}
		
		weapon.kill();
		body.kill();
		
		Reg.heroStats.experience += xpAward;
		Reg.heroStats.enemyKilled ++;
		
		super.kill();
	}
}