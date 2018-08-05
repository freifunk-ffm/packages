#include <json-c/json.h>

#include <respondd.h>

#include "alert.h"
const struct respondd_provider_info respondd_providers[] = {
	{"nodeinfo", alertme},
	{0},
};
