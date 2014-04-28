package universe;
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
	public static var verbose:Bool=false;
	public var currentLevel:Level;
	
	public var defs:Array<LevelDef>;
	public var levels:Array<Level>;
	var playState:PlayState;
	
	/**
	 * Other way to refer to defs, for optimization purpose.
	 */
	var defsByAlt:Array<Array<LevelDef>>;
	
	public function new(Length:UInt, _playState:PlayState) 
	{
		super();
		
		if(verbose) trace("LevelTree("+Length);
		
		defs = new Array<LevelDef>();
		levels = new Array<Level>();
		defsByAlt = new Array<Array<LevelDef>>();
		
		
		var firstDef = new LevelDef(0, 0);
		defs.push(firstDef);
		
		defsByAlt[0] = [firstDef];
		
		defs = defs.concat(createBranch(firstDef, Length, Direction.TOP, 2));
		
		//generateBranches();
		introduceNewNeighbors();
	
		
		generateMasks();
		
		
		//generateLevels();
		
		currentLevel = createLevel(defs[0]);
	}
	
	function createBranch(from:LevelDef, Length:UInt, globalDirection:String=Direction.TOP, branchLevelMax:UInt=1):Array<LevelDef>
	{
		if (verbose)	trace("-------createBranch(" + from, Length, globalDirection, branchLevelMax);
		//if(verbose) trace("genereateSpaces(" + Length);
		var branch:Array<LevelDef> = new Array<LevelDef>();
		
		var branchLevel = from.branchLevel;
		
		if (verbose)
		{
			
			trace("branchLevel:" + branchLevel);
			trace("branchLevelMax:" + branchLevelMax);
		}
	
		
		if (branchLevel > branchLevelMax)
		{
			return branch;
		}
		
		var currentDef:LevelDef = from;
		var currentAlt:Int = from.alt;
		var currentLong:Int = from.long;
		var currentDirection:Int = 0;
		
		var debugColor = 0x80000000 + FlxRandom.intRanged(0, 0xffffff);
		
		
		
		
		
		//if(verbose) trace("---");
		if(verbose)	trace("DIRECTIONS AND CREATIONS");
		for (i in 1...Length)
		{
			if(verbose)	trace("direction");
			var direction:Int;
			//for the 1st room, we go to the right
			if (i == 1 && from.alt == 0 && from.long==0 )
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
		
			switch(globalDirection)
			{
				case Direction.TOP:	
					switch(direction){
						case -1:
							currentLong --;
						case 0:
							currentAlt++;
						case 1:
							currentLong ++;
					}
					
				case Direction.LEFT:
					switch(direction){
						case -1:
							currentAlt--;
						case 0:
							currentLong--;
						case 1:
							currentAlt++;
					}
					
				case Direction.RIGHT:
					switch(direction){
						case -1:
							currentAlt++;
						case 0:
							currentLong++;
						case 1:
							currentAlt--;
					}
			}
			
			//	nothing under 0
			if (currentAlt < 0)
			{
				if (verbose)	trace("under 0");
				break;
			}
			
			//	if the space isn't available, we contine to the next iteration
			if (branchLevel > 0 && !isSpaceAvailable(currentAlt, currentLong))
			{
				if (verbose)	trace("no space");
				break;
			}
			
			
			var isLastRoom:Bool = false;
			trace("branchLevel=" + branchLevel);
			trace("Length=" + Length);
			if (branchLevel == 0 && i == Std.int(Length - 1))
			{
				isLastRoom = true;
			}
			
			
			if(verbose)	trace("creation");
			//	WE CREATE THE DEF
			var def = new LevelDef(currentAlt, currentLong, branchLevel+1, isLastRoom);
			if (verbose)	trace("created " + def);
			def.debugColor = debugColor;
			
			//	we record it in the parallel structure, for optimization
			if (defsByAlt[def.alt] == null)
			{
				defsByAlt[def.alt] = new Array<LevelDef>();
			}
			defsByAlt[def.alt].push(def);//runtime error
			
			if (currentDef != null)
			{
				def.neighbors.push(currentDef);
				currentDef.neighbors.push(def);
				currentDef = def;
			}
			//var space = new Space(i, 0);
			branch.push(def);
		}	//end of branch generation
		
		if(verbose)	trace("END OF DIRECTION/CREATION");
		
		
		
		if(verbose)	trace("branchLevel:" + branchLevel);
		branchLevel ++;
		if(verbose)	trace("branchLevel++ :" + branchLevel);
		
		
		
		
		
		
		
		//
		if(verbose)	trace("max level reached?");
		if (branchLevel > branchLevelMax)
		{
			if (verbose)
			{
				trace(branchLevel+">"+branchLevelMax+": max branch level reached");
			}
			
			if(verbose)	trace("before return branch");
			return branch;
			if(verbose)	trace("after return branch");
		}
		
		
		if(verbose)	trace("SUBBRANCHES GENERATION");
		
		//	SUB-BRANCH
		for (def in branch)
		{
			if (FlxRandom.chanceRoll(50))
			{
				if(verbose)	trace("elected for creating a subbranch:"+def);
				//var subtree:
				//if (branchLevel < nbBranchLevels)
				{
					var subBranchDirection:String;
					var counter:UInt = 0;
					if (def.neighbors.length < 3)
					{
						var subBranchDirectionIndex:UInt = FlxRandom.intRanged(0, 3);
						do
						{
							subBranchDirection = Direction.ALL[subBranchDirectionIndex];
							subBranchDirectionIndex ++;
							if (subBranchDirectionIndex > 3)
							{
								subBranchDirectionIndex = 0;
							}
						}
						while (def.getNeighborAt(subBranchDirection) != null);
						
						var subBranchLength:UInt = FlxRandom.intRanged(1, Std.int(16 / (branchLevel+1)));
						if(verbose)	trace("subBranchLength:"+subBranchLength);
						var subBranch:Array<LevelDef> = createBranch(def, subBranchLength, subBranchDirection, branchLevelMax);
						branch = branch.concat(subBranch);
					}
				}
			}
		}
		if(verbose)	trace("SUBBRANCHES GENERATED");
		
		//if(verbose) trace(spaces);
		return branch;
	}
	
	
	
	function isSpaceAvailable(alt:UInt, long:Int):Bool
	{
		if (Std.int(alt) >= defsByAlt.length)	return true;
		
		var defsAtAlt = defsByAlt[alt];
		if (defsAtAlt == null)	return true;
		
		for (def in defsAtAlt)//runtime error
		{
			if (def.long == long)
			{
				return false;
			}
		}
		return true;
	}
	
	//	Since we've generated the spaces linearly,
	//	the spaces only know 2 neighbors max.
	//	Let's introcuce them to their new neighbors they meet along the path.
	function introduceNewNeighbors()
	{
		if(verbose) trace("introduceNewNeighbors(");
		for (i in 1...defs.length)
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
	}
	
	
	
	
	
	function generateMasks()
	{
		
		for (space in defs)
		{
			var mask:String = "";
			//if(verbose) trace(space);
			
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
	
	static var NB_ROOMS_PER_MASK:Array<Int> = [0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2];
	
	public function createLevel(def:LevelDef):Level
	{
		if (verbose) trace("createLevel(" + def);
		
		var mask:UInt = def.topMask * 8 + def.bottomMask * 4 + def.leftMask * 2 + def.rightMask * 1;
		var suffix = FlxRandom.intRanged(1, NB_ROOMS_PER_MASK[mask]);
		var suffix = NB_ROOMS_PER_MASK[mask];
		
		//var tmx = FlxRandom.chanceRoll()?"assets/data/levels/templateDoors.tmx":"assets/data/levels/FirstRoom.tmx";
		var tmx= "assets/data/levels/room_" + def.mask + "_"+suffix+".tmx";
		if (def.alt == 0 && def.long == 0)
		{
			tmx = "assets/data/levels/FirstRoom.tmx";
		}
		/*
		if (def.order == 1)
		{
			tmx = "assets/data/levels/SecondRoom.tmx";
		}
		*/
		 
		if(verbose) trace(tmx);
		var level = new Level(tmx, def);
		return level;
	}
	
	
	
	
}