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
	
	public static inline function init( appName : String ) : Bool return _init( untyped appName.__s )
	public static inline function uninit() _uninit()
	public static inline function getServerCaps() : Array<String> return neko.Lib.nekoToHaxe( _get_server_caps() )
	public static inline function getServerInfo() : ServerInfo return _get_server_info()
	
	public static function load( f : String, args : Int = 0 ) : Dynamic {
		#if cpp
		return cpp.Lib.load( "libnotify", "hxlibnotify_"+f, args );
		#elseif neko
		return neko.Lib.load( "libnotify", "hxlibnotify_"+f, args );
		#end
	}
	
	static var _init = load( "init", 1 );
	static var _uninit = load( "uninit" );
	static var _is_initted = load( "is_initted" );
	static var _get_app_name = load( "get_app_name" );
	static var _get_server_caps = load( "get_server_caps" );
	static var _get_server_info = load( "get_server_info" );
	
}
