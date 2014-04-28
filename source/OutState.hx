package ;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.FlxG;

/**
 * ...
 * @author TBaudon
 */
class OutState extends FlxState
{

	var theEnd : FlxText;
	var thanks : FlxText;
	
	override public function create() {
		super.create();
		
		bgColor = 0xffffffff;
		
		theEnd = new FlxText(0, 0, 0, "The End", 24);
		theEnd.color = 0xff000000;
		theEnd.x = (800 - theEnd.width) / 2;
		theEnd.y = (480 - theEnd.height) / 2;
		theEnd.alpha = 0;
		add(theEnd);
		FlxTween.tween(theEnd, { alpha:1 }, 1, { complete: endComplete } );
	}
	
	function endComplete(tween : FlxTween) {
		thanks = new FlxText(0, 0, 0, "Thanks for playing", 24);
		thanks.color = 0xff000000;
		thanks.x = (800 - thanks.width) / 2;
		thanks.y = (480 - theEnd.height) / 2 + 40;
		thanks.alpha = 0;
		add(thanks);
		FlxTween.tween(thanks, { alpha:1 }, 1, { complete: thanksComplete } );
	}
	
	function thanksComplete(tween : FlxTween) {
		var tweet = new FlxText(0, 0, 0, "@damrem, @sentsu_actu, @ynck_33, @RadStar_", 24);
		tweet.color = 0xff000000;
		tweet.x = (800 - tweet.width) / 2;
		tweet.y = (480 - theEnd.height) / 2 + 80;
		tweet.alpha = 0;
		add(tweet);
		FlxTween.tween(tweet, { alpha:1 }, 2, { complete: xTocontinue } );
	}
	
	function xTocontinue(tween : FlxTween) {
		var t = new FlxText(0, 0, 0, "Press < X > to continue.", 24);
		t.color = 0xff000000;
		t.x = (800 - t.width) / 2;
		t.y = (480 - theEnd.height) / 2 + 120;
		t.alpha = 0;
		add(t);
		FlxTween.tween(t, { alpha:1 }, 2);
	}
	
	override public function update() {
		super.update();
		
		if (FlxG.keys.justPressed.X)
			FlxG.camera.fade(0xff000000, 1, false, goMenu);
	}
	
	function goMenu() 
	{
		FlxG.switchState(new MenuState());
	}
	
}