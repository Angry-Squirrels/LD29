package ennemies;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.util.loaders.SparrowData;
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
	
	public function new(_hero:Hero, _difficulty:UInt=1) 
	{
		body = new Collider(0, 0, this);
		
		var tilesetIndex = Math.ceil(_difficulty / 2);
		var animation = new SparrowData("assets/Monsters/wasp.xml", "assets/Monsters/wasp"+tilesetIndex+".png");
		body.loadGraphicFromTexture(animation);
		body.animation.addByPrefix("move", "LD29_wasp_move", 9);
		body.animation.addByPrefix("attack", "LD29_wasp_attack", 17, false);
		body.animation.callback = callbackAnimation;
		
		super(_hero, _difficulty);
		
		name = "Wasp";
		
		var factor = 10;
		
		damage = 1 + Math.floor(_difficulty / 2);
		damage *= factor;
		
		fireRate = 1 + _difficulty / 10;
		
		body.health = 2 + _difficulty / 2;
		body.health *= factor;
		
		maxHealth = cast body.health;
		
		distanceToDetect = 500 + (_difficulty - 1) * 10;
		
		minDistance = Std.int(body.width);
		
		move_speed = 200 + _difficulty * 5;
		
		patrol_speed = 200 + _difficulty * 5;
		
		award = _difficulty;
		
		weapon = new BaseEnnemyWeapon(body, Std.int(minDistance / 2), damage);
		add(weapon);
		
		mainSound = new FlxSound();
		mainSound.loadEmbedded(FlxAssets.getSound("assets/sounds/ennemy_buzz"), true);
		mainSound.volume = 0.3;
	}
	
	public override function update()
	{
		if (!isHurt() && !hero.isDead)
		{
			switch(currentState)
			{
				case BaseEnnemy.ACTION_PATROL:
					mainSound.stop();
					playAnimation("move");
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
					playAnimation("move");
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
					else if (goodDistanceToAttack())
					{
						path.cancel();
						weapon.blockWeaponFor(0);
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
							playAnimation("attack", 30);
						}
						else
						{
							playAnimation("move");
						}
					}
					else
					{
						playAnimation("move");
						currentState = BaseEnnemy.ACTION_RUSH;
						pathToHero = findAPath();
						if (pathToHero != null)
						{
							path.start(body, pathToHero, move_speed);
						}
					}
			}
		}
		else
		{
			path.cancel();
		}
		
		super.update();
	}
	
	private function callbackAnimation(_anim:String, _frameNumber:Int, _frameIndex:Int):Void
	{
		if (_anim == "attack")
		{
			if (_frameNumber == 6)
			{
				FlxG.sound.play("assets/sounds/ennemy_swoosh.mp3");
			}
			if (_frameNumber == 9)
			{
				weapon.fire();
			}
		}
	}
	
	public override function kill():Void
	{
		mainSound.stop();
		
		super.kill();
	}
	
}