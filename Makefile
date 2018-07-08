export ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HomeDockX
HomeDockX_FILES = src/Dock.xm src/HomeGesture.xm src/Medusa.xm src/KeyboardStateListener.m src/HomeDockXPreference.m

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

SUBPROJECTS += prefsbundle
include $(THEOS_MAKE_PATH)/aggregate.mk
