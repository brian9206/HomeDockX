#include "HomeDockXRootListController.h"

@implementation HomeDockXRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)respring {
	system("sleep 2 && killall SpringBoard");
}

@end
