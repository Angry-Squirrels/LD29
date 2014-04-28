package ennemies;
import flixel.util.FlxRandom;
import flixel.group.FlxGroup;
import haxe.xml.Fast;
import ennemies.WalkingEnemy;
import flixel.util.FlxMath;
/**
 * ...
 * @author damrem
 */
class EnemySpawner
{
	public static var verbose:Bool = true;
	var _playState:PlayState;

	public function new(playState:PlayState) 
	{
		
		if(verbose)	trace(playState);
		_playState = playState;
		//debug();
	}
	
	function debug()
	{
		for (i in 1...10)
		{
			generateEnemies(i);
		}
	}
	
	public function generateEnemies(levelDifficulty:UInt)
	{
		if (verbose) trace("----GENERATEENEMIES----");
		
		//var levelDifficulty = _playState.level.definition.difficulty;
		if (verbose) trace("levelDifficulty="+levelDifficulty);
		
		var minNbEnemies = Math.ceil(levelDifficulty / BaseEnnemy.MAX_DIFFICULTY);
		if (verbose) trace("minNbEnemies="+minNbEnemies);
		
		var nbEnemies:UInt = FlxRandom.intRanged(minNbEnemies, levelDifficulty);
		if (verbose) trace("nbEnemies="+nbEnemies);
		//	only 1 mob per spawning point, so no more mob than spawning point in the level
		nbEnemies = Std.int(Math.min(nbEnemies, _playState.level.spawningPoints.length));
		if (verbose) trace("nbEnemies="+nbEnemies);
		
		var maxNbEnemiesShift:UInt = Math.round(levelDifficulty / 5);
		if (verbose) trace("maxNbEnemiesShift=" + maxNbEnemiesShift);
		
		var nbEnemiesShift = FlxRandom.intRanged(0, maxNbEnemiesShift);
		if (verbose) trace("nbEnemiesShift=" + nbEnemiesShift);
		
		nbEnemies += nbEnemiesShift;
		if (verbose) trace("nbEnemies=" + nbEnemies);
		
		nbEnemies = Std.int(Math.max(nbEnemies, 1));
		if (verbose) trace("NBENEMIES="+nbEnemies);
		
		var averageDiff = Math.round(levelDifficulty / nbEnemies);
		if (verbose) trace("averageDiff="+averageDiff);
		
		for (i in 0...nbEnemies)
		{
			var spawningPoint = cast(_playState.level.spawningPoints.getRandom(), SpawningPoint);
			if(verbose)	trace(i+":"+spawningPoint);
			if (spawningPoint != null)
			{
				//	we remove the swpawning point so that only 1 mob can be generated from there
				_playState.level.spawningPoints.remove(spawningPoint);
				
				var enemy:BaseEnnemy = null;
				
				var maxEnemyDiffShift:UInt = Math.round(averageDiff / 10);
				if (verbose) trace("maxEnemyDiffShift=" + maxEnemyDiffShift);
				
				var enemyDiffShift = FlxRandom.intRanged( -maxEnemyDiffShift, maxEnemyDiffShift);
				if (verbose) trace("enemyDiffShift=" + enemyDiffShift);
				
				var enemyDiff:UInt = Std.int(Math.min(averageDiff + enemyDiffShift, BaseEnnemy.MAX_DIFFICULTY));
				if (verbose) trace("ENEMYDIFF=" + enemyDiff);
				
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
					_playState.enemies.add(enemy);
				}
				
			}
		}
	}
	
}