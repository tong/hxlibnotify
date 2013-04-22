package sys.ui;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

typedef NotifyServerInfo = {
	var name : String;
	var vendor : String;
	var version : String;
	var spec_version : String;
}

class Notify {

	public static function init( appName : String ) : Bool {
		#if cpp
		return _init( appName );
		#elseif neko
		//TODO
		//return _init( untyped appName.__s );
		return neko.Lib.nekoToHaxe( _init( untyped appName.__s ) );
		#end
	}
	
	public static inline function uninit() {
		_uninit();
	}

	public static inline function isInitted() : Bool {
		return _is_initted();
	}

	public static inline function getAppName() : String {
		return _get_app_name();
	}

	public static inline function setAppName( v : String ) {
		#if cpp
		_set_app_name();
		#elseif neko
		_set_app_name( untyped v.__s );
		#end
	}
	
	public static inline function getServerCaps() : Array<String> {
		#if cpp
		return _get_server_caps();
		#elseif neko
		return neko.Lib.nekoToHaxe( _get_server_caps() );
		#end
	}
	
	public static inline function getServerInfo() : NotifyServerInfo {
		return _get_server_info();
	}
	
	static var _init = x( "init", 1 );
	static var _uninit = x( "uninit" );
	static var _is_initted = x( "is_initted" );
	static var _get_app_name = x( "get_app_name" );
	static var _set_app_name = x( "set_app_name", 1 );
	static var _get_server_caps = x( "get_server_caps" );
	static var _get_server_info = x( "get_server_info" );
	
	static inline function x( f : String, n : Int = 0 ) : Dynamic {
		return Lib.load( "libnotify", "hxlibnotify_"+f, n );
	}
}
