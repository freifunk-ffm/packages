#include <json-c/json.h>
#include <respondd.h>
#include <uci.h>
#include <string.h>

#include "alert.h"

// this function is available in gluon-node-info too.
struct uci_section * get_first_section(struct uci_package *p, const char *type) {
	struct uci_element *e;
	uci_foreach_element(&p->sections, e) {
		struct uci_section *s = uci_to_section(e);
		if (!strcmp(s->type, type))
			return s;
	}

	return NULL;
}

// this function is available in gluon-node-info too.
const char * get_first_option(struct uci_context *ctx, struct uci_package *p, const char *type, const char *option) {
	struct uci_section *s = get_first_section(p, type);
	if (s)
		return uci_lookup_option_string(ctx, s, option);
	else
		return NULL;
}

long get_uci_nodealert(struct uci_context *ctx, struct uci_package *p) {
	const char *val  = get_first_option(ctx, p, "owner", "downtime_notification");
	if (!val || !*val)
		return -1;

	char *end;
	long i = strtol(val, &end, 10);
	if (*end)
		return -1;

	return i;
}

int get_nodealert(void) {
	const char *c = NULL;
	struct uci_context *ctx = NULL;
	struct uci_package *p = NULL;
	int zero_if_active_is_true = -2;

	ctx = uci_alloc_context();
	if (!ctx)
		goto end;
	ctx->flags &= ~UCI_FLAG_STRICT;

	if (uci_load(ctx, "gluon-node-info", &p))
		goto error;

	long i = get_uci_nodealert(ctx, p);
error:
	uci_free_context(ctx);
end:
	return i;
}

struct json_object *alertme(void) {
	struct json_object *ret = json_object_new_object();
	if (!ret)
		return NULL;

	int nodealert_downtime = get_nodealert();
	if (nodealert_downtime < 0 )
		return ret;


	struct json_object *nodealert = json_object_new_int(nodealert_downtime );

	if (!nodealert)
		return ret;

	json_object_object_add(ret, "downtime_notification", nodealert);

	return ret;
}

