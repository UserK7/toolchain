cmd_/share/rlx/asdk-5.4.1-a53-EL-4.4-g2.23-a64nut-170801//sump/include/drm/.install := /bin/sh scripts/headers_install.sh /share/rlx/asdk-5.4.1-a53-EL-4.4-g2.23-a64nut-170801//sump/include/drm ./include/uapi/drm drm.h drm_fourcc.h drm_mode.h drm_sarea.h exynos_drm.h i810_drm.h i915_drm.h mga_drm.h msm_drm.h nouveau_drm.h qxl_drm.h r128_drm.h radeon_drm.h savage_drm.h sis_drm.h tegra_drm.h via_drm.h virtgpu_drm.h vmwgfx_drm.h; /bin/sh scripts/headers_install.sh /share/rlx/asdk-5.4.1-a53-EL-4.4-g2.23-a64nut-170801//sump/include/drm ./include/drm ; /bin/sh scripts/headers_install.sh /share/rlx/asdk-5.4.1-a53-EL-4.4-g2.23-a64nut-170801//sump/include/drm ./include/generated/uapi/drm ; for F in ; do echo "\#include <asm-generic/$$F>" > /share/rlx/asdk-5.4.1-a53-EL-4.4-g2.23-a64nut-170801//sump/include/drm/$$F; done; touch /share/rlx/asdk-5.4.1-a53-EL-4.4-g2.23-a64nut-170801//sump/include/drm/.install