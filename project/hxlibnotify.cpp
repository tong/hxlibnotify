
#define IMPLEMENT_API
#define NEKO_COMPATIBLE

#include <hx/CFFI.h>
#include <stdio.h>
#include <glib.h>
#include <libnotify/notify.h>

#define val_notification(n) ( (NotifyNotification *) val_data(n) )

DEFINE_KIND( k_notification );

static value hxlibnotify_init( value app_name ) {
	gboolean ok = notify_init( val_string( app_name ) );
	return alloc_int(ok);
}

static value hxlibnotify_uninit() {
	notify_uninit();
	//free_root();
	return alloc_int(1);
}

static value hxlibnotify_is_initted() {
	return alloc_int( notify_is_initted() ); //alloc_bool( notify_is_initted() );
}

static value hxlibnotify_get_app_name() {
	return alloc_string( notify_get_app_name() );
}

static value hxlibnotify_set_app_name( value name ) {
	notify_set_app_name( val_string( name ) );
	return alloc_null();
}

static value hxlibnotify_get_server_caps() {
	value r;
	guint len;
	GList *list = notify_get_server_caps();
	GList *elem;
	gpointer item;
	len = g_list_length(list);
	r = alloc_array( len );
	int i = 0;
	for (elem = list; elem; elem = elem->next) {
		int v = GPOINTER_TO_INT( elem->data );
		val_array_set_i( r, i++, alloc_int( v ) );
	}
	return r;
}

static value hxlibnotify_get_server_info() {
	char * name;
	char * vendor;
	char * version;
	char * spec_version;
	gboolean b = notify_get_server_info( &name, &vendor, &version, &spec_version );
	value o;
	if(b) {
		o = alloc_empty_object();
		alloc_field(o, val_id("name"), alloc_string(name));
		alloc_field(o, val_id("vendor"), alloc_string(vendor));
		alloc_field(o, val_id("version"), alloc_string(version));
		alloc_field(o, val_id("spec_version"), alloc_string(spec_version));
	}
	g_free(name);
	g_free(vendor);
	g_free(version);
	g_free(spec_version);
	return b ? o : alloc_null();
}

DEFINE_PRIM( hxlibnotify_init, 1 );
DEFINE_PRIM( hxlibnotify_uninit, 0 );
DEFINE_PRIM( hxlibnotify_is_initted, 0 );
DEFINE_PRIM( hxlibnotify_get_app_name, 0 );
DEFINE_PRIM( hxlibnotify_set_app_name, 1 );
DEFINE_PRIM( hxlibnotify_get_server_caps, 0 );
DEFINE_PRIM( hxlibnotify_get_server_info, 0 );


// --- NotifyNotification  ---

/*
void finalize_notification(value v) {
	//free_data( val_data(v) );
	//TODO
}
*/

static value hxlibnotify_notification_create( value _summary, value _body, value _icon, value _timeout, value _category ) {
	NotifyNotification *n = notify_notification_new( val_string(_summary), val_string(_body), val_string(_icon) ); //TODO
	notify_notification_set_timeout( n, val_int( _timeout ) );
	notify_notification_set_category( n, val_string( _category ) );
	notify_notification_set_urgency( n, NOTIFY_URGENCY_CRITICAL ); // TODO
	value v = alloc_abstract( k_notification, n );
	//TODO
	//val_gc( v, finalize_notification );
	return v;
}

static value hxlibnotify_notification_update( value n, value _summary, value _body, value _icon ) {
	const char *summary = val_string( _summary );
	const char *body = val_string( _body );
	const char *icon = val_string( _icon );
	notify_notification_update( val_notification(n), summary, body, icon );
	return alloc_bool(TRUE);
}

static value hxlibnotify_notification_show( value n ) {
	//printf("hxlibnotify_notification_show\n");
	GError *err = NULL;
	notify_notification_show( (NotifyNotification *) val_data(n), &err );
	return alloc_int( ( err != NULL ) ? 0 : 1 ); //alloc_bool( err != NULL );
}

