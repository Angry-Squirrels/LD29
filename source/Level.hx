package ;
import ennemies.SpawningPoint;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import haxe.io.Path;
import player.Hero;
import universe.Direction;
import universe.LevelDef;
import utils.Collider;

/**
 * ...
 * @author TBaudon
 */
class Level extends TiledMap
{
	public static var verbose:Bool = true;
	private inline static var PATH_LEVEL_TILESHEETS = "assets/images/tilesets/";
	
	public var foregroundTiles: FlxGroup;
	public var backgroundTiles: FlxGroup;
	public var doors: FlxGroup;
	public var crystals : FlxGroup;
	
	public var collisionableTileLayers:FlxTilemap;
	var state : PlayState;
	
	var _definition:LevelDef;
	
	var _number:UInt = 0;
	static private var NB_LEVEL:UInt = 0;
	public var spawningPoints:FlxGroup;
	
	public function new(path:String, def:LevelDef) 
	{
		if (verbose) trace("new Level(" + path, def, def.mask);
		super(path);
		
		NB_LEVEL++;
		_number = NB_LEVEL;
		if(verbose) trace(this);
	
		_definition = def;
		
		FlxG.log.notice("Loading map");
		
		foregroundTiles = new FlxGroup();
		foregroundTiles.ID = 1234;
		backgroundTiles = new FlxGroup();
		backgroundTiles.ID = 2345;
		doors = new FlxGroup();
		crystals = new FlxGroup();
		spawningPoints = new FlxGroup();
		
		//FlxG.camera.setBounds(0, 0, fullWidth, fullHeight);
		//return;
		
	}
	
	public function draw()
	{
		
		for (tileLayer in layers) { // for each layer
			
			// Get propertie of the layer 
			var tileSheetName : String = tileLayer.properties.get('tileset'); // get the name of the tileset used
			
			var tileSet: TiledTileSet = null;
			for (fs in tilesets)  {
				if (verbose)
				{
					trace(fs);
					trace(fs.name);
					trace(tileSheetName);
				}
				if (fs.name == tileSheetName) {
					tileSet = fs;
					break;
				}
			}
			
			if (tileSet == null)
				throw "Tileset not found";
				
			var imagePath = new Path(tileSet.imageSource);
			var processedPath = PATH_LEVEL_TILESHEETS + imagePath.file  + "." + imagePath.ext;
			
			var tilemap:FlxTilemap = new FlxTilemap();
			tilemap.widthInTiles = width;
			tilemap.heightInTiles = height;
			tilemap.loadMap(tileLayer.tileArray, processedPath, tileSet.tileWidth, tileSet.tileHeight, 0, 1 , 1, 1);
			
			if( tileSet.terraintypes != null) {
				var terrains = tileSet.terraintypes.map;
				
				if (terrains["crossable"] != null)
				{
					for (tile in terrains["crossable"])
						tilemap.setTileProperties(tile+1, FlxObject.UP, throughCallBack, Collider);
				}
				if (terrains["hurt"] != null)
				{
					for (tile in terrains["hurt"])
						tilemap.setTileProperties(tile+1, FlxObject.ANY, hurtCallBack, Collider);
				}
			}
			
			if (tileLayer.properties.contains("nocollide"))
			{
				backgroundTiles.add(tilemap);
			}
			else
			{
				//if (collisionableTileLayers == null)
				//	collisionableTileLayers = new Array<FlxTilemap>();

				foregroundTiles.add(tilemap);
				collisionableTileLayers = tilemap;
			}
		}
		
	}
	
	public function setCurrentState(state:PlayState) {
		this.state = state;
	}
	
	function throughCallBack(tile:FlxObject, hero:FlxObject) 
	{
		var collider : Collider = cast hero;
		if (Type.getClassName(Type.getClass(collider.parent)) == "player.Hero")
		{
			var player : Hero = cast collider.parent;
			
			if (player.canJumpThrough)
				tile.allowCollisions = 0;
			else
				tile.allowCollisions = FlxObject.UP;
		}
	}
	
	function hurtCallBack(tile:FlxObject, hero:FlxObject)
	{
		var collider : Collider = cast hero;
		if (Type.getClassName(Type.getClass(collider.parent)) == "player.Hero")
		{
			var player : Hero = cast collider.parent;
			
			player.touchedByEnnemy(10,tile.getMidpoint());
		}
	}
	
	public function getDoor(direction: String) : Door {
		for (a in doors) {
			var door : Door = cast a;
			if (door.direction == direction)
				return door;
		}
		return null;
	}
	
	
	public function loadObjects(state:PlayState) {
		for (group in objectGroups) {
			for (o in group.objects) {
				loadObject(o, group, state);
			}
		}
	}
	
	function loadObject(o:TiledObject, g:TiledObjectGroup, state:PlayState) {
		var x = o.x;
		var y = o.y;
		
		if (o.gid != -1)
			y -= g.map.getGidOwner(o.gid).tileHeight;
			
		switch (o.type.toLowerCase())
		{
			case "door":
				var door = new Door(o.xmlData, x,y);
				state.add(door);
				doors.add(door);
				if(verbose)	trace("generating door");
			
				
			case "spawner":
				var spawningPoint = new SpawningPoint(o.xmlData, x, y);
				spawningPoints.add(spawningPoint);
				//state.enemySpawner.addSpawningPoint(o.xmlData, x, y);
			
			case "crystal":
				var crystal = new BigCrystal(o.xmlData, x, y);
				state.add(crystal);
				if (verbose) trace ("generating crystal");
				
		}
	}
	
	public function collideWithLevel(obj:FlxObject, ?notififyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool {
		
		if (collideWithLevel != null) {
			return FlxG.overlap(collisionableTileLayers, obj, notififyCallback, processCallback != null ? processCallback : FlxObject.separate);
		}
		return false;
	}
	
	function get_number():UInt 
	{
		return _number;
	}
	
	public var number(get_number, null):UInt;
	
	function get_definition():LevelDef 
	{
		return _definition;
	}
	
	public var definition(get_definition, null):LevelDef;
	
	public function toString():String
	{
		return "[Level " + _number + "]";
	}
	
	public function explore() 
	{
		if (this._definition.explored == false) {
			Reg.heroStats.roomExplored++;
			this._definition.explored = true;
		}
	}
	
	
	
}