include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = HomeDockXPrefs
HomeDockXPrefs_FILES = HomeDockXRootListController.m
HomeDockXPrefs_INSTALL_PATH = /Library/PreferenceBundles
HomeDockXPrefs_FRAMEWORKS = UIKit
HomeDockXPrefs_PRIVATE_FRAMEWORKS = Preferences
BetterMedusaPreference_LIBRARIES = applist

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/HomeDockXPrefs.plist$(ECHO_END)
