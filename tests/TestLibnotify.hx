
class TestLibnotify {
	
	static inline function print(t) neko.Lib.println(t)
	
	static function main() {
		
		var cwd = neko.Sys.getCwd();
		trace( cwd+"img/haxe_128.png" );
		
		gtk.Lib.init();
		
		notify.Lib.init( "hxlibnotify" );
		print( "  notify.ServerInfo: "+notify.Lib.getServerInfo() );
		var notifyCaps = notify.Lib.getServerCaps();
		print( "  notify.ServerCapabilities: "+notifyCaps );
		
		var n = new notify.Notification( "hx.libnotify.test", "Bruce Willis is dead", cwd+"img/haxe_128.png", 1000 );
		//if( notifyCaps.has() ) n.
		n.show();
		
		var n2 = new notify.Notification( "disktree", "Don't give a fuck who you are, my crew get down to murder ya", cwd+"img/haxe_128.png", 2000 );
		n2.show();
		
		gtk.Lib.run();
		
		notify.Lib.uninit();
		gtk.Lib.quit();
	}
	
}
