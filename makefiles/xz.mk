ifneq ($(PROCURSUS),1)
$(error Use the main Makefile)
endif

STRAPPROJECTS += xz
XZ_VERSION    := 5.2.5

xz-setup: setup
	wget -q -nc -P $(BUILD_SOURCE) https://tukaani.org/xz/xz-$(XZ_VERSION).tar.xz{,.sig}
	$(call PGP_VERIFY,xz-$(XZ_VERSION).tar.xz)
	$(call EXTRACT_TAR,xz-$(XZ_VERSION).tar.xz,xz-$(XZ_VERSION),xz)

ifneq ($(wildcard $(BUILD_WORK)/xz/.build_complete),)
xz:
	@echo "Using previously built xz."
else
xz: xz-setup
	cd $(BUILD_WORK)/xz && ./configure -C \
		$(DEFAULT_CONFIGURE_FLAGS) \
		--disable-shared \
		--disable-static \
		--disable-nls \
		--disable-encoders \
		--enable-small \
		--disable-threads \
		--disable-liblzma2-compat \
		--disable-lzmainfo \
		--disable-scripts \
		--disable-lzma-links
	+$(MAKE) -C $(BUILD_WORK)/xz install \
		DESTDIR=$(BUILD_STAGE)/xz
	$(call AFTER_BUILD,copy)
	$(call BINPACK_SIGN,general.xml)
endif

.PHONY: xz
