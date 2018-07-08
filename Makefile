include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HomeDockX
HomeDockX_FILES = src/FloatingDock.xm src/HomeGesture.xm src/KeyboardStateListener.m

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

SUBPROJECTS += prefsbundle
include $(THEOS_MAKE_PATH)/aggregate.mk
