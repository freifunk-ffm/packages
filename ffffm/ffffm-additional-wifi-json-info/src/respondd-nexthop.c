#include <json-c/json.h>

#include <respondd.h>

#include "ffffm.h"

static struct json_object *get_nexthop(void) {
	struct json_object *ret;
	char *nexthop_s;

	nexthop_s = ffffm_get_nexthop();
	if (!nexthop_s)
		return NULL;

	ret = json_object_new_string(nexthop_s);
	free(nexthop_s);
	return ret;
}

static struct json_object *respondd_provider_statistics(void) {
	struct json_object *ret = json_object_new_object();

	if (!ret)
		return NULL;

	struct json_object *nexthop;

	nexthop = get_nexthop();
	if (nexthop)
		json_object_object_add(ret, "gateway_nexthop", nexthop);

	return ret;
}

const struct respondd_provider_info respondd_providers[] = {
	{"statistics", respondd_provider_statistics},
	{0},
};
