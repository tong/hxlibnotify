#include <stdio.h>
#include <libnotify/notify.h>
#include <gtk/gtk.h>
#include <glib.h>
#include <neko.h>

/////// ---> notify --->

static value hxlibnotify_init(value appName) {
	val_check(appName, string);
	return alloc_bool( notify_init(val_string(appName)));
}

static value hxlibnotify_uninit() {
	notify_uninit();
	//free_root();
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
	for(elem = list; elem; elem = elem->next) {
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

DEFINE_KIND(k_notification);

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

	return alloc_abstract(k_notification, n);
}

static value hxlibnotify_notification_update(value n, value _summary,
		value _body, value _icon) {
	if (!val_is_abstract(n) || !val_is_kind(n, k_notification)) {
		neko_error();
	}
	val_check(_summary, string);
	val_check(_body, string);
	val_check(_icon, string);
	return alloc_bool( notify_notification_update(val_data(n),val_string(_summary),val_string(_body),val_string(_icon)));
}

static value hxlibnotify_notification_show(value n) {
	if (!val_is_abstract(n) || !val_is_kind(n, k_notification))
		neko_error();
	GError *err = NULL;
	notify_notification_show(val_data(n), &err);
	//printf("%s\n",err->);
	//TODO handle error
	return val_null;
}

static value hxlibnotify_notification_set_timeout(value n, value v) {
	if (!val_is_abstract(k_notification))
		neko_error();val_check(n, int);
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

static value hxlibnotify_notification_close(value n) {
	if (!val_is_abstract(n) || !val_is_kind(n, k_notification))
		neko_error();
	GError *err = NULL;
	notify_notification_close(val_data(n), &err);
	//TODO handle error
	return val_null;
}

DEFINE_PRIM( hxlibnotify_notification_create, 5);
DEFINE_PRIM( hxlibnotify_notification_update, 4);
DEFINE_PRIM( hxlibnotify_notification_show, 1);
DEFINE_PRIM( hxlibnotify_notification_set_timeout, 2);
DEFINE_PRIM( hxlibnotify_notification_set_category, 2);
DEFINE_PRIM( hxlibnotify_notification_set_urgency, 2);
/*
 DEFINE_PRIM( hxlibnotify_set_icon_from_pixbuf, 2);
 DEFINE_PRIM( hxlibnotify_set_image_from_pixbuf, 2);
 DEFINE_PRIM( hxlibnotify_set_hint, 3);
 DEFINE_PRIM( hxlibnotify_set_hint_int32, 3);
 DEFINE_PRIM( hxlibnotify_set_hint_double, 3);
 DEFINE_PRIM( hxlibnotify_set_hint_string, 3);
 DEFINE_PRIM( hxlibnotify_set_hint_byte, 3);
 DEFINE_PRIM( hxlibnotify_set_hint_bytearray, 3);
 DEFINE_PRIM( hxlibnotify_clear_hints, 1);
 DEFINE_PRIM_MULT( hxlibnotify_add_action);
 DEFINE_PRIM( hxlibnotify_clear_actions,0);
 */
DEFINE_PRIM( hxlibnotify_notification_close, 1);