static value hxlibnotify_notification_set_app_name( value n, value v ) {
	notify_notification_set_app_name( val_notification(n), val_string(v) );
	return alloc_null();
}

static value hxlibnotify_notification_set_timeout( value n, value v ) {
	notify_notification_set_timeout( val_notification(n), val_int(v) );
	return alloc_null();
}

static  value hxlibnotify_notification_set_category( value n, value v ) {
	if (!val_is_abstract(n))
		neko_error();
	val_check(n, string);
	notify_notification_set_timeout( val_notification(n), val_int(v) );
	//return alloc_null();
	return val_null;
}

static value hxlibnotify_notification_set_urgency( value n, value v ) {
	notify_notification_set_timeout( val_notification(n), val_int(v) );
	return alloc_null();
}

/*
//TODO
static value hxlibnotify_notification_set_icon_from_pixbuf(value n, value pb) {
}

static value hxlibnotify_notification_set_icon_from_file(value n, value path) {
 	GdkPixbuf * pb;
 	//notify_notification_set_image_from_pixbuf(val_data(n),pb));
 	return alloc_null();
 }
 */

static value hxlibnotify_notification_set_hint( value n, value k, value v ) {
	const gchar *ks = val_string( k );
	const gchar *vs = val_string( v );
	GVariant *value = g_variant_new( vs );
	notify_notification_set_hint( val_notification(n), ks, value );
	return alloc_null();
}

static value hxlibnotify_notification_clear_hints( value n ) {
	notify_notification_clear_hints( val_notification(n) );
	return alloc_null();
}

//TODO
static void cb_action(NotifyNotification *n, char *action, gpointer user_data) {
	printf("TODO cb_action\n");
}

static value hxlibnotify_notification_add_action( value n, value action, value label, value cb, value user_data ) {
//TODO
//	if( function_storage == NULL )
//		function_storage = alloc_root(1);
	notify_notification_add_action( val_notification(n), val_string(action), val_string(label), cb_action, NULL, NULL );
	return alloc_null();
}

static value hxlibnotify_notification_clear_actions( value n ) {
	notify_notification_clear_actions( (NotifyNotification *) val_data(n) );
	return alloc_null();
}

static  value hxlibnotify_notification_close( value n ) {
	GError *err = NULL;
	notify_notification_close( val_notification(n), &err );
	if( err != NULL )
		return alloc_bool( FALSE );
	//TODO free neko
	//free_data( val_data(n) ); //finalize_notification(n);
	return alloc_bool(TRUE);
}

static value hxlibnotify_notification_get_closed_reason( value n ) {
	notify_notification_get_closed_reason( val_notification(n) );
	return alloc_null();
}

DEFINE_PRIM( hxlibnotify_notification_create, 5 );
DEFINE_PRIM( hxlibnotify_notification_update, 4 );
DEFINE_PRIM( hxlibnotify_notification_show, 1 );
DEFINE_PRIM( hxlibnotify_notification_set_app_name, 1 );
DEFINE_PRIM( hxlibnotify_notification_set_timeout, 2 );
DEFINE_PRIM( hxlibnotify_notification_set_category, 2 );
DEFINE_PRIM( hxlibnotify_notification_set_urgency, 2 );
//DEFINE_PRIM( hxlibnotify_notification_set_icon_from_pixbuf, 2 );
//DEFINE_PRIM( hxlibnotify_set_image_from_pixbuf, 2);
DEFINE_PRIM( hxlibnotify_notification_set_hint, 3 );
DEFINE_PRIM( hxlibnotify_notification_clear_hints, 1 );
DEFINE_PRIM( hxlibnotify_notification_add_action, 5 );
DEFINE_PRIM( hxlibnotify_notification_clear_actions, 1 );
DEFINE_PRIM( hxlibnotify_notification_close, 1 );
DEFINE_PRIM( hxlibnotify_notification_get_closed_reason, 1 );
