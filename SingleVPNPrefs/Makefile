ifeq ($(THEOS_DEVICE_SIMULATOR),1)
TARGET := simulator:clang:latest:14.0
INSTALL_TARGET_PROCESSES := Preferences
ARCHS := arm64 x86_64
else
TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES := Preferences
ARCHS := arm64 arm64e
endif

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME := SingleVPNPrefs

SingleVPNPrefs_FILES += SingleVPNRootListController.m
SingleVPNPrefs_FILES += SingleVPNColorCell.m
SingleVPNPrefs_CFLAGS += -fobjc-arc

ifeq ($(THEOS_DEVICE_SIMULATOR),1)
SingleVPNPrefs_LDFLAGS += -FFrameworks/_Simulator
SingleVPNPrefs_LDFLAGS += -rpath /opt/simject
else
SingleVPNPrefs_LDFLAGS += -FFrameworks
endif

SingleVPNPrefs_FRAMEWORKS += UIKit
SingleVPNPrefs_PRIVATE_FRAMEWORKS += Preferences
SingleVPNPrefs_INSTALL_PATH += /Library/PreferenceBundles

include $(THEOS_MAKE_PATH)/bundle.mk