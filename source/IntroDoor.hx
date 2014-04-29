package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.loaders.SparrowData;
import haxe.Timer;
import flixel.util.FlxRandom;

/**
 * ...
 * @author TBaudon
 */
class IntroDoor extends FlxSprite
{
	
	var opening : Bool;
	var closing : Bool;
	var closed : Bool;
	var shown : Bool;
	
	private var sentences:Array<String> = [
		"Are you deaf or what ?",
		"Run ! You fool !",
		"Why are you still here ?",
		"Don't you have a game to play ?",
		"No, the exit is not this way.",
		"You'll never finish the game if you stay here, you know ?",
		"Press the right arrow to go right, not the left one.",
		"Are you afraid ? Press X or use your left click to defend yourself !",
		"The people behind this game are awesome.",
		"... the game was finished 20 min before the dead line",
		"... the door is blocked."
	];
	var closeTimer : Timer;

	public function new(x: Int, y: Int, shown : Bool) 
	{
		super(x, y);
		this.shown = shown;
		var dat = new SparrowData("assets/images/story_door.xml", "assets/images/story_door.png");
		loadGraphicFromTexture(dat, false);
		animation.addByPrefix("closeMain", "LD29_story_close", 40, false);
		animation.addByPrefix("open", "LD29_story_open", 12, false);
		animation.addByPrefix("close", "LD29_story_miniClose", 40, false);
		
		animation.callback = checkFrame;
		
		if (shown) {
			closed = true;
			closing = true;
			opening = false;
			animation.play("closeMain");
		}
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
			else if (frameNumber == 1)
			{
				FlxG.sound.play("assets/sounds/door_slap.mp3");
			}
		}
		else if (name == "open")
		{
			FlxG.sound.play("assets/sounds/door_slide_on.mp3");
		}
		else if (name == "close")
		{
			FlxG.sound.play("assets/sounds/door_slide_off.mp3");
		}
	}
	
	public function close() {
		closeTimer = Timer.delay(closeDoor, 3000);
		if(!shown)
			Reg.playState.speakDoor("Don't mind to come back until you find a way up there!");
	}
	
	function closeDoor() {
		animation.play("closeMain");
		
	}
	
	public function open() {
		if (!opening)
		{
			animation.play("open");
			
			var sentence = sentences[FlxRandom.intRanged(0, sentences.length - 1)];
			Reg.playState.speakDoor(sentence);
			opening = true;
			closing = false;
		}
	}
	
	public function reclose() {
		if (!closing)
		{
			animation.play("close");
			Reg.playState.speakDoor("");
			closing = true;
			opening = false;
		}
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
	
	override public function destroy() { 
		super.destroy();
		if(closeTimer != null)
			closeTimer.stop();
	}
	
}