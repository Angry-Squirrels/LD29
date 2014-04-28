package ennemies;
import flixel.FlxG;
import flixel.FlxSprite;
import player.Hero;
import flixel.util.FlxColor;
import utils.Collider;
import utils.EnnemyPath;
import flixel.util.FlxPoint;
import weapons.ennemy_weapons.BaseEnnemyWeapon;
import flixel.text.FlxTextField;
import flixel.util.loaders.SparrowData;
/**
 * ...
 * @author Ynk33
 */
class WalkingEnemy extends BaseEnnemy
{
	public function new(_hero:Hero, _difficulty:UInt=1) 
	{
		body = new Collider(0, 0, this);
		var tilesetIndex = Math.ceil(_difficulty / 2);
		var animation = new SparrowData("assets/Monsters/beetle.xml", "assets/Monsters/beetle"+tilesetIndex+".png");
		body.loadGraphicFromTexture(animation);
		body.animation.add("idle", [10], 30);
		body.animation.addByPrefix("move", "LD29_beetle_move", 10);
		body.animation.addByPrefix("attack", "LD29_beetle_attack", 7, false);
		body.animation.callback = callbackAnimation;
		
		
		super(_hero, _difficulty);
		/*
		var tfDiff = new FlxTextField(20, 20, 20, _difficulty + "");
		tfDiff.color = 0xffffffff;
		add(tfDiff);
		*/
		
		damage = 1 + Math.floor(_difficulty / 2);
		fireRate = 1 + _difficulty / 10;
		body.health = 2 + _difficulty / 2;
		distanceToDetect = 500 + (_difficulty - 1) * 10;
		minDistance = Std.int(body.width);
		move_speed = 200 + _difficulty * 5;
		patrol_speed = 200 + _difficulty * 5;
		award = _difficulty;
		
		body.drag.set(move_speed * 8, move_speed * 8);
		body.maxVelocity.set(move_speed, move_speed);
		body.acceleration.set(0, Reg.GRAVITY);
		
		weapon = new BaseEnnemyWeapon(body, minDistance, damage);
		add(weapon);
	}
	
	public override function update()
	{
		Reg.levelTree.currentLevel.collideWithLevel(body);
		
		body.acceleration.y = Reg.GRAVITY;
		
		if (!isHurt() && !hero.isDead)
		{
			body.acceleration.x = 0;
			
			switch(currentState)
			{
				case BaseEnnemy.ACTION_PATROL:
					//playAnimation("idle");
					if (detectHero())
					{
						currentState = BaseEnnemy.ACTION_RUSH;
					}
				
				case BaseEnnemy.ACTION_RUSH:
					//playAnimation("move");
					if (followHero())
					{
						followPath();
					}
					else if (goodDistanceToAttack())
					{
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
							//weapon.fire();
							playAnimation("attack", 30);
						}
						else
						{
							//playAnimation("idle");
						}
					}
					else
					{
						//playAnimation("move");
						currentState = BaseEnnemy.ACTION_RUSH;
					}
			}
			
			if (!canAttack())
			{
				if (body.velocity.x != 0)
				{
					playAnimation('move');
				}
				else
				{
					playAnimation('idle');
				}
			}
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
	override private function goodDistanceToAttack():Bool
	{
		var distance = Math.abs(hero.hitbox.getMidpoint().x - body.getMidpoint().x);
		return distance <= minDistance && Math.abs(hero.hitbox.getMidpoint().y - body.y) <= minDistance/4;
	}
	override private function followHero():Bool
	{
		var distance = Math.abs(hero.hitbox.getMidpoint().x - body.getMidpoint().x);
		return ((distance <= distanceToDetect) && (distance >= minDistance));
	}
}