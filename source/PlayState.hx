package;

import ennemies.BaseEnnemy;
import flash.Lib;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import player.Hero;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	var level : Level;
	var hero:Hero;
	var map:FlxSprite;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		level = new Level("assets/data/levels/" + Reg.currentMap +".tmx", this);
		add(level.backgroundTiles);
		add(level.foregroundTiles);
		
		level.loadObjects();
		
		spawnHero();
		
		var ennemy:BaseEnnemy = new BaseEnnemy();
		ennemy.x = 200;
		ennemy.y = 3036;
		add(ennemy);
		
		FlxG.camera.follow(this.hero.hitbox);
		FlxG.camera.fade(0xff000000, 0.1, true);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		
		if (FlxG.keys.pressed.DOWN) {
			this.hero.canJumpThrough = true;
		}else {
			this.hero.canJumpThrough = false;
		}
		
		this.level.collideWithLevel(this.hero.hitbox);
		
		FlxG.overlap(level.doors, this.hero.hitbox, touchDoor);
	}	
	
	function touchDoor(door: Door, player:FlxSprite) 
	{
		door.enter(this.hero);
		Reg.vitX = hero.hitbox.velocity.x;
		Reg.vitY = hero.hitbox.velocity.y;
		
		FlxG.camera.fade(0xff000000, 0.1, false, fadeComplete);
		
		var doorCode : Dynamic = Math.random() * 14 + 1;
		var str = doorCode.toString(2);
		while (str.length < 4)
			str = "0" + str;
		trace(str);
		
		Reg.currentMap = "room_" + str;
	}
	
	function fadeComplete() {
		FlxG.resetState();
	}
	
	function spawnHero():Void 
	{
		var door : Door = null;
		var spawnX : Int = 100;
		var spawnY : Int = 100;
		
		switch(Reg.exitDirection) {
			case 'left' :
				door = level.getDoor('right');
				if (door != null) {
					spawnX = cast door.x - 64;
					spawnY = cast door.y - Reg.spawnOffsetY;
				}
			case 'right' :
				door = level.getDoor('left');
				if (door != null) {
					spawnX = cast door.x + 64;
					spawnY = cast door.y - Reg.spawnOffsetY;
				}
			case 'down' : 
				door = level.getDoor('up');
				if (door != null) {
					spawnX = cast door.x  - Reg.spawnOffsetX;
					spawnY = cast door.y  + 64 ;
				}
			case 'up' :
				door = level.getDoor('down');
				if (door != null){
					spawnX = cast door.x - Reg.spawnOffsetX;
					spawnY = cast door.y - 64 ; 
				}
		}
		
		
		this.hero = new Hero(spawnX, spawnY);
		FlxG.worldBounds.set(0, 0, level.fullWidth, level.fullHeight);
		hero.hitbox.velocity.x = Reg.vitX;
		hero.hitbox.velocity.y = Reg.vitY;
		add(this.hero);
	}
}