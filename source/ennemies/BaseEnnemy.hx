package ennemies;
import flixel.tweens.FlxEase;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxTextField;
import flixel.tweens.FlxTween;
import flixel.util.FlxPath;
import flixel.util.FlxPoint;
import flixel.util.FlxMath;
import player.Hero;
import utils.Collider;
import utils.EnnemyPath;
import weapons.BaseWeapon;
import weapons.ennemy_weapons.BaseEnnemyWeapon;
import flixel.FlxG;

/**
 * ...
 * @author Ynk33
 */
class BaseEnnemy extends FlxGroup
{
	public static var verbose:Bool;
	
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
	
	private var damage:Float;
	private var fireRate:Float;
	private var fireTime:Float;
	private var touchedTime:Float;
	
	private var award : UInt;
	var splat:ennemies.Splat;
	var isDying:Bool;
	
	public var difficulty:UInt;
	static public inline var MAX_DIFFICULTY:UInt = 16;
	
	public function new(_hero:Hero, _difficulty:UInt=1)
	{
		super();
		if (verbose)	if(verbose) trace("difficulty:" + _difficulty);
		
		add(body);
		
		hero = _hero;
		Reg.ennemyGroup.add(this);
		currentState = BaseEnnemy.ACTION_PATROL;
		
		difficulty = _difficulty;
		if (difficulty > MAX_DIFFICULTY)	difficulty = MAX_DIFFICULTY;
		
		touchedTime = 0;
		award = 5;
		award = 3;
		
		path = new FlxPath();
		
		fireTime = 0;
	}
	
	public override function update()
	{
		fireTime += FlxG.elapsed;
		touchedTime += FlxG.elapsed;
		
		if (weapon != null)
		{
			weapon.moveWeapon(body.x, body.y);
		}
		
		if (detectHero())
		{
			var delta = hero.hitbox.x - body.x;
			flipEnnemy(delta < 0);
		}
		
		FlxG.overlap(body, Reg.hero, touchedHero);
		
		super.update();
	}
	
	private function touchedHero(_obj1:FlxObject, _obj2:FlxObject):Void
	{
		if (isDying)	return;
		// apply damage to the hero
		if (Type.getClassName(Type.getClass(_obj2)) == "utils.Collider")
		{
			var collider = cast(_obj2, Collider);
			var hero = cast(collider.parent, Hero);
			if (hero.touchedByEnnemy(damage, body.getMidpoint()))
			{
				FlxG.sound.play("assets/sounds/ennemy_hit.mp3");
			}
		}
	}
	
	public function hurt(_damage:Float):Void
	{
		if(verbose) trace("hurt");
		
		body.health = body.health - _damage;
		if (body.health < 0)
		{
			FlxG.sound.play("assets/sounds/ennemy_death.mp3", 3);
			isDying = true;
			if (body.animation.curAnim != null)
			{
				body.animation.curAnim.stop();
			}
			
			weapon.kill();
			
			splat = new Splat(onSplatted);
			splat.x = body.x;
			splat.y = body.y - body.height *2/3;
			add(splat);
			splat.play();
		}
		
		var deltaX = body.getMidpoint().x - hero.hitbox.getGraphicMidpoint().x;
		var deltaY = body.getMidpoint().y - hero.hitbox.getGraphicMidpoint().y;
		
		body.velocity.x = 500 * (deltaX > 0 ? 1 : -1);
		body.velocity.y = 500 * (deltaY > 0 ? 1 : -1);
		super.update();
	}
	
	function onSplatted(name:String, frameNumber:Int, frameIndex:Int)
	{
		if(verbose) trace("onSplatted(");
		if (frameNumber == 11)
		{
			splat.kill();
			remove(splat);
			FlxTween.tween(body, { y: body.y - 100, alpha: 0.0}, 0.25, { ease: FlxEase.cubeOut, complete:onDisappeared} );
		}
	}
	
	function onDisappeared(tween:FlxTween)
	{
		if(verbose) trace("onDisappeared(");
		//if (frameNumber == 11)
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
	
	private function playAnimation(_anim:String, _speed:Int = 30):Void
	{
		// don't play same animation
		if (body.animation.curAnim == null || body.animation.curAnim.name != _anim)
		{
			// for all anim but "attack"
			if (_anim != "attack")
			{
				// play anim if not playing "attack"
				if (body.animation.curAnim == null || body.animation.curAnim.name != "attack")
				{
					body.animation.play(_anim);
					body.animation.curAnim.frameRate = _speed;
				}
			}
			else
			{
				body.animation.play(_anim);
				body.animation.curAnim.frameRate = _speed;
			}
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
		if (isDying)	return false;
		
		if (fireTime > 1/fireRate)
		{
			fireTime = 0;
			return true;
		}
		else
		{
			return false;
		}
	}
	
	private function goodDistanceToAttack():Bool
	{
		return FlxMath.getDistance(body.getMidpoint(), hero.hitbox.getMidpoint()) <= minDistance;
	}
	
	private function isHurt():Bool
	{
		return touchedTime < 0.2;
	}
	
	private function flipEnnemy(_facingLeft:Bool):Void
	{
		body.flipX = !_facingLeft;
		
		if (weapon != null)
		{
			weapon.flipWeapon(_facingLeft);
		}
	}
	
	public override function kill()
	{
		if(verbose) trace("kill");
		if (!alive)
		{
			if(verbose) trace("but already killed");
			return;
		}
		if(verbose) trace("really kill");
		
		body.kill();
		
		for (i in 0 ... award) new Crystal(cast body.x, cast body.y - 10);
		
		Reg.heroStats.enemyKilled ++;
		
		super.kill();
	}
}