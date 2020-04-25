include $(THEOS)/makefiles/common.mk

export ARCHS = arm64 arm64e
export TARGET = iphone:clang:12.1.2:12.0

TWEAK_NAME = SilentRecorder
SilentRecorder_FILES = Tweak.xm
SilentRecorder_FRAMEWORKS = ReplayKit
SilentRecorder_PRIVATE_FRAMEWORKS = SpringBoardServices

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += Prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
