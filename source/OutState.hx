package ;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import utils.MusicManager;
import haxe.Timer;

/**
 * ...
 * @author TBaudon
 */
class OutState extends FlxState
{

	var theEnd : FlxText;
	var thanks : FlxText;
	var endText:FlxText;
	var outText:FlxText;
	
	override public function create() {
		super.create();
		
		bgColor = 0xffffffff;
		
		endText = new FlxText(0, 0, 0 , "Finally...", 32);
		endText.color = 0xff8db9cf;
		endText.x = (800 - endText.width) / 2;
		endText.y = (480 - endText.height) / 2 - 100;
		endText.alpha = 0;
		add(endText);
		FlxTween.tween(endText, { alpha:1 }, 1, { complete: waitForComplete } );
	}
	
	function waitForComplete(tween:FlxTween):Void
	{
		waitFor(1000, finallyComplete);
	}
	
	function finallyComplete():Void
	{
		FlxTween.tween(endText, { alpha:0 }, 1, { complete: imoutIntro } );
	}
	
	function imoutIntro(tween:FlxTween)
	{
		outText = new FlxText(0, 0, 0 , "I'm out...", 32);
		outText.color = 0xff8db9cf;
		outText.x = (800 - outText.width) / 2;
		outText.y = (480 - outText.height) / 2 - 100;
		outText.alpha = 0;
		add(outText);
		FlxTween.tween(outText, { alpha:1 }, 1, { complete: waitForImOut } );
	}
	
	function waitForImOut(tween:FlxTween)
	{
		waitFor(1000, imoutComplete);
	}
	
	function imoutComplete():Void
	{
		FlxTween.tween(outText, { alpha:0 }, 1, { complete: theendIntro } );
	}
	
	function theendIntro(tween:FlxTween)
	{
		MusicManager.playTitleMusic();
		theEnd = new FlxText(0, 0, 0, "The End", 56);
		theEnd.color = 0xff8db9cf;
		theEnd.x = (800 - theEnd.width) / 2;
		theEnd.y = (480 - theEnd.height) / 2 - 100;
		theEnd.alpha = 0;
		add(theEnd);
		FlxTween.tween(theEnd, { alpha:1 }, 1, { complete: waitForEndComplete } );
	}
	
	function waitForEndComplete(tween:FlxTween)
	{
		waitFor(1000, endComplete);
	}
	
	function endComplete():Void {
		thanks = new FlxText(0, 0, 0, "Thanks for playing", 24);
		thanks.color = 0xff8db9cf;
		thanks.x = (800 - thanks.width) / 2;
		thanks.y = theEnd.y + 80;
		thanks.alpha = 0;
		add(thanks);
		FlxTween.tween(thanks, { alpha:1 }, 1, { complete: thanksComplete } );
	}
	
	function thanksComplete(tween : FlxTween) {
		var tweet = new FlxText(0, 0, 700, "@damrem, @sentsu_actu, @ynck_33, @thomas_baudon, @RadStar_", 24);
		tweet.setFormat(null, 24, 0xff8db9cf, 'center');
		tweet.color = 0xff8db9cf;
		tweet.x = (800 - tweet.width) / 2;
		tweet.y = theEnd.y + 130;
		tweet.alpha = 0;
		add(tweet);
		FlxTween.tween(tweet, { alpha:1 }, 2, { complete: xTocontinue } );
	}
	
	function xTocontinue(tween : FlxTween) {
		var t = new FlxText(0, 0, 0, "Press < X > to continue.", 24);
		t.color = 0xff8db9cf;
		t.x = (800 - t.width) / 2;
		t.y = theEnd.y + 200;
		t.alpha = 0;
		add(t);
		FlxTween.tween(t, { alpha:1 }, 2);
	}
	
	override public function update() {
		super.update();
		
		if (FlxG.keys.justPressed.X)
		{
			MusicManager.stopTitleMusic(1);
			FlxG.camera.fade(0xff000000, 1, false, goMenu);
		}
	}
	
	function goMenu() 
	{
		FlxG.switchState(new MenuState());
	}
	
	function waitFor(_time:Int, _callBack:Void->Void):Void
	{
		Timer.delay(_callBack, _time);
	}
	
}