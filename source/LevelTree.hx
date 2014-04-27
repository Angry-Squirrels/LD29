package ;
import universe.Direction;
import flash.Lib;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup.FlxTypedGroup;
import universe.LevelDef;
import flixel.util.FlxRandom;

/**
 * ...
 * @author damrem
 */
class LevelTree extends FlxGroup
{
	public static var verbose:Bool;
	public var currentLevel:Level;
	
	public var defs:Array<LevelDef>;
	var playState:PlayState;
	
	public function new(Length:UInt, _playState:PlayState) 
	{
		super();
		
		if(verbose) trace("LevelTree("+Length);
		
		defs = new Array<LevelDef>();
		
		generateSpaces(Length);
		
		introduceNewNeighbors();
		
		generateMasks();
		
		//generateLevels();
		
		currentLevel = createLevel(defs[0]);
	}
	
	function generateSpaces(Length:UInt)
	{
		//if(verbose) trace("genereateSpaces(" + Length);
		
		var currentSpace:LevelDef = null;
		var currentAlt:UInt = 0;
		var currentLong:Int = 0;
		var currentDirection:Int = 0;
		
		var firstSpace = new LevelDef(0, 0);
		currentSpace = firstSpace;
		defs.push(firstSpace);
		
		//if(verbose) trace("---");
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
			//if(verbose) trace("direction: " + direction);
			
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
			
			var space = new LevelDef(currentAlt, currentLong);
			if (currentSpace != null)
			{
				space.neighbors.push(currentSpace);
				currentSpace.neighbors.push(space);
				currentSpace = space;
			}
			//var space = new Space(i, 0);
			defs.push(space);
		}
		//if(verbose) trace(spaces);
	}
	
	//	Since we've generated the spaces linearly,
	//	the spaces only know 2 neighbors max.
	//	Let's introcuce them to their new neighbors they meet along the path.
	function introduceNewNeighbors()
	{
		if(verbose) trace("introduceNewNeighbors(");
		for (i in 0...defs.length)
		{
			if (i < defs.length - 3)
			{
				var space = defs[i];
				var eventualNeighbor = defs[i + 3];
				
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
		
		for (space in defs)
		{
			if(verbose) trace("neighbors for "+space+"->"+space.neighbors);
		}
		
		//if(verbose) trace(
	}
	
	
	
	
	
	function generateMasks()
	{
		
		for (space in defs)
		{
			var mask:String = "";
			if(verbose) trace(space);
			
			var topNeighbor:LevelDef = space.getNeighborAt(Direction.TOP);
			var bottomNeighbor:LevelDef = space.getNeighborAt(Direction.BOTTOM);
			var leftNeighbor:LevelDef = space.getNeighborAt(Direction.LEFT);
			var rightNeighbor:LevelDef = space.getNeighborAt(Direction.RIGHT);
			
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
	
	/*
	function generateLevels()
	{
		for (space in spaces)
		{
			var level:Level = createLevel(space);
			space.level = level;
			levels.push(level);
		}
	}
	*/
	
	
	public function createLevel(def:LevelDef):Level
	{
		if(verbose) trace("createLevel(" + def);
		//var tmx = FlxRandom.chanceRoll()?"assets/data/levels/templateDoors.tmx":"assets/data/levels/FirstRoom.tmx";
		var tmx = "assets/data/levels/room_" + def.mask + ".tmx";
		
		if (def.long == 0 && def.alt == 0)
			tmx = "assets/data/levels/FirstRoom.tmx";
		
		if(verbose) trace(tmx);
		var level = new Level(tmx, def);
		return level;
	}
	
	
	
	
}