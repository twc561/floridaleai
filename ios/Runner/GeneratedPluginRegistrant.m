//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<firebase_app_check/FLTFirebaseAppCheckPlugin.h>)
#import <firebase_app_check/FLTFirebaseAppCheckPlugin.h>
#else
@import firebase_app_check;
#endif

#if __has_include(<firebase_auth/FLTFirebaseAuthPlugin.h>)
#import <firebase_auth/FLTFirebaseAuthPlugin.h>
#else
@import firebase_auth;
#endif

#if __has_include(<firebase_core/FLTFirebaseCorePlugin.h>)
#import <firebase_core/FLTFirebaseCorePlugin.h>
#else
@import firebase_core;
#endif

#if __has_include(<firebase_performance/FLTFirebasePerformancePlugin.h>)
#import <firebase_performance/FLTFirebasePerformancePlugin.h>
#else
@import firebase_performance;
#endif

#if __has_include(<flutter_tts/FlutterTtsPlugin.h>)
#import <flutter_tts/FlutterTtsPlugin.h>
#else
@import flutter_tts;
#endif

#if __has_include(<haptic_feedback/HapticFeedbackPlugin.h>)
#import <haptic_feedback/HapticFeedbackPlugin.h>
#else
@import haptic_feedback;
#endif

#if __has_include(<path_provider_foundation/PathProviderPlugin.h>)
#import <path_provider_foundation/PathProviderPlugin.h>
#else
@import path_provider_foundation;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FLTFirebaseAppCheckPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseAppCheckPlugin"]];
  [FLTFirebaseAuthPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseAuthPlugin"]];
  [FLTFirebaseCorePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseCorePlugin"]];
  [FLTFirebasePerformancePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebasePerformancePlugin"]];
  [FlutterTtsPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterTtsPlugin"]];
  [HapticFeedbackPlugin registerWithRegistrar:[registry registrarForPlugin:@"HapticFeedbackPlugin"]];
  [PathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"PathProviderPlugin"]];
}

@end
