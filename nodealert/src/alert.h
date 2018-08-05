#pragma once
#include <json-c/json.h>

struct json_object *alertme(void);

#define DEBUG { printf("Reached %s:%d\n", __FILE__, __LINE__); fflush(NULL); }
