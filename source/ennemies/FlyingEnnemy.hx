package ennemies;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import player.Hero;
import flixel.util.FlxColor;
import utils.Collider;
import utils.EnnemyPath;
import flixel.util.FlxPoint;
import weapons.ennemy_weapons.BaseEnnemyWeapon;
import flixel.FlxG;
import flixel.system.FlxAssets;

/**
 * ...
 * @author Ynk33
 */
class FlyingEnnemy extends BaseEnnemy
{
	private var mainSound:FlxSound;
	
	public function new(_hero:Hero) 
	{
		body = new Collider(0, 0, this);
		body.makeGraphic(70, 50, FlxColor.MAUVE);
		
		super(_hero);
		
		damage = 1;
		body.health = 3;
		distanceToDetect = 500;
		minDistance = Std.int(body.width * 2);
		move_speed = 200;
		patrol_speed = 200;
		
		xpAward = 10;
		
		weapon = new BaseEnnemyWeapon(body, minDistance, damage);
		add(weapon);
		
		mainSound = new FlxSound();
		mainSound.loadEmbedded(FlxAssets.getSound("assets/sounds/ennemy_buzz"), true);
		mainSound.volume = 0.3;
	}
	
	public override function update()
	{
		switch(currentState)
		{
			case BaseEnnemy.ACTION_PATROL:
				mainSound.stop();
				if (detectHero())
				{
					mainSound.play();
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
					weapon.blockWeaponFor(0.2);
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
	
	public override function kill():Void
	{
		mainSound.stop();
		
		super.kill();
	}
	
}