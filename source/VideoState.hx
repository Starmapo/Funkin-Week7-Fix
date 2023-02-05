package;

import flixel.FlxG;

class VideoState extends MusicBeatState
{
	var video:FlxVideo;

	public static var seenVideo:Bool = false;

	override function create()
	{
		super.create();

		seenVideo = true;

		FlxG.save.data.seenVideo = true;
		FlxG.save.flush();

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		video = new FlxVideo('music/kickstarterTrailer.mp4', function()
		{
			TitleState.initialized = false;
			FlxG.switchState(new TitleState());
		});
	}

	override function update(elapsed:Float)
	{
		#if !hxCodec
		if (controls.ACCEPT)
			video.finishVideo();
		#end

		super.update(elapsed);
	}
}
