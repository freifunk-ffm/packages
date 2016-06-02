#define _GNU_SOURCE

#include <stdlib.h>
#include <limits.h>

#include <uci.h>

#include "ffffm.h"

const unsigned int FFFFM_INVALID_CHANNEL = 0;
const unsigned int FFFFM_INVALID_TXPOWER = 0;

static const char const *wifi_24_dev = "radio0";
static const char const *wifi_50_dev = "radio1";

static inline const char *lookup_option_value(
		struct uci_context *ctx, struct uci_package *p,
		const char *section_name, const char *option_name) {

	struct uci_section *s = uci_lookup_section(ctx, p, section_name);
	if (!s)
		return NULL;
	return uci_lookup_option_string(ctx, s, option_name);
}

static inline unsigned char parse_option(const char *s, unsigned char invalid) {
	char *endptr = NULL;
	long int result;

        if (!s)
		return invalid;

        result = strtol(s, &endptr, 10);

        if (!endptr)
		return invalid;
	if ('\0' != *endptr)
		return invalid;
	if (result > UCHAR_MAX)
		return invalid;
	if (result < 0)
		return invalid;
	
	return (unsigned char)(result % UCHAR_MAX);
}

static inline unsigned char parse_channel(const char *s) {
        return parse_option(s, FFFFM_INVALID_CHANNEL);
}

static inline unsigned char parse_txpower(const char *s) {
        return parse_option(s, FFFFM_INVALID_TXPOWER);
}

struct ffffm_wifi_info *ffffm_get_wifi_info(void) {
	struct uci_package *p = NULL;
	struct uci_context *ctx = NULL;
	struct ffffm_wifi_info *ret = NULL;

	ctx = uci_alloc_context();
        if (!ctx)
                goto error;
	ctx->flags &= ~UCI_FLAG_STRICT;

	ret = calloc(1, sizeof(*ret));
	if (!ret)
		goto error;

	if (uci_load(ctx, "wireless", &p))
		goto error;


	ret->c24 = parse_channel(lookup_option_value(ctx, p, wifi_24_dev, "channel"));
	ret->c50 = parse_channel(lookup_option_value(ctx, p, wifi_50_dev, "channel"));
	ret->t24 = parse_txpower(lookup_option_value(ctx, p, wifi_24_dev, "txpower"));
	ret->t50 = parse_txpower(lookup_option_value(ctx, p, wifi_50_dev, "txpower"));
end:
        if (ctx) {
                if (p)
                        uci_unload(ctx, p);
                uci_free_context(ctx);
        }
	return ret;
error:
        if(ret)
                free(ret);
	ret = NULL;
	goto end;
}
