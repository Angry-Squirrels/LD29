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
		body.health = 2;
		distanceToDetect = 500;
		minDistance = Std.int(body.width * 2);
		move_speed = 200;
		patrol_speed = 200;
		
		weapon = new BaseEnnemyWeapon(body, minDistance, damage);
		add(weapon);
	}
	
	public override function update()
	{
		switch(currentState)
		{
			case BaseEnnemy.ACTION_PATROL:
				if (detectHero())
				{
					currentState = BaseEnnemy.ACTION_RUSH;
					pathToHero = findAPath();
					if (pathToHero != null)
					{
						path.start(body, pathToHero, move_speed);
					}
				}
			
			case BaseEnnemy.ACTION_RUSH:
				if (followHero())
				{
					if (path.finished)
					{
						pathToHero = findAPath();
						if (pathToHero != null)
						{
							path.start(body, pathToHero, move_speed);
						}
					}
				}
				else if (canAttack())
				{
					path.cancel();
					weapon.blockWeaponFor(1);
					currentState = BaseEnnemy.ACTION_ATTACK;
				}
				else
				{
					currentState = BaseEnnemy.ACTION_PATROL;
				}
				
			case BaseEnnemy.ACTION_ATTACK:
				if (canAttack())
				{
					weapon.fire();
				}
				else
				{
					currentState = BaseEnnemy.ACTION_RUSH;
					pathToHero = findAPath();
					if (pathToHero != null)
					{
						path.start(body, pathToHero, move_speed);
					}
				}
		}
		
		super.update();
	}
	
}