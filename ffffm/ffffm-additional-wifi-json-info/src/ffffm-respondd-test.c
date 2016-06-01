#include <stdio.h>
#include <string.h>
#include <dlfcn.h>

#include <json-c/json.h>
#include <respondd.h>

extern const struct respondd_provider_info respondd_providers[];

static const struct respondd_provider_info * get_providers(const char *filename) {
	if (!filename)
		return NULL;

	void *handle = dlopen(filename, RTLD_NOW|RTLD_LOCAL);
	if (!handle)
		return NULL;

	const struct respondd_provider_info *ret = dlsym(handle, "respondd_providers");
	if (!ret) {
		dlclose(handle);
		return NULL;
	}

	return ret;
}

int main(int argc, char **argv) {
	if (argc < 2)
		return 3;

	const struct respondd_provider_info *providers = get_providers(argv[1]);
	if (!providers) {
		return 4;
	}
	for (; providers->request; providers++) {
		printf("%s:\n", providers->request);
		struct json_object *s = providers->provider();
		if (s)
			printf("%s\n", json_object_to_json_string_ext(s, JSON_C_TO_STRING_PRETTY));
	}
}
