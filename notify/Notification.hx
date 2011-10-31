package notify;

enum NotificationUrgency {
	low;
	normal;
	critical;
}

class Notification {
	
	public static var defaultCategory = "hxlibnotify";
	
	var __i : Void;
	
	public function new( summary : String, body : String, icon : String, timeout : Int = 3000, ?category : String ) {
		if( category == null ) category = defaultCategory;
		__i = _create( untyped summary.__s, untyped body.__s, untyped icon.__s , timeout, untyped category.__s );
	}
	
	public inline function show() _show(__i)
	public inline function update( summary : String, body : String, icon : String ) : Bool return _update(__i, untyped summary.__s, untyped body.__s, untyped icon.__s )
	public inline function setTimeout(v:Int) _set_timeout(__i,v)
	public inline function setCategory(v:String) _set_catgeory(__i,untyped v.__s)
	public inline function setUrgency(v:NotificationUrgency) _set_urgency(__i,Type.enumIndex(v))
	
	public inline function close() _close(__i)
	public function addAction( action : String, label : String, cb : Void->Void, ?userData : Dynamic ) {
		_add_action( __i, untyped action.__s, untyped action.__s, cb, userData );
	}
	
	static var _create = x( "create", 4 );
	static var _update = x( "update", 3 );
	static var _show = x( "show" );
	static var _set_timeout = x( "set_timeout", 1 );
	static var _set_catgeory = x( "set_category", 1 );
	static var _set_urgency = x( "set_urgency", 1 );
	static var _add_action = x( "add_action", 4 );
	static var _close = x( "close" );
	
	static function x( f : String, args : Int = 0 ) : Dynamic return notify.Lib.load( "notification_"+f, 1+args )
	
}
