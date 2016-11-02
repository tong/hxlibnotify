package sys.ui;

typedef NotifyServerInfo = {
	var name : String;
	var vendor : String;
	var version : String;
	var spec_version : String;
}

@:require(sys)
class Notify {

	/**
		Init libnotify.
		This must be called before any other functions.
	*/
	public static function init( appName : String ) : Bool {
		return
			#if cpp
			(_init( appName) == 0 ) ? false : true;
			#elseif neko
			(_init( untyped appName.__s) == 0 ) ? false : true;
			#else
			throw 'not implemented';
			#end
	}

	/**
		This should be called when the program no longer needs libnotify for the rest of its lifecycle, typically just before exitting.
	*/
	public static inline function uninit() {
		_uninit();
	}

	/**
		Gets whether or not libnotify is initialized.
	*/
	public static inline function isInitted() : Bool {
		return _is_initted() == 0 ? false : true;
	}

	/**
		Gets the application name registered.
	*/
	public static inline function getAppName() : String {
		return _get_app_name();
	}

	/**
		Sets the application name.
	*/
	public static inline function setAppName( v : String ) {
		#if cpp
		_set_app_name();
		#elseif neko
		_set_app_name( untyped v.__s );
		#end
	}

	/**
		Synchronously queries the server for its capabilities
	*/
	public static inline function getServerCaps() : Array<String> {
		return _get_server_caps();
	}

	/**
		Synchronously queries the server for its information, specifically, the name, vendor, server version, and the version of the notifications specification that it is compliant with.
	*/
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
		return
			#if cpp
			cpp.Lib.load( "libnotify", "hxlibnotify_"+f, n );
			#elseif neko
			neko.Lib.load( "libnotify", "hxlibnotify_"+f, n );
			#else
			null;
			#end
	}
}
