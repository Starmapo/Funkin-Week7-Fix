package;

import flixel.FlxBasic;
import flixel.FlxG;
import openfl.events.NetStatusEvent;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;
import vlc.MP4Handler;

class FlxVideo extends FlxBasic
{
	#if hxCodec
	var handler:MP4Handler;
	#end
	var video:Video;
	var netStream:NetStream;

	public var finishCallback:Void->Void;

	/**
	 * Doesn't actually interact with Flixel shit, only just a pleasant to use class    
	 */
	public function new(vidSrc:String, ?finishCallback:Void->Void)
	{
		super();
		this.finishCallback = finishCallback;

		#if hxCodec
		handler = new MP4Handler();
		handler.playVideo(Paths.file(vidSrc));
		handler.finishCallback = finishCallback;
		#else
		video = new Video();
		video.x = 0;
		video.y = 0;

		FlxG.addChildBelowMouse(video);

		var netConnection = new NetConnection();
		netConnection.connect(null);

		netStream = new NetStream(netConnection);
		netStream.client = {onMetaData: client_onMetaData};
		netConnection.addEventListener(NetStatusEvent.NET_STATUS, netConnection_onNetStatus);
		netStream.play(Paths.file(vidSrc));
		#end
	}

	public function finishVideo():Void
	{
		#if hxCodec
		handler.finishVideo();
		#else
		netStream.dispose();
		FlxG.removeChild(video);

		if (finishCallback != null)
			finishCallback();
		#end
	}

	public function client_onMetaData(metaData:Dynamic)
	{
		video.attachNetStream(netStream);

		video.width = FlxG.width;
		video.height = FlxG.height;
	}

	private function netConnection_onNetStatus(event:NetStatusEvent):Void
	{
		if (event.info.code == 'NetStream.Play.Complete')
			finishVideo();
	}
}
