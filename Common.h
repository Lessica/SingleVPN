@import UIKit;

@interface _UIStatusBarDataEntry : NSObject
@property(assign, getter=isEnabled, nonatomic) BOOL enabled;
@end

@interface _UIStatusBarDataQuietModeEntry : NSObject
@property(nonatomic, copy) NSString *focusName;
@end

@interface _UIStatusBarDataWifiEntry : NSObject
@end

@interface _UIStatusBarData : NSObject
@property(nonatomic, copy) _UIStatusBarDataQuietModeEntry *quietModeEntry;
@property(nonatomic, copy) _UIStatusBarDataEntry *vpnEntry;
@property(nonatomic, copy) _UIStatusBarDataWifiEntry *wifiEntry;
@end

@interface UIStatusBar_Base : UIView
- (void)forceUpdateData:(BOOL)arg1;
@end

@interface _UIStatusBarImageView : UIImageView
@end

@interface _UIStatusBarStringView : UILabel
@end

@interface _UIStatusBarCellularNetworkTypeView : UIView
@property(nonatomic, strong) _UIStatusBarStringView *stringView;
@end

@interface _UIStatusBarSignalView : UIView
@property(nonatomic, copy) UIColor *inactiveColor;
@property(nonatomic, copy) UIColor *activeColor;
- (void)_colorsDidChange;
@end

@interface _UIStatusBarWifiSignalView : _UIStatusBarSignalView
@end

@interface _UIStatusBarStyleAttributes : NSObject
@property(nonatomic, readonly) long long style;
@property(nonatomic, copy) UIColor *textColor;
@end

@interface _UIStatusBarItemUpdate : NSObject
@property(nonatomic, strong) _UIStatusBarData *data;
@property(nonatomic, strong) _UIStatusBarStyleAttributes *styleAttributes;
@property(assign, nonatomic) BOOL styleAttributesChanged;
@end

@interface _UIStatusBarItem : NSObject
@property(nonatomic, strong) NSMutableDictionary *displayItems;
@end

@interface _UIStatusBarWifiItem : _UIStatusBarItem
@property(nonatomic, strong) NSNumber *smIsVPNEnabled;
- (UIColor *)_fillColorForUpdate:(_UIStatusBarItemUpdate *)update entry:(_UIStatusBarDataWifiEntry *)entry;
@end

@interface _UIStatusBarCellularItem : _UIStatusBarItem
@end

@interface _UIStatusBarDisplayItem : NSObject
@property(nonatomic, readonly) UIView *view;
@end