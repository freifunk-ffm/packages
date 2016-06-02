#define _GNU_SOURCE

#include <sys/socket.h>
#include <linux/nl80211.h>
#include <netlink/netlink.h>
#include <netlink/genl/genl.h>
#include <netlink/genl/ctrl.h>
#include <net/if.h>

#include "ffffm.h"

const double FFFFM_INVALID_AIRTIME = -1;

static const char const *wifi_24_dev = "client0";
static const char const *wifi_50_dev = "client1";

struct airtime_result {
        uint32_t frequency;
        uint64_t active_time;
        uint64_t busy_time;
};

static int survey_airtime_handler(struct nl_msg *msg, void *arg)
{
	struct genlmsghdr *gnlh;
        struct airtime_result *result;

	struct nlattr *tb[NL80211_ATTR_MAX + 1];
	struct nlattr *sinfo[NL80211_SURVEY_INFO_MAX + 1];
	static struct nla_policy survey_policy[NL80211_SURVEY_INFO_MAX + 1] = {
		[NL80211_SURVEY_INFO_FREQUENCY] = { .type = NLA_U32 },
	};

        result = (struct airtime_result *) arg;

        /* another callback was already successful */
        if (result->frequency)
                return NL_SKIP;

	gnlh = nlmsg_data(nlmsg_hdr(msg));
        if (!gnlh)
                goto error;

	nla_parse(tb, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
		  genlmsg_attrlen(gnlh, 0), NULL);

	if (!tb[NL80211_ATTR_SURVEY_INFO])
                goto abort;

	if (nla_parse_nested(sinfo, NL80211_SURVEY_INFO_MAX,
			     tb[NL80211_ATTR_SURVEY_INFO],
			     survey_policy))
                goto abort;

	if (!sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME]) 
                goto abort;
	if (!sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_BUSY])
                goto abort;
	if (!sinfo[NL80211_SURVEY_INFO_FREQUENCY])
                goto abort;

        result->frequency = (uint32_t)nla_get_u32(sinfo[NL80211_SURVEY_INFO_FREQUENCY]),
        result->active_time = (uint64_t)nla_get_u64(sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME]);
        result->busy_time = (uint64_t)nla_get_u64(sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_BUSY]);

error:
abort:
        return NL_SKIP;
}

static double get_airtime_for_interface(const char *interface) {
        double ret = FFFFM_INVALID_AIRTIME;
        int ctrl, ifx, flags;
        struct nl_sock *sk = NULL;
        struct nl_msg *msg = NULL;
        enum nl80211_commands cmd;
        struct airtime_result *result = NULL;

#define CHECK(x) { if (!(x)) { printf("error on line %d\n",  __LINE__); goto error; } }

        CHECK(sk = nl_socket_alloc());
        CHECK(genl_connect(sk) >= 0);

        CHECK(ctrl = genl_ctrl_resolve(sk, NL80211_GENL_NAME));
        CHECK(result = calloc(1, sizeof(*result)));
        CHECK(nl_socket_modify_cb(
                sk, NL_CB_VALID, NL_CB_CUSTOM, survey_airtime_handler, result) == 0);
        CHECK(msg = nlmsg_alloc());

        /* device does not exist */
        if (!(ifx = if_nametoindex(interface)))
                goto error;

        cmd = NL80211_CMD_GET_SURVEY;
        flags = 0;
        flags |= NLM_F_DUMP;

        /* TODO: check return? */
        genlmsg_put(msg, 0, 0, ctrl, 0, flags, cmd, 0);

        NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, ifx);

        CHECK(nl_send_auto_complete(sk, msg) >= 0);
        CHECK(nl_recvmsgs_default(sk) >= 0);

	ret = ((double) result->busy_time) / result->active_time;

#undef CHECK

out:
    if (msg)
            nlmsg_free(msg);
    msg = NULL;

    if (sk)
            nl_socket_free(sk);
    sk = NULL;

    if (result)
            free(result);
    result = NULL;

    return ret;

nla_put_failure:
error:
    ret = FFFFM_INVALID_AIRTIME;
    goto out;
}

struct ffffm_airtime *ffffm_get_airtime(void) {
	struct ffffm_airtime *ret = calloc(1, sizeof(*ret));
        if (!ret)
                return NULL;

        ret->a24 = get_airtime_for_interface(wifi_24_dev);
        ret->a50 = get_airtime_for_interface(wifi_50_dev);
        
        return ret;
}
