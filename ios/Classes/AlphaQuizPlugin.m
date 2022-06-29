#import "AlphaQuizPlugin.h"
#if __has_include(<alpha_quiz/alpha_quiz-Swift.h>)
#import <alpha_quiz/alpha_quiz-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "alpha_quiz-Swift.h"
#endif

@implementation AlphaQuizPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAlphaQuizPlugin registerWithRegistrar:registrar];
}
@end
