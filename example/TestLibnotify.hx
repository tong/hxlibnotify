
import Sys.println;
import sys.ui.Notify;
import sys.ui.Notification;

class TestLibnotify {

	static function main() {

		var appName = "hxlibnotify-test";

		if( !Notify.init( appName ) ) {
			println( 'Failed to initialize libnotify' );
			return;
		}

		println( "Initted : "+Notify.isInitted() );
		println( "App name : "+Notify.getAppName() );
		println( "Server capabilities : "+Notify.getServerCaps() );
		println( "Server info : "+Notify.getServerInfo() );

		var n = new Notification( "HXLibnotify", "Bruce Willis is dead", "./haxe.png", 3 );
		//n.setUrgency( NotificationUrgency.critical );
		n.setTimeout( Notification.EXPIRES_DEFAULT );
		n.show();

		//Sys.sleep(3);

		Notify.uninit();
	}
}
