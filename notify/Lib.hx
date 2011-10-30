package notify;

typedef ServerInfo = {
	var name : String;
	var vendor : String;
	var version : String;
	var spec_version : String;
}

/*
typedef Error = {
	var code : Int;
	var domain : GQuark;
	var message : String;
}
*/

class Lib {
	
	public static function init( appName : String ) : Bool {
		_init( untyped appName.__s );
		return false; //TODO
	}
	
	public static inline function getServerCaps() : List<String> return _get_server_caps()
	public static inline function getServerInfo() : ServerInfo return _get_server_info()
	
	public static function x( f : String, args : Int = 0 ) : Dynamic {
		#if cpp
		return cpp.Lib.load( "libnotify", "hxlibnotify_"+f, args );
		#elseif neko
		return neko.Lib.load( "libnotify", "hxlibnotify_"+f, args );
		#end
	}
	
	static var _init = x( "init", 1 );
	static var _uninit = x( "uninit" );
	static var _is_initted = x( "is_initted" );
	static var _get_app_name = x( "get_app_name" );
	static var _get_server_caps = x( "get_server_caps" );
	static var _get_server_info = x( "get_server_info" );
	
}
