package ennemies;
import flixel.FlxSprite;
import player.Hero;
import flixel.util.FlxColor;
import utils.Collider;
import utils.EnnemyPath;
import flixel.util.FlxPoint;
import weapons.ennemy_weapons.BaseEnnemyWeapon;

/**
 * ...
 * @author Ynk33
 */
class WalkingEnemy extends BaseEnnemy
{
	public function new(_hero:Hero) 
	{
		body = new Collider(0, 0, this);
		body.makeGraphic(70, 50, FlxColor.FOREST_GREEN);
		
		super(_hero);
		
		damage = 1;
		fireRate = 1;
		body.health = 2;
		distanceToDetect = 500;
		minDistance = Std.int(body.width * 2);
		move_speed = 200;
		patrol_speed = 200;
		
		body.drag.set(move_speed * 8, move_speed * 8);
		body.maxVelocity.set(move_speed, move_speed);
		body.acceleration.set(0, Reg.GRAVITY);
		
		weapon = new BaseEnnemyWeapon(body, minDistance, damage);
		add(weapon);
	}
	
	public override function update()
	{
		Reg.levelTree.currentLevel.collideWithLevel(body);
		
		body.acceleration.x = 0;
		body.acceleration.y = Reg.GRAVITY;
		
		switch(currentState)
		{
			case BaseEnnemy.ACTION_PATROL:
				if (detectHero())
				{
					currentState = BaseEnnemy.ACTION_RUSH;
				}
			
			case BaseEnnemy.ACTION_RUSH:
				if (followHero())
				{
					followPath();
				}
				else if (goodDistanceToAttack())
				{
					weapon.blockWeaponFor(0.3);
					currentState = BaseEnnemy.ACTION_ATTACK;
				}
				else
				{
					currentState = BaseEnnemy.ACTION_PATROL;
				}
				
			case BaseEnnemy.ACTION_ATTACK:
				if (goodDistanceToAttack())
				{
					if (canAttack())
					{
						weapon.fire();
					}
				}
				else
				{
					currentState = BaseEnnemy.ACTION_RUSH;
				}
		}
		
		super.update();
	}
	
	private function followPath():Void
	{
		if (hero.hitbox.x > body.x)
		{
			flipEnnemy(false);
			body.acceleration.x = body.drag.x;
		}
		else
		{
			flipEnnemy(true);
			body.acceleration.x = -body.drag.x;
		}
	}
	
}