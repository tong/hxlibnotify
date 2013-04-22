
import sys.Notify;
import sys.Notification;

class TestLibnotify {
	
	static function main() {
		
		if( Notify.init( "hxlibnotify-test" ) ) {

			Sys.println( "Initted : "+Notify.isInitted() );
			Sys.println( "App name : "+Notify.getAppName() );
			Sys.println( "Server capabilities : "+Notify.getServerCaps() );
			Sys.println( "Server info : "+Notify.getServerInfo() );

			var n = new Notification( "HXLibnotify", "Bruce Willis is dead", "./haxe.png" );
			n.setUrgency( NotificationUrgency.critical );
			n.show();
			
			Notify.uninit();
		}
	}
}
