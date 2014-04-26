package ;

import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.addons.editors.tiled.TiledTerrain;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import haxe.io.Path;
import player.Hero;
import utils.Collider;

/**
 * ...
 * @author TBaudon
 */
class Level extends TiledMap
{
	
	private inline static var PATH_LEVEL_TILESHEETS = "assets/images/tilesets/";
	
	public var foregroundTiles: FlxGroup;
	public var backgroundTiles: FlxGroup;
	public var doors: FlxGroup;
	
	var collisionableTileLayers:FlxTilemap;
	var state : PlayState;
	
	public function new(path:String, state : PlayState) 
	{
		super(path);
		
		this.state = state;
		
		FlxG.log.notice("Loading map");
		
		foregroundTiles = new FlxGroup();
		backgroundTiles = new FlxGroup();
		doors = new FlxGroup();
		
		FlxG.camera.setBounds(0, 0, fullWidth, fullHeight);
		
		for (tileLayer in layers) { // for each layer
			
			// Get propertie of the layer 
			var tileSheetName : String = tileLayer.properties.get('tileset'); // get the name of the tileset used
			
			var tileSet: TiledTileSet = null;
			for (fs in tilesets)  {
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
	
	function throughCallBack(tile:FlxObject, hero:FlxObject) 
	{
		var collider : Collider = cast hero;
		var player : Hero = cast collider.parent;
		
		if (player.canJumpThrough)
			tile.allowCollisions = 0;
		else
			tile.allowCollisions = FlxObject.UP;
	}
	
	public function getDoor(direction: String) : Door {
		for (a in doors) {
			var door : Door = cast a;
			if (door.direction == direction)
				return door;
		}
		return null;
	}
	
	public function loadObjects() {
		for (group in objectGroups) {
			for (o in group.objects) {
				loadObject(o, group);
			}
		}
	}
	
	function loadObject(o:TiledObject, g:TiledObjectGroup) {
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
		}
	}
	
	public function collideWithLevel(obj:FlxObject, ?notififyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool {
		
		if (collideWithLevel != null) {
			return FlxG.overlap(collisionableTileLayers, obj, notififyCallback, processCallback != null ? processCallback : FlxObject.separate);
		}
		return false;
	}
	
}