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

	public var currentLevel:Level;
	
	public var spaces:Array<Space>;
	public var levels:Array<Level>;
	var playState:PlayState;
	
	public function new(Length:UInt, _playState:PlayState) 
	{
		super();
		
		trace("LevelTree("+Length);
		
		spaces = new Array<Space>();
		levels = new Array<Level>();
		
		generateSpaces(Length);
		
		introduceNewNeighbors();
		
		generateMasks();
		
		generateLevels();
		
		currentLevel = levels[0];
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
			//for the room, we go to the right
			if (i == 0)
			{
				direction = 1;
			}
			else
			{
				do
				{
					direction = FlxRandom.intRanged(-1, 1);
					
				}
				while (direction * currentDirection == -1);
			}
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
	
	
	
	
	
	function generateMasks()
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
				//space.topMask = topNeighbor.bottomMask = FlxRandom.intRanged(1, 3);
				space.topMask = topNeighbor.bottomMask = 1;
			}
			
			if (bottomNeighbor != null)
			{
				//space.bottomMask = bottomNeighbor.topMask = FlxRandom.intRanged(1, 3);
				space.bottomMask = bottomNeighbor.topMask = 1;
			}
			
			if (leftNeighbor != null)
			{
				//space.leftMask = leftNeighbor.rightMask = FlxRandom.intRanged(1, 3);
				space.leftMask = leftNeighbor.rightMask = 1;
			}
			
			if (rightNeighbor != null)
			{
				//space.rightMask = rightNeighbor.leftMask = FlxRandom.intRanged(1, 3);
				space.rightMask = rightNeighbor.leftMask = 1;
			}
		}
		
	}
	
	function generateLevels()
	{
		for (space in spaces)
		{
			var level:Level = createLevel(space);
			space.level = level;
			levels.push(level);
		}
	}
	
	
	function createLevel(space:Space):Level
	{
		trace("createLevel(" + space);
		//var tmx = FlxRandom.chanceRoll()?"assets/data/levels/templateDoors.tmx":"assets/data/levels/FirstRoom.tmx";
		var tmx = "assets/data/levels/room_" + space.mask + ".tmx";
		trace(tmx);
		var level = new Level(tmx, space);
		return level;
	}
	
	
	
	
}