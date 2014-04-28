package ennemies;
import flixel.group.FlxGroup;
import haxe.xml.Fast;
/**
 * ...
 * @author damrem
 */
class EnemySpawner
{
	public static var verbose:Bool = true;
	var _playState:PlayState;
	//public var availablePoints:FlxGroup;

	public function new(playState:PlayState) 
	{
		trace(playState);
		_playState = playState;
	}
	
	public function generateEnemies()
	{
		if (verbose) trace("generateEnemies");
		
		for (i in 0..._playState.level.definition.difficulty * 5)
		{
			
			var spawningPoint = cast(_playState.level.spawningPoints.getRandom(), SpawningPoint);
			trace(spawningPoint);
			if (spawningPoint != null)
			{
				var enemy:BaseEnnemy = null;
				switch(spawningPoint.type)
				{
					case EnemyType.FLYING:
						enemy = new FlyingEnnemy(Reg.hero);
					case EnemyType.WALKING:
						enemy = new FlyingEnnemy(Reg.hero);	
				}
				if (enemy != null)
				{
					enemy.place(spawningPoint.x, spawningPoint.y);
					_playState.add(enemy);
				}
			}
		}
	}
	
}