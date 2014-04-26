package ;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup.FlxTypedGroup;
import universe.Space;
import flixel.util.FlxRandom;

/**
 * ...
 * @author damrem
 */
class LevelTree extends FlxGroup
{

	var _currentLevel:Level;
	
	public var spaces:Array<Space>;
	var levels:Array<Level>;
	
	static inline var FIRST_DOOR:UInt = 1;
	static inline var MIDDLE_DOOR:UInt = 2;
	static inline var LAST_DOOR:UInt = 4;
	
	
	public function new(Length:UInt) 
	{
		super();
		
		_currentLevel = addLevel();
		
		spaces = new Array<Space>();
		levels = new Array<Level>();
		
		
		var currentSpace:Space = null;
		var currentAlt:UInt = 0;
		var currentLong:Int = 0;
		var currentDirection:Int = 0;
		
		var firstSpace = new Space(0, 0);
		currentSpace = firstSpace;
		spaces.push(firstSpace);
		
		trace("---");
		for (i in 0...Length-1)
		{
			var direction:Int;
			do
			{
				direction = FlxRandom.intRanged(-1, 1);
				
			}
			while (direction * currentDirection == -1);
			trace("direction: " + direction);
			
			currentDirection = direction;
			
			switch(direction)
			{
				case -1:
					currentLong --;
				//break;
				case 0:
					currentAlt++;
				//break;
				case 1:
					currentLong ++;
				//break;
			}
				
			
			
			
			var space = new Space(currentAlt, currentLong);
			if (currentSpace != null)
			{
				space.neighbors.push(currentSpace);
				currentSpace.neighbors.push(space);
			}
			//var space = new Space(i, 0);
			spaces.push(space);
		}
		
		
	}
	
	private function addSpace()
	{
		
	}
	
	private function addLevel():Level
	{
		var level = new Level("assets/data/levels/map.tmx");
		add(level.backgroundTiles);
		add(level.foregroundTiles);
		return level;
	}
	
	function get_currentLevel():Level 
	{
		return _currentLevel;
	}
	
	public var currentLevel(get_currentLevel, null):Level;
	
}