
import Sys.println;
import sys.ui.Notify;
import sys.ui.Notification;

class App {

	static function main() {

		#if neko
		cpp.Prime.nekoInit( "../ndll/Linux64/libnotify" );
		#end

		var appName = "libnotify-test";

		if( !Notify.init( appName ) ) {
			println( 'Failed to initialize libnotify' );
			return;
		}

		println( "Initted : "+Notify.isInitted() );
		println( "App name : "+Notify.getAppName() );
		println( "Server capabilities : "+Notify.getServerCaps() );
		println( "Server info : "+Notify.getServerInfo() );

		var n = new Notification( "HXLibnotify", "Bruce Willis Is Dead", "./haxe.png", 3 );
		n.setUrgency( NotificationUrgency.critical );
		n.setTimeout( Notification.EXPIRES_DEFAULT );
		n.show();

		//Sys.sleep(3);

		Notify.uninit();
	}
}
