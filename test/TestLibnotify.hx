
import sys.ui.Notify;
import sys.ui.Notification;

class TestLibnotify {
	
	static function main() {

		var appName = "hxlibnotify-test";

		if( Notify.init( appName ) ) {

			Sys.println( "Initted : "+Notify.isInitted() );
			Sys.println( "App name : "+Notify.getAppName() );
			Sys.println( "Server capabilities : "+Notify.getServerCaps() );
			Sys.println( "Server info : "+Notify.getServerInfo() );

			var n = new Notification( "HXLibnotify", "Bruce Willis is dead", "./haxe.png", 10000 );
			n.setUrgency( NotificationUrgency.critical );
			n.show();
			
			Notify.uninit();
		}
		
	}
}
