package ;

/**
 * ...
 * @author TBaudon
 */
class HeroStats
{
	
	// one life point give 10 pv
	public var baseLifePoint : UInt = 1;
	
	// hit deals more damage
	public var baseDamegePoint : UInt = 1;
	
	// takes less damage
	public var baseDefensePoint : UInt = 1;
	
	// points to distribute
	
	public var roomExplored : UInt = 0;
	public var enemyKilled : UInt = 0;
	public var coinCollected : Int = 0;
	
	// hero in game
	public var health : Int = 0;
	public var maxHealth : Int = 0;
	
	public function new() 
	{
		
	}
	
	public function initHealth() {
		maxHealth = 50 * baseLifePoint;
		health = maxHealth;
	}
	
}