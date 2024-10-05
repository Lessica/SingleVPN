#import <HBLog.h>

#import "Common.h"

#define IsNetworkTypeText(text) ( \
    [text isEqualToString:@"G"] || [text isEqualToString:@"3G"] || \
    [text isEqualToString:@"4G"] || [text isEqualToString:@"5G"] || \
    [text isEqualToString:@"LTE"])

static BOOL _isVPNEnabled = NO;

static UIColor *smColorWithTextColor(UIColor *textColor) {
    CGFloat red, green, blue, alpha;
    [textColor getRed:&red green:&green blue:&blue alpha:&alpha];

    BOOL isKindOfBlack = red < 0.5 && green < 0.5 && blue < 0.5;

    // rgba(50, 199, 89, 1.0)
    // rgba(44, 208, 87, 1.0)
    return isKindOfBlack
        ? [UIColor colorWithRed:0.19607843137254902 green:0.7803921568627451 blue:0.34901960784313724 alpha:1]
        : [UIColor colorWithRed:0.17254901960784313 green:0.8156862745098039 blue:0.3411764705882353 alpha:1];
}

%hook _UIStatusBarWifiItem

%property (nonatomic, strong) NSNumber *smIsVPNEnabled;

- (id)applyUpdate:(_UIStatusBarItemUpdate *)update toDisplayItem:(_UIStatusBarDisplayItem *)displayItem {
    _isVPNEnabled = update.data.vpnEntry.enabled;

    id result = %orig;
    if ([self.smIsVPNEnabled boolValue] != _isVPNEnabled) {
        self.smIsVPNEnabled = @(_isVPNEnabled);
        for (_UIStatusBarDisplayItem *item in self.displayItems.allValues) {
            %orig(update, item);
        }
    }

    return result;
}

- (UIColor *)_fillColorForUpdate:(_UIStatusBarItemUpdate *)update entry:(_UIStatusBarDataWifiEntry *)entry {
    if (!_isVPNEnabled) {
        return %orig;
    }

    return smColorWithTextColor(update.styleAttributes.textColor);
}

%end

%hook _UIStatusBarCellularItem

- (id)applyUpdate:(_UIStatusBarItemUpdate *)update toDisplayItem:(_UIStatusBarDisplayItem *)displayItem {
    _isVPNEnabled = update.data.vpnEntry.enabled;

    id result = %orig;

    UIColor *originalColor = update.styleAttributes.textColor;
    UIColor *newColor = nil;

    if (_isVPNEnabled) {
        newColor = smColorWithTextColor(originalColor);
    }

    if (!newColor) {
        newColor = originalColor;
    }

    for (_UIStatusBarDisplayItem *item in self.displayItems.allValues) {
        _UIStatusBarStringView *stringView = nil;

        if ([item.view isKindOfClass:%c(_UIStatusBarCellularNetworkTypeView)]) {
            stringView = ((_UIStatusBarCellularNetworkTypeView *)item.view).stringView;
        } else if ([item.view isKindOfClass:%c(_UIStatusBarStringView)]) {
            stringView = (_UIStatusBarStringView *)item.view;
        }

        if (IsNetworkTypeText(stringView.text)) {
            [stringView setTextColor:newColor];
        } else {
            [stringView setTextColor:originalColor];
        }
    }

    return result;
}

%end


%hook _UIStatusBarStringView

- (void)applyStyleAttributes:(_UIStatusBarStyleAttributes *)styleAttrs {
    %orig;

    if (_isVPNEnabled && IsNetworkTypeText(self.text)) {
        [self setTextColor:smColorWithTextColor(styleAttrs.textColor)];
    }
}

%end