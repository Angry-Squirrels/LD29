package ennemies;
import flixel.util.FlxRandom;
import flixel.group.FlxGroup;
import haxe.xml.Fast;
import ennemies.WalkingEnemy;
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
		
		var levelDifficulty = _playState.level.definition.difficulty;
		
		var nbEnemies:UInt = FlxRandom.intRanged(1, levelDifficulty);
		var maxNbEnemiesShift:UInt = Math.round(levelDifficulty / 5);
		var nbEnemiesShift = FlxRandom.intRanged(0, maxNbEnemiesShift);
		nbEnemies += nbEnemiesShift;
		nbEnemies = Std.int(Math.max(nbEnemies, 1));
		
		if (verbose)	trace("levelDifficulty:" + levelDifficulty);
		if (verbose)	trace("nbEnemies:" + nbEnemies);
		
		var averageDiff = Math.round(levelDifficulty / nbEnemies);
		
		for (i in 0...nbEnemies)
		{
			var spawningPoint = cast(_playState.level.spawningPoints.getRandom(), SpawningPoint);
			trace(spawningPoint);
			if (spawningPoint != null)
			{
				var enemy:BaseEnnemy = null;
				var maxEnemyDiffShift:UInt = Math.round(averageDiff / 10);
				var enemyDiffShift = FlxRandom.intRanged(-maxEnemyDiffShift, maxEnemyDiffShift);
				var enemyDiff:UInt = averageDiff + enemyDiffShift;
				switch(spawningPoint.type)
				{
					case EnemyType.FLYING:
						enemy = new FlyingEnnemy(Reg.hero, enemyDiff);
						
					case EnemyType.WALKING:
						enemy = new WalkingEnemy(Reg.hero, enemyDiff);	
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