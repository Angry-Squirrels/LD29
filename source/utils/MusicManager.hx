package utils;
import flixel.system.FlxSound;
import flixel.system.FlxAssets;
import flixel.util.FlxTimer;
import flixel.util.FlxRandom;

/**
 * ...
 * @author Ynk33
 */
class MusicManager
{
	private static var musicPath:String = "assets/music/music_back";
	private static var heartBeatSlowPath:String = "assets/music/heart_beat_slow";
	private static var heartBeatQuickPath:String = "assets/music/heart_beat_quick";
	private static var dropLightPath:String = "assets/music/drop_light";
	private static var dropLoudPath:String = "assets/music/drop_loud";
	
	private static var musicSound:FlxSound;
	private static var heartBeatSlowSound:FlxSound;
	private static var heartBeatQuickSound:FlxSound;
	private static var dropLightSound:FlxSound;
	private static var dropLoudSound:FlxSound;
	
	private static var initialized:Bool = false;
	private static var musicPlaying:Bool = false;
	
	private static var timer:FlxTimer;
	
	public static function init():Void
	{
		musicSound = new FlxSound();
		musicSound.loadEmbedded(FlxAssets.getSound(musicPath), true);
		musicSound.volume = 2;
		heartBeatSlowSound = new FlxSound();
		heartBeatSlowSound.loadEmbedded(FlxAssets.getSound(heartBeatSlowPath), true);
		heartBeatQuickSound = new FlxSound();
		heartBeatQuickSound.loadEmbedded(FlxAssets.getSound(heartBeatQuickPath), true);
		dropLightSound = new FlxSound();
		dropLightSound.loadEmbedded(FlxAssets.getSound(dropLightPath), false);
		dropLoudSound = new FlxSound();
		dropLoudSound.loadEmbedded(FlxAssets.getSound(dropLoudPath), false);
		
		timer = new FlxTimer();
		
		initialized = true;
	}

	public static function playMusic():Void
	{
		if (!initialized)
		{
			init();
		}
		
		if (!musicSound.playing)
		{
			musicSound.play();
		}
		//launchTimer();
	}
	
	private static function launchTimer():Void
	{
		var time = FlxRandom.floatRanged(0, 10);
		if (musicPlaying)
		{
			timer.cancel();
			timer.reset(time);
		}
		else
		{
			musicPlaying = true;
			timer.start(time, timerCallback, 1);
		}
	}
	private static function timerCallback(_timer:FlxTimer):Void
	{
		FlxRandom.intRanged(0, 1) == 0 ? dropLightSound.play() : dropLoudSound.play();
		launchTimer();
	}
	
	public static function playSlowBeat():Void
	{
		if (!initialized)
		{
			init();
		}
		
		if (!heartBeatSlowSound.playing)
		{
			heartBeatSlowSound.play();
		}
	}
	
	public static function playQuickBeat():Void
	{
		if (!initialized)
		{
			init();
		}
		
		if (heartBeatSlowSound.playing)
		{
			heartBeatSlowSound.stop();
		}
		
		if (!heartBeatQuickSound.playing)
		{
			heartBeatQuickSound.play();
		}
	}
	
	public static function stopBeat():Void
	{
		if (heartBeatSlowSound.playing)
		{
			heartBeatSlowSound.stop();
		}
		if (heartBeatQuickSound.playing)
		{
			heartBeatQuickSound.stop();
		}
	}
	
	public static function stopMusic():Void
	{
		musicSound.stop();
		dropLightSound.stop();
		dropLoudSound.stop();
		timer.destroy();
	}
	
}