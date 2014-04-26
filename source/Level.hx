package ;

import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import haxe.io.Path;

/**
 * ...
 * @author TBaudon
 */
class Level extends TiledMap
{
	
	private inline static var PATH_LEVEL_TILESHEETS = "assets/images/tilesets/";
	
	public var foregroundTiles: FlxGroup;
	public var backgroundTiles: FlxGroup;
	
	var collisionableTileLayers: Array<FlxTilemap>;
	
	public function new(path:String) 
	{
		super(path);
	
		
		FlxG.log.notice("Loading map");
		
		foregroundTiles = new FlxGroup();
		backgroundTiles = new FlxGroup();
		
		FlxG.camera.setBounds(0, 0, fullWidth, fullHeight);
		//return;
		
		FlxG.log.add(properties.get('name'));
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
				throw "blarba gharg";
				
			var imagePath = new Path(tileSet.imageSource);
			var processedPath = PATH_LEVEL_TILESHEETS + imagePath.file  + "." + imagePath.ext;
			
			var tilemap:FlxTilemap = new FlxTilemap();
			tilemap.widthInTiles = width;
			tilemap.heightInTiles = height;
			tilemap.loadMap(tileLayer.tileArray, processedPath, tileSet.tileWidth, tileSet.tileHeight, 0, 1 , 1, 1);
			
			if (tileLayer.properties.contains("nocollide"))
			{
				backgroundTiles.add(tilemap);
			}
			else
			{
				if (collisionableTileLayers == null)
					collisionableTileLayers = new Array<FlxTilemap>();

				foregroundTiles.add(tilemap);
				collisionableTileLayers.push(tilemap);
			}
		}
		
	}
	
	public function collideWithLevel(obj:FlxObject, ?notififyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool {
		
		if (collideWithLevel != null) {
			for (map in collisionableTileLayers) {
				return FlxG.overlap(map, obj, notififyCallback, processCallback != null ? processCallback : FlxObject.separate);
			}
		}
		return false;
	}
	
}