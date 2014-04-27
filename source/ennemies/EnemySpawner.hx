package ennemies;

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
		trace(playState);
		_playState = playState;
	}
	
	public function generateEnemies()
	{
		if (verbose) trace("generateEnemies");
		
		for (i in 0..._playState.level.definition.difficulty)
		{
			var ennemy:FlyingEnnemy = new FlyingEnnemy(Reg.hero);
			ennemy.place(100, 100);
			_playState.add(ennemy);
		}
	}
	
}