#include "HomeDockXRootListController.h"

@implementation HomeDockXRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)respring {
	CFPreferencesSynchronize(CFSTR("pw.ssnull.homedockx"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
	system("killall SpringBoard");
#pragma GCC diagnostic pop
}

@end
