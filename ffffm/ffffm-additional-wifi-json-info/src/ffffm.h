#pragma once

extern const unsigned int FFFFM_INVALID_CHANNEL;
extern const unsigned int FFFFM_INVALID_TXPOWER;
extern const double FFFFM_INVALID_AIRTIME;

struct ffffm_wifi_info {
	unsigned char c24;
	unsigned char c50;
	unsigned char t24;
	unsigned char t50;
};

struct ffffm_airtime {
	double a24;
	double a50;
};

char *ffffm_get_nexthop(void);
struct ffffm_wifi_info *ffffm_get_wifi_info(void);
struct ffffm_airtime *ffffm_get_airtime(void);

#define DEBUG { printf("Reached %s:%d\n", __FILE__, __LINE__); fflush(NULL); }
