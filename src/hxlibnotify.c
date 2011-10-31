#include <stdio.h>
#include <glib.h>
#include <gtk/gtk.h>
#include <gdk/gdk.h>
#include <libnotify/notify.h>
#include <neko.h>
//#define IMPLEMENT_API
//#include <hx/CFFI.h>

DEFINE_KIND(k_notification);

#define is_notification(n) ( val_is_abstract(n) && val_is_kind(n,k_notification) )

/////// ---> notify --->

static value hxlibnotify_init(value appName) {
	val_check(appName, string);
	return alloc_bool( notify_init(val_string(appName)));
}

static value hxlibnotify_uninit() {
	notify_uninit();
	//free_root(); //TODO
	return val_null;
}

static value hxlibnotify_is_initted() {
	return alloc_bool( notify_is_initted() );
}

static value hxlibnotify_get_app_name() {
	return alloc_string(notify_get_app_name());
}

static value hxlibnotify_get_server_caps() {
	value r;
	guint len;
	GList *list = notify_get_server_caps();
	GList *elem;
	char * item;
	len = g_list_length(list);
	r = alloc_array(len);
	int i = 0;
	for (elem = list; elem; elem = elem->next) {
		item = elem->data;
		val_array_ptr(r)[i++] = alloc_string(item);
	}
	return r;
}

static value hxlibnotify_get_server_info() {
	char * name;
	char * vendor;
	char * version;
	char * spec_version;
	gboolean b = notify_get_server_info(&name, &vendor, &version,
			&spec_version);
	value o;
	if (b) {
		o = alloc_object(NULL);
		alloc_field(o, val_id("name"), alloc_string(name));
		alloc_field(o, val_id("vendor"), alloc_string(vendor));
		alloc_field(o, val_id("version"), alloc_string(version));
		alloc_field(o, val_id("spec_version"), alloc_string(spec_version));
	}
	g_free(name);
	g_free(vendor);
	g_free(version);
	g_free(spec_version);
	if (b)
		return o;
	return val_null;
}

DEFINE_PRIM( hxlibnotify_init, 1);
DEFINE_PRIM( hxlibnotify_uninit, 0);
DEFINE_PRIM( hxlibnotify_is_initted, 0);
DEFINE_PRIM( hxlibnotify_get_app_name, 0);
DEFINE_PRIM( hxlibnotify_get_server_caps, 0);
DEFINE_PRIM( hxlibnotify_get_server_info, 0);

/////// ---> NotifyNotification  --->

void finalize_notification(value v) {
	//free_data( val_data(v) );
	//TODO
}

static value hxlibnotify_notification_create(value _summary, value _body,
		value _icon, value _timeout, value _category) {

	val_check(_summary, string);
	val_check(_body, string);
	val_check(_icon, string);
	val_check(_timeout, int);
	val_check(_category, string);

	NotifyNotification *n = notify_notification_new(val_string(_summary),
			val_string(_body), val_string(_icon)); //TODO
	notify_notification_set_timeout(n, val_int(_timeout));
	notify_notification_set_category(n, val_string(_category));
	notify_notification_set_urgency(n, NOTIFY_URGENCY_CRITICAL); // TODO

	//TODO
	value v = alloc_abstract(k_notification, n);
	val_gc(v, finalize_notification);

	return v;
}

static value hxlibnotify_notification_update(value n, value _summary,
		value _body, value _icon) {
	if (!is_notification(n)) {
		neko_error();
	}val_check(_summary, string);
	val_check(_body, string);
	val_check(_icon, string);
	return alloc_bool( notify_notification_update(val_data(n),val_string(_summary),val_string(_body),val_string(_icon)));
}

static value hxlibnotify_notification_show(value n) {
	if (!is_notification(n)) {
		neko_error();
	}
	GError *err = NULL;
	notify_notification_show(val_data(n), &err);
	//printf("%s\n",err->);
	//TODO handle error
	if (err != NULL)
		return val_false;
	return val_true;
}

