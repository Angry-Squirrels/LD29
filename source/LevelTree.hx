package ;
import universe.Direction;
import flash.Lib;
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
		
		trace("LevelTree("+Length);
		
		_currentLevel = addLevel();
		
		spaces = new Array<Space>();
		levels = new Array<Level>();
		
		generateSpaces(Length);
		
		introduceNewNeighbors();
		
		generateLevels();
	}
	
	function generateSpaces(Length:UInt)
	{
		//trace("genereateSpaces(" + Length);
		
		var currentSpace:Space = null;
		var currentAlt:UInt = 0;
		var currentLong:Int = 0;
		var currentDirection:Int = 0;
		
		var firstSpace = new Space(0, 0);
		currentSpace = firstSpace;
		spaces.push(firstSpace);
		
		//trace("---");
		for (i in 0...Length-1)
		{
			var direction:Int;
			do
			{
				direction = FlxRandom.intRanged(-1, 1);
				
			}
			while (direction * currentDirection == -1);
			//trace("direction: " + direction);
			
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
				currentSpace = space;
			}
			//var space = new Space(i, 0);
			spaces.push(space);
		}
		//trace(spaces);
	}
	
	//	Since we've generated the spaces linearly,
	//	the spaces only know 2 neighbors max.
	//	Let's introcuce them to their new neighbors they meet along the path.
	function introduceNewNeighbors()
	{
		trace("introduceNewNeighbors(");
		for (i in 0...spaces.length)
		{
			if (i < spaces.length - 3)
			{
				var space = spaces[i];
				var eventualNeighbor = spaces[i + 3];
				
				var eventualNeighborIsSameAlt = (eventualNeighbor.alt == space.alt);
				var eventualNeighborIsJustAbove = (eventualNeighbor.alt == space.alt + 1);
				
				var eventualNeighborIsSameLong = (eventualNeighbor.long == space.long);
				var eventualNeighborIsJustLeft = (eventualNeighbor.long == space.long - 1);
				var eventualNeighborIsJustRight = (eventualNeighbor.long == space.long + 1);
				var eventualNeighborIsJustBeside = eventualNeighborIsJustLeft || eventualNeighborIsJustRight;
				
				if (eventualNeighborIsSameAlt && eventualNeighborIsJustBeside || eventualNeighborIsSameLong && eventualNeighborIsJustAbove)
				{
					space.neighbors.push(eventualNeighbor);
					eventualNeighbor.neighbors.push(space);
				}
			}
		}
		
		for (space in spaces)
		{
			trace("neighbors for "+space+"->"+space.neighbors);
		}
		
		//trace(
	}
	
	
	
	
	
	function generateLevels()
	{
		
		for (space in spaces)
		{
			var mask:String = "";
			trace(space);
			
			var topNeighbor:Space = space.getNeighborAt(Direction.TOP);
			var bottomNeighbor:Space = space.getNeighborAt(Direction.BOTTOM);
			var leftNeighbor:Space = space.getNeighborAt(Direction.LEFT);
			var rightNeighbor:Space = space.getNeighborAt(Direction.RIGHT);
			
			if (topNeighbor != null)
			{
				space.topMask = topNeighbor.bottomMask = FlxRandom.intRanged(1, 3);
			}
			else
			{
				//space.topMask = 0;
			}
			
			if (bottomNeighbor != null)
			{
				space.bottomMask = bottomNeighbor.topMask = FlxRandom.intRanged(1, 3);
			}
			else
			{
				//space.bottomMask = 0;
			}
			
			if (leftNeighbor != null)
			{
				space.leftMask = leftNeighbor.rightMask = FlxRandom.intRanged(1, 3);
			}
			else
			{
				//space.leftMask = 0;
			}
			
			if (rightNeighbor != null)
			{
				space.rightMask = rightNeighbor.leftMask = FlxRandom.intRanged(1, 3);
			}
			else
			{
				//space.rightMask = 0;
			}
			
			
			
			//var level = new Level();
		}
		
		for (space in spaces)
		{
			trace(space.mask);
		}
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