package sys.ui;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

enum NotificationUrgency {

	/**
		Low urgency. Used for unimportant notifications.
	*/
	low;

	/**
		Normal urgency. Used for most standard notifications.
	*/
	normal;

	/**
		Critical urgency. Used for very important notifications.
	*/
	critical;
}

/**
	Represents a passive pop-up notification.
	It can contain summary text, body text, and an icon, as well as hints specifying how the notification should be presented.
	The notification is rendered by a notification daemon, and may present the notification in any number of ways.
	As such, there is a clear separation of content and presentation, and this API enforces that.
*/
@:require(sys)
class Notification {

	public static inline var EXPIRES_DEFAULT = -1;
	public static inline var EXPIRES_NEVER = 0;

	public static var defaultCategory = 'libnotify';

	var __i : Dynamic;

	public function new( summary : String, body : String, icon : String, timeout : Int = 3000, ?category : String ) {

		if( category == null ) category = defaultCategory;

		#if cpp
		__i = _create( summary,
					   body,
					   (Sys.getCwd()+icon),
					   timeout,
					   category );

		#elseif neko
		__i = _create( untyped summary.__s,
					   untyped body.__s,
					   untyped (Sys.getCwd()+icon).__s,
					   timeout,
					   untyped category.__s );
		#end
	}

	/**
		Updates the notification text and icon. This won't send the update out and display it on the screen. For that, you will need to call
	*/
	public inline function update( summary : String, body : String, icon : String ) : Bool {
		#if cpp
		return _update( __i, summary, body, icon );
		#elseif neko
		return _update( __i, untyped summary.__s, untyped body.__s, untyped icon.__s );
		#else
		return throw 'not implemented';
		#end
	}

	/**
		Tells the notification server to display the notification on the screen.
	*/
	public inline function show() : Bool
		return _show( __i ) == 0 ? false : true;

	/**
		Sets the application name for the notification.
	*/
	public static inline function setAppName( v : String ) {
		#if cpp
		_set_app_name();
		#elseif neko
		_set_app_name( untyped v.__s );
		#end
	}

	/**
		Sets the timeout of the notification.
	*/
	public inline function setTimeout( v : Int ) {
		_set_timeout( __i, v );
	}

	/**
		Sets the category of this notification.
		This can be used by the notification server to filter or display the data in a certain way.
	*/
	public inline function setCategory( v : String ) {
		#if cpp
		_set_catgeory( __i, v );
		#elseif neko
		_set_catgeory( __i, untyped v.__s );
		#end
	}

	/**
		Sets the urgency level of this notification.
	*/
	public inline function setUrgency( v : NotificationUrgency ) {
		_set_urgency( __i, Type.enumIndex(v) );
	}

	/**
		Adds an action to a notification.
		When the action is invoked, the specified callback function will be called, along with the value passed to user_data.
	*/
	public inline function addAction( action : String, label : String, cb : Void->Void, ?userData : Dynamic ) {
		#if cpp
		_add_action( __i, action, action, cb, userData );
		#elseif neko
		_add_action( __i, untyped action.__s, untyped action.__s, cb, userData );
		#end
	}

	/**
		Synchronously tells the notification server to hide the notification on the screen.
	*/
	public inline function close() {
		_close( __i );
	}

	/**
		Returns the closed reason code for the notification.
		This is valid only after the "closed" signal is emitted.
	*/
	public inline function getClosedReason() : Int {
		return _get_closed_reason( __i );
	}

	static var _create = x( "create", 5 );
	static var _update = x( "update", 4 );
	static var _show = x( "show", 1 );
	static var _set_app_name = x( "set_app_name", 1 );
	static var _set_timeout = x( "set_timeout", 2 );
	static var _set_catgeory = x( "set_category", 2 );
	static var _set_urgency = x( "set_urgency", 2 );
	//static var _set_urgency = x( "set_icon_from_pixbuf", 2 );
	//static var _set_urgency = x( "set_image_from_pixbuf", 2 );
	static var _set_hint = x( "set_hint", 3 );
	static var _clear_hints = x( "clear_hints", 1 );
	static var _add_action = x( "add_action", 5 );
	static var _clear_actions = x( "clear_actions", 1 );
	static var _close = x( "close", 1 );
	static var _get_closed_reason = x( "get_closed_reason", 1 );

	static function x( f : String, args : Int = 0 ) : Dynamic {
		#if cpp
		return Lib.load( "libnotify", "hxlibnotify_notification_"+f, args );
		#elseif neko
		return Lib.load( "libnotify", "hxlibnotify_notification_"+f, args );
		#else
		return null;
		#end
	}

}
