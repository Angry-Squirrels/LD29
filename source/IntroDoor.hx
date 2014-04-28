package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.loaders.SparrowData;
import haxe.Timer;

/**
 * ...
 * @author TBaudon
 */
class IntroDoor extends FlxSprite
{
	
	var opening : Bool;
	var closing : Bool;
	var closed : Bool;

	public function new(x: Int, y: Int) 
	{
		super(x, y);
		var dat = new SparrowData("assets/images/story_door.xml", "assets/images/story_door.png");
		loadGraphicFromTexture(dat, false);
		animation.addByPrefix("closeMain", "LD29_story_close", 25, false);
		animation.addByPrefix("open", "LD29_story_open", 12, false);
		animation.addByPrefix("close", "LD29_story_miniClose", 12, false);
		
		animation.callback = checkFrame;
	}
	
	function checkFrame(name:String, frameNumber : Int, frameidx:Int) {
		if (name == "closeMain") {
			if ( frameNumber == 4) {
				if(!closed){
					FlxG.camera.shake(0.005, 0.2);
					Reg.playState.speakDoor("");
				}
				closed = true;
			}
		}	
	}
	
	public function close() {
		Timer.delay(closeDoor, 3000);
		Reg.playState.speakDoor("Don't mind to come back until you find a way up there!");
	}
	
	function closeDoor() {
		animation.play("closeMain");
		
	}
	
	public function open() {
		if(!opening)
			animation.play("open");
		Reg.playState.speakDoor("Are you deaf or what?");
		opening = true;
		closing = false;
	}
	
	public function reclose() {
		if (!closing)
			animation.play("close");
			Reg.playState.speakDoor("");
		closing = true;
		opening = false;
	}
	
	override public function update() {
		super.update();
		
		if(closed) {
			var heroDist = Reg.hero.hitbox.x - x;
			if (heroDist < 140)
				open();
			else
				reclose();
		}
	}
	
}