package ennemies;
import player.Hero;
import flixel.util.FlxColor;
import utils.EnnemyPath;

/**
 * ...
 * @author Ynk33
 */
class FlyingEnnemy extends BaseEnnemy
{
	public function new(_hero:Hero) 
	{
		super(_hero);
		
		makeGraphic(70, 50, FlxColor.MAUVE);
		health = 2;
		distanceToDetect = 500;
		minDistance = Std.int(this.width * 2);
		move_speed = 200;
		patrol_speed = 200;
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
						path.start(this, [pathToHero[0], pathToHero[1]], move_speed);
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
							path.start(this, [pathToHero[0], pathToHero[1]], move_speed);
						}
					}
				}
				else if (canAttack())
				{
					path.cancel();
					currentState = BaseEnnemy.ACTION_ATTACK;
				}
				else
				{
					currentState = BaseEnnemy.ACTION_PATROL;
				}
				
			case BaseEnnemy.ACTION_ATTACK:
				if (canAttack())
				{
					
				}
				else
				{
					currentState = BaseEnnemy.ACTION_RUSH;
					pathToHero = findAPath();
					if (pathToHero != null)
					{
						path.start(this, [pathToHero[0], pathToHero[1]], move_speed);
					}
				}
		}
		
		super.update();
	}
	
}