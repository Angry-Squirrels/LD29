package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.system.FlxAssets;
import flixel.tweens.FlxTween;
import haxe.Timer;
import utils.MusicManager;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	
	var bg:flixel.FlxSprite;
	var goDown : Bool;
	var vit : Float;
	var startText : FlxText;
	
	var storyStarted : Bool;
	
	var introText : FlxText;
	
	var indexText : Int;
	var endIntro : Bool;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		bg = new FlxSprite(0, 0, FlxAssets.getBitmapData("assets/images/Illu_worlds_end.jpg"));
		add(bg);
		
		startText = new FlxText(100, 380, 0, 'Press < X > to start your journey', 18);
		startText.x = (800 - startText.width) / 2;
		add(startText);
		
		vit = 0;
		
		introText = new FlxText(0, 0, 550, "", 18);
		introText.setFormat(null, 18, 0xffffffff, "center");
		introText.x = (800 - 550) / 2;
		introText.alpha = 0;
		add(introText);
		
		MusicManager.playTitleMusic();
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
		
		if (FlxG.keys.justPressed.X && goDown == false ) {
			FlxG.camera.flash(0xffffff, 1);
			remove(startText);
			goDown = true;
		}
		
		if (goDown && !storyStarted) {
			vit +=  0.03;
			if (vit > 10) vit = 10;
			bg.y -= vit;
			startText.y -= vit;
			
			if (bg.y < -1000) {
				storyStarted = true;
				fadeInText();
			}
		}
	}
	
	function fadeInText(tween: FlxTween = null) {
		introText.alpha = 0;
		introText.text = Reg.storyTexts[indexText];
		introText.y = (480 - introText.height) / 2;
		FlxTween.tween(introText, { alpha:1 }, 2, { complete: fedeInComplete } );
		
		indexText ++;
		if (indexText == Reg.storyTexts.length )
			endIntro = true;
	}
	
	function fedeInComplete(tween: FlxTween) {
		var delay = Reg.storyTime[indexText];
		Timer.delay(fadeOutText, delay);
	}
	
	function fadeOutText() 
	{
		if(!endIntro){
			FlxTween.tween(introText, { alpha:0 }, 2, { complete: fadeInText } );
		}
		else {
			MusicManager.stopTitleMusic();
			FlxTween.tween(introText, { alpha:0 }, 2, { complete: gotoGame } );
		}
	}
	
	function gotoGame(tween: FlxTween) {
		FlxG.switchState(new PlayState());
	}
}