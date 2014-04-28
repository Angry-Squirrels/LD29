package;

import flixel.group.FlxTypedGroup.FlxTypedGroup;
import flixel.util.FlxSave;
import flixel.FlxSprite;
import ennemies.BaseEnnemy;
import flixel.tile.FlxTilemap;
import player.Hero;
import universe.LevelTree;
import BigCrystal;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
	static public var levelTree:LevelTree;
	
	static public var playState:PlayState;
	
	/**
	 * Generic levels Array that can be used for cross-state stuff.
	 * Example usage: Storing the levels of a platformer.
	 */
	static public var levels:Array<Dynamic> = [];
	/**
	 * Generic level variable that can be used for cross-state stuff.
	 * Example usage: Storing the current level number.
	 */
	static public var level:Int = 0;
	/**
	 * Generic scores Array that can be used for cross-state stuff.
	 * Example usage: Storing the scores for level.
	 */
	static public var scores:Array<Dynamic> = [];
	/**
	 * Generic score variable that can be used for cross-state stuff.
	 * Example usage: Storing the current score.
	 */
	static public var score:Int = 0;
	/**
	 * Generic bucket for storing different <code>FlxSaves</code>.
	 * Especially useful for setting up multiple save slots.
	 */
	static public var saves:Array<FlxSave> = [];
	
	/** Spawn position **/
	static public var exitDirection : String = "right";
	
	/** Spawn velocity so that we keep it when entering a new room**/
	static public var vitX : Float = 0;
	static public var vitY : Float = 0;
	
	/** Hero flip to keep his rotation on spawn **/
	static public var heroFlip:Bool = false;
	
	/** door offset **/
	static public var spawnOffsetX : Int = 0;
	static public var spawnOffsetY : Int = 0;
	
	/** Gravity **/
	static public var GRAVITY:Int = 980;
	
	/** Ennemy group **/
	static public var ennemyGroup:FlxTypedGroup<BaseEnnemy> = new FlxTypedGroup<BaseEnnemy>();
	
	/** big crystals group **/
	static public var bigCrystalsGroup:FlxTypedGroup<BigCrystal> = new FlxTypedGroup<BigCrystal>();
	
	/** Hero for collision **/
	static public var hero:Hero;
	
	/** Map used for pathfinding **/
	static public var currentTileMap:FlxTilemap;
	
	/** hero stats **/
	public static var heroStats: HeroStats = new HeroStats();
	
	// intro
	public static var introTexts : Array<String> = [
		"I've been choosen by the Council!",
		"I must find out what's up there...",
		"And see if our world will ever...",
		"...be able to bear life again!"
	];
	
	public static var storyTexts : Array<String> = [
		"A long time ago... In a galaxy far far away...",
		"A gigantic meteor hit the surface of a poor planet named SHITYLAND",
		"And blablablaba, you don't neeed a story, fuck off"
	];
	
	public static var storyTime : Array<Int> = [
		1000, 1000, 1000
	];
	
	public static function resetGame() {
		hero = null;
		currentTileMap = null;
		levelTree = null;
	}
	
}