static value hxlibnotify_notification_set_timeout(value n, value v) {
	if (!is_notification(n)) {
		neko_error();
	}val_check(n, int);
	notify_notification_set_timeout(val_data(n), val_int(v));
	return val_null;
}

static value hxlibnotify_notification_set_category(value n, value v) {
	if (!val_is_abstract(k_notification))
		neko_error();val_check(n, string);
	notify_notification_set_timeout(val_data(n), val_int(v));
	return val_null;
}

static value hxlibnotify_notification_set_urgency(value n, value v) {
	if (!val_is_abstract(k_notification))
		neko_error();val_check(n, int);
	notify_notification_set_timeout(val_data(n), val_int(v));
	return val_null;
}

/*
 static value hxlibnotify_notification_set_icon_from_file(value n, value path) {
 //TODO

 GdkPixbuf * pb;
 //notify_notification_set_image_from_pixbuf(val_data(n),pb));

 return val_null;
 }
 */

/*
 static value hxlibnotify_notification_set_icon_from_pixbuf(value n, value pb) {
 //TODO
 return val_null;
 }
 */

//TODO
static void cb_action(NotifyNotification *n, char *action, gpointer user_data) {
	printf("TODO cb_action\n");
}

static value hxlibnotify_notification_add_action(value n, value action,
		value label, value cb, value user_data) {
	if (!is_notification(n))
		neko_error();val_check(action, string);
	val_check(action, string);
	val_check(label, string);
	val_check_function(cb, 0);
	//TODO
//	if( function_storage == NULL )
//	       function_storage = alloc_root(1);
	notify_notification_add_action(val_data(n), val_string(action),
			val_string(label), cb_action, NULL, NULL);
	return val_null;
}

static value hxlibnotify_notification_clear_actions(value n) {
	if (!is_notification(n)) {
		neko_error();
	}
	notify_notification_clear_actions(val_data(n));
	return val_null;
}

static value hxlibnotify_notification_close(value n) {
	if (!is_notification(n)) {
		neko_error();
	}
	GError *err = NULL;
	notify_notification_close(val_data(n), &err);
	if (err != NULL)
		return val_false;
	//TODO free neko
	//free_data( val_data(n) ); //finalize_notification(n);
	val_kind(n) = NULL;
	return val_true;
}

DEFINE_PRIM( hxlibnotify_notification_create, 5);
DEFINE_PRIM( hxlibnotify_notification_update, 4);
DEFINE_PRIM( hxlibnotify_notification_show, 1);
DEFINE_PRIM( hxlibnotify_notification_set_timeout, 2);
DEFINE_PRIM( hxlibnotify_notification_set_category, 2);
DEFINE_PRIM( hxlibnotify_notification_set_urgency, 2);

/*
 //DEFINE_PRIM( hxlibnotify_notification_set_icon_from_pixbuf, 2);
 DEFINE_PRIM( hxlibnotify_set_image_from_pixbuf, 2);
 DEFINE_PRIM( hxlibnotify_set_hint, 3);
 DEFINE_PRIM( hxlibnotify_set_hint_int32, 3);
 DEFINE_PRIM( hxlibnotify_set_hint_double, 3);
 DEFINE_PRIM( hxlibnotify_set_hint_string, 3);
 DEFINE_PRIM( hxlibnotify_set_hint_byte, 3);
 DEFINE_PRIM( hxlibnotify_set_hint_bytearray, 3);
 DEFINE_PRIM( hxlibnotify_clear_hints, 1);
 */
//DEFINE_PRIM_MULT( hxlibnotify_add_action);
DEFINE_PRIM( hxlibnotify_notification_add_action, 5);
DEFINE_PRIM( hxlibnotify_notification_clear_actions, 1);
DEFINE_PRIM( hxlibnotify_notification_close, 1);
