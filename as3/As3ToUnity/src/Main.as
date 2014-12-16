package 
{
	import air.net.SocketMonitor;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	
	/**
	 * ...
	 * @author weichih25@gmail.com
	 */
	public class Main extends Sprite 
	{
		
		static private const IP:String = "127.0.0.1";
		static private const PORT:uint =9050;
		
		private var _socket:Socket;
		private var _textFiled:TextField;
		private var _sprite:Sprite;
		private var _log:String;
		private var _sendTextTimer:Timer;
		private var _conectTimer:Timer;
		
		
		
		public function Main():void 
		{
			_socket = new Socket();
			_socket.addEventListener(Event.CONNECT, OnConnectedHandler);
			_socket.addEventListener(Event.CLOSE, OnDisconnetedHandler);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, OnConnectErrorHandler);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, OnConnectErrorHandler);
			
			_sprite = new Sprite();
			_textFiled = new TextField();
			_sprite.addChild(_textFiled);
			addChild(_sprite);
			
			_textFiled.text = "Welcome :)";
			_textFiled.width = stage.stageWidth;
			_textFiled.height = stage.stageHeight;
			_socket.connect(IP, PORT);
			
			_sendTextTimer = new Timer(1000);
			_sendTextTimer.addEventListener(TimerEvent.TIMER, OnTimerHandler);
	
			 _conectTimer = new Timer(3000,1);
			 _conectTimer.addEventListener(TimerEvent.TIMER, OnConnectTimerHandler);
			
		}
		
		private function OnConnectedHandler(e:Event):void {
			ConsoleWriteLine("Connect to Server.");
			_socket.writeUTFBytes("Hello :)");
			_socket.flush();
			_sendTextTimer.start();
		}
		
		private function OnConnectErrorHandler(e:Event):void {
			ConsoleWriteLine("Connecting ...");
			_conectTimer.start();
		}
		
		private function OnDisconnetedHandler(e:Event):void {
			ConsoleWriteLine("Disconnect to Server");
			_sendTextTimer.stop();
			_conectTimer.start();
		}
		
		private function OnConnectTimerHandler(e:TimerEvent):void {
			_socket.connect(IP, PORT);
		}
		
		private function OnTimerHandler(e:TimerEvent):void {
			var msg:String = String(Math.random());
			if(_socket.connected){
				_socket.writeUTFBytes(msg);
				_socket.flush();
				ConsoleWriteLine(msg);
			}
		}
		
		private function ConsoleWriteLine(cmd:String):void {
			_textFiled.text = cmd + "\n" + _textFiled.text; 
		}
		
		
	}
	
}