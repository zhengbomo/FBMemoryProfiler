THEOS_DEVICE_IP = 10.10.10.3
THEOS_DEVICE_PORT = 22

TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FBMemoryProfile

FBMemoryProfile_FRAMEWORKS = Foundation UIKit CoreGraphics QuartzCore ImageIO WebKit Security SceneKit 
FBMemoryProfile_LDFLAGS = -lz -lsqlite3 

FBMemoryProfile_FILES = Tweak.xm
FBMemoryProfile_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

before-package::
	@echo "run FBMemoryProfile build script..."
	./pack.sh

after-install::
	install.exec "killall -9 SpringBoard"
