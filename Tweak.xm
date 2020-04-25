#import <substrate.h>

@interface RPScreenRecorder : NSObject
  +(id)sharedRecorder;
  -(BOOL)systemRecording;
  -(void)setSystemRecording:(BOOL)arg1;
  -(BOOL)isRecording;
  -(void)setRecording:(BOOL)arg1 ;
  -(void)stopRecordingWithHandler:(/*^block*/id)arg1;
  -(void)stopSystemRecording:(/*^block*/id)arg1;
  -(void)stopRecordingAndSaveToCameraRoll:(/*^block*/id)arg1;
@end

@interface RPControlCenterClient
  + (id)sharedInstance;
  -(void)setRecordingOn;
  @property(nonatomic) _Bool recordingOn;
@end

@interface CCUIButtonModuleView
  @property (nonatomic,copy) NSString * glyphState;
  -(void)setGlyphState:(NSString *)arg1;
  -(void)setHighlighted:(BOOL)arg1;
  -(void)setEnabled:(BOOL)arg1;
  -(void)setSelected:(BOOL)arg1;
  -(void)_updateForStateChange;
@end

@interface CCUIContentModuleContainerView : UIView
@end

static BOOL isRecHideEnabled = YES;
static BOOL isAudioRecHideEnabled = YES;
static BOOL isCallHideEnabled = YES;
static BOOL isLocHideEnabled = YES;
static BOOL isHotspotHideEnabled = YES;
static BOOL isCCIconDisabled = YES;

%hook SBSStatusBarStyleOverridesAssertionData

-(id)initWithStatusBarStyleOverrides:(int)arg1 forPID:(int)arg2 exclusive:(BOOL)arg3 showsWhenForeground:(BOOL)arg4 uniqueIdentifier:(id)arg5
{
  // NSString *Msg = [NSString stringWithFormat:@"arg1 %d",arg1];
  // UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"initWithStatusBarStyleOverrides"
  //                              message:Msg
  //                              preferredStyle:UIAlertControllerStyleAlert];
  // UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
  //  handler:^(UIAlertAction * action) {}];
  //
  //  [alert addAction:defaultAction];
  // [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alert animated:YES completion:nil];

  if (isRecHideEnabled && arg1 == 1048576)
  {
    arg1 = 0;
  }

  if (isCallHideEnabled && arg1 == 1)
  {
    arg1 = 0;
  }

  if (isLocHideEnabled && arg1 == 2048)
  {
    arg1 = 0;
  }

  if (isAudioRecHideEnabled && arg1 == 4)
  {
    arg1 = 0;
  }

  if (isRecHideEnabled && arg1 == 1048576)
  {
    arg1 = 0;
  }

  if (isHotspotHideEnabled && arg1 == 8)
  {
    arg1 = 0;
  }

  //%log;
  return %orig(arg1,arg2,arg3,arg4,arg5);
}

-(id)initWithStatusBarStyleOverrides:(int)arg1 forPID:(int)arg2 exclusive:(BOOL)arg3 showsWhenForeground:(BOOL)arg4
{
  // NSString *Msg = [NSString stringWithFormat:@"arg1 %d",arg1];
  // UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"initWithStatusBarStyleOverrides 2"
  //                              message:Msg
  //                              preferredStyle:UIAlertControllerStyleAlert];
  // UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
  //  handler:^(UIAlertAction * action) {}];
  //
  //  [alert addAction:defaultAction];
  // [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alert animated:YES completion:nil];

  if (isRecHideEnabled && arg1 == 1048576)
  {
    arg1 = 0;
  }

  if (isCallHideEnabled && arg1 == 1)
  {
    arg1 = 0;
  }

  if (isLocHideEnabled && arg1 == 2048)
  {
    arg1 = 0;
  }

  if (isAudioRecHideEnabled && arg1 == 4)
  {
    arg1 = 0;
  }

  if (isRecHideEnabled && arg1 == 1048576)
  {
    arg1 = 0;
  }

  if (isHotspotHideEnabled && arg1 == 8)
  {
    arg1 = 0;
  }

  //%log;
  //NSLog(@"[SilentRecorder] - initWithStatusBarStyleOverrides arg1 - %d ", arg1);
  return %orig(arg1,arg2,arg3,arg4);
}

%end

%hook RPControlCenterClient

  - (void)setRecordingOn:(BOOL)arg1
  {
    %orig(NO);
  }

  - (BOOL)recordingOn
  {
    return NO;
  }
%end

%hook CCUIContentModuleContainerView
  -(NSString *)moduleIdentifier
  {
    NSString *Tmp = %orig;
    if (isCCIconDisabled)
    {
      if ([Tmp isEqualToString:@"com.apple.replaykit.controlcenter.screencapture"])
      {
        if ([[%c(RPScreenRecorder) sharedRecorder] isRecording])
        {
          self.hidden = YES;
        }
        else
        {
          self.hidden = NO;
        }
      }
    }
    else
    {
      self.hidden = NO;
    }

    return Tmp;
  }
%end

