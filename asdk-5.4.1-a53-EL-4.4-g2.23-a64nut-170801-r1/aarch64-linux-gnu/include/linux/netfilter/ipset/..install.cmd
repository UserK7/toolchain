cmd_/share/rlx/asdk-5.4.1-a53-EL-4.4-g2.23-a64nut-170801//sump/include/linux/netfilter/ipset/.install := /bin/sh scripts/headers_install.sh /share/rlx/asdk-5.4.1-a53-EL-4.4-g2.23-a64nut-170801//sump/include/linux/netfilter/ipset ./include/uapi/linux/netfilter/ipset ip_set.h ip_set_bitmap.h ip_set_hash.h ip_set_list.h; /bin/sh scripts/headers_install.sh /share/rlx/asdk-5.4.1-a53-EL-4.4-g2.23-a64nut-170801//sump/include/linux/netfilter/ipset ./include/linux/netfilter/ipset ; /bin/sh scripts/headers_install.sh /share/rlx/asdk-5.4.1-a53-EL-4.4-g2.23-a64nut-170801//sump/include/linux/netfilter/ipset ./include/generated/uapi/linux/netfilter/ipset ; for F in ; do echo "\#include <asm-generic/$$F>" > /share/rlx/asdk-5.4.1-a53-EL-4.4-g2.23-a64nut-170801//sump/include/linux/netfilter/ipset/$$F; done; touch /share/rlx/asdk-5.4.1-a53-EL-4.4-g2.23-a64nut-170801//sump/include/linux/netfilter/ipset/.install