package utils;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxMath;

/**
 * ...
 * @author Ynk33
 */
class EnnemyPath
{
	public inline static var FINISHED:Int = 0;
	public inline static var RUNNING:Int = 1;
	
	private var currentState:Int;
	public var finished(get_finished, null):Bool;
	private function get_finished():Bool { return currentState == EnnemyPath.FINISHED; }
	
	private var unit:FlxSprite;
	
	private var targetPoint:FlxPoint;
	private var prtX:Float;
	private var prtY:Float;
	private var previousDistance:Int;
	
	public function new(_unit:FlxSprite, _moveSpeed:Int, _jumpSpeed, _isFlying:Bool) 
	{
		unit = _unit;
		unit.drag.set(_moveSpeed * 8, _jumpSpeed * 8);
		unit.maxVelocity.set(_moveSpeed, _jumpSpeed);
		unit.acceleration.set(0, _isFlying ? 0 : Reg.GRAVITY);
		
		currentState = EnnemyPath.FINISHED;
	}
	
	public function start(_point:FlxPoint):Void
	{
		targetPoint = _point;
		
		var deltaX = targetPoint.x - unit.x;
		var deltaY = targetPoint.y - unit.y;
		var sum = Math.abs(deltaX) + Math.abs(deltaY);
		
		prtX = deltaX / sum;
		prtY = deltaY / sum;
		previousDistance = 10000;
		
		currentState = EnnemyPath.RUNNING;
	}
	
	public function cancel():Void
	{
		unit.acceleration.x = 0;
		unit.acceleration.y = 0;
		currentState = EnnemyPath.FINISHED;
	}
	
	public function update()
	{
		switch(currentState)
		{
			case EnnemyPath.RUNNING:
				unit.acceleration.x = unit.drag.x * prtX;
				unit.acceleration.y = unit.drag.y * prtY;
				
				var distance = FlxMath.distanceToPoint(unit, targetPoint);
				if (previousDistance <= distance)
				{
					cancel();
				}
				previousDistance = distance;
		}
	}
	
}