%hook CCUIButtonModuleView

  -(void)layoutSubviews
  {
    if (isCCIconDisabled)
    {
      if ([self.glyphState isEqualToString:@"recording"])
      {
        [self setEnabled:NO];
        [self setHighlighted:NO];
        [self setSelected:NO];
        [self setGlyphState:@"Base State"];
      }
    }
    %orig;
  }

  -(NSString *)glyphState
  {
    NSString* Tmp = %orig;
    if (isCCIconDisabled)
    {
      if ([Tmp isEqualToString:@"recording"])
      {
        Tmp = @"Base State";
      }
    }

    return Tmp;
  }

  -(void)setGlyphState:(NSString *)arg1
  {
    if (isCCIconDisabled)
    {
      if ([self.glyphState isEqualToString:@"recording"])
      {
        arg1 = @"Base State";
      }
    }

    %orig(arg1);
  }

  -(void)setHighlighted:(BOOL)arg1
  {
    if (isCCIconDisabled)
    {
      if ([self.glyphState isEqualToString:@"recording"] || [self.glyphState isEqualToString:@"Base State"])
      {
        arg1 = NO;
      }
    }

    %orig(arg1);
  }

  -(void)setEnabled:(BOOL)arg1
  {
    if (isCCIconDisabled)
    {
      if ([self.glyphState isEqualToString:@"recording"] || [self.glyphState isEqualToString:@"Base State"])
      {
        arg1 = NO;
      }
    }

    %orig(arg1);
  }

  -(void)setSelected:(BOOL)arg1
  {
    if (isCCIconDisabled)
    {
      if ([self.glyphState isEqualToString:@"recording"] || [self.glyphState isEqualToString:@"Base State"])
      {
        arg1 = NO;
      }
    }

    %orig(arg1);
  }

%end

static void reloadSettings() {
  static CFStringRef SRForcedAudioPrefsKey = CFSTR("com.imkpatil.silentrecorder");
  CFPreferencesAppSynchronize(SRForcedAudioPrefsKey);

  if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"RecHideEnabled", SRForcedAudioPrefsKey))) {
    isRecHideEnabled = [(id)CFPreferencesCopyAppValue((CFStringRef)@"RecHideEnabled", SRForcedAudioPrefsKey) boolValue];
  }

  if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"AudRecHideEnabled", SRForcedAudioPrefsKey))) {
    isAudioRecHideEnabled = [(id)CFPreferencesCopyAppValue((CFStringRef)@"AudRecHideEnabled", SRForcedAudioPrefsKey) boolValue];
  }

  if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"LocHideEnabled", SRForcedAudioPrefsKey))) {
    isLocHideEnabled = [(id)CFPreferencesCopyAppValue((CFStringRef)@"LocHideEnabled", SRForcedAudioPrefsKey) boolValue];
  }

  if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"CallHideEnabled", SRForcedAudioPrefsKey))) {
    isCallHideEnabled = [(id)CFPreferencesCopyAppValue((CFStringRef)@"CallHideEnabled", SRForcedAudioPrefsKey) boolValue];
  }

  if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"HotspotHideEnabled", SRForcedAudioPrefsKey))) {
    isHotspotHideEnabled = [(id)CFPreferencesCopyAppValue((CFStringRef)@"HotspotHideEnabled", SRForcedAudioPrefsKey) boolValue];
  }

  if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"ccIconHidden", SRForcedAudioPrefsKey))) {
    isCCIconDisabled = [(id)CFPreferencesCopyAppValue((CFStringRef)@"ccIconHidden", SRForcedAudioPrefsKey) boolValue];
  }

  // if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"RecIconDisable", SRForcedAudioPrefsKey))) {
  //   shouldDisableIcon = [(id)CFPreferencesCopyAppValue((CFStringRef)@"RecIconDisable", SRForcedAudioPrefsKey) boolValue];
  // }

}

static void stopRecording(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  //SBAwayDateView* dateView = MSHookIvar<SBAwayDateView*>(self, "_dateHeaderView")
  //[[[%c(RPControlCenterModuleViewController) alloc] init] setSelectedState:NO];
  //[%c("RPControlCenterModuleViewController") recordButtonDidEndTap];

  [[%c(RPScreenRecorder) sharedRecorder] stopSystemRecording:nil];
  [[%c(RPScreenRecorder) sharedRecorder] setRecording:NO];
  [[%c(RPControlCenterClient) sharedInstance] setRecordingOn:NO];
  //MSHookIvar<_Bool>([%c(RPControlCenterClient) sharedInstance], "recordingOn") = NO;

}

%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadSettings, CFSTR("com.imkpatil.silentrecorder.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, stopRecording, CFSTR("com.imkpatil.stoprecording.respring"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  //CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, respring, CFSTR("com.imkpatil.silentrecorder.respring"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  reloadSettings();
}

// NSString *Msg = [NSString stringWithFormat:@"arg1 %d",arg1];
// UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"initWithStatusBarStyleOverrides 2"
//                              message:Msg
//                              preferredStyle:UIAlertControllerStyleAlert];
// UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//  handler:^(UIAlertAction * action) {}];
//
//  [alert addAction:defaultAction];
// // UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"initWithStatusBarStyleOverrides" message:Msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
// // [alertView show];
// // [alertView release];
// [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alert animated:YES completion:nil];
// //NSLog(@"[SilentRecorder] - initWithStatusBarStyleOverrides arg1 - %d", arg1);

// if (arg1 == 10 && isEnabled)
// {
//   arg1 = 0;
//   arg3 = FALSE;
//   arg4 = FALSE;
// }
