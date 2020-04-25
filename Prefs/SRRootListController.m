#include "SRRootListController.h"

@implementation SRRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"SilentRecorder" target:self] retain];
	}

	return _specifiers;
}

- (void)stopRec {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.imkpatil.stoprecording.respring"), NULL, NULL, YES);
}

// - (void)respring {
// 		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.imkpatil.silentrecorder.respring"), NULL, NULL, YES);
// }

@end
