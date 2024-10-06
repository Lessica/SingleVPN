#import <Preferences/PSSpecifier.h>
#import <UIKit/UIKit.h>

#import "SingleVPNColorCell.h"

@interface PSTableCell (Private)
- (void)setValue:(id)value;
@end

@implementation SingleVPNColorCell {
    UIColorWell *_colorWell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                    specifier:(PSSpecifier *)specifier {

    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier specifier:specifier];

    if (self) {
        _colorWell = [[UIColorWell alloc] initWithFrame:CGRectZero];

        [_colorWell setSupportsAlpha:NO];
        [_colorWell addTarget:self action:@selector(colorChanged:) forControlEvents:UIControlEventValueChanged];

        [self addSubview:_colorWell];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _colorWell.frame = CGRectMake(CGRectGetWidth(self.frame) - 52, CGRectGetHeight(self.frame) / 2 - 16, 32, 32);
}

- (void)colorChanged:(UIColorWell *)sender {
    UIColor *color = sender.selectedColor;

    CGFloat red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:NULL];

    unsigned int hexValue = ((int)(red * 255) << 16) + ((int)(green * 255) << 8) + (int)(blue * 255);
    NSString *hexString = [NSString stringWithFormat:@"#%06X", hexValue];

    [self.specifier performSetterWithValue:hexString];
}

- (void)setValue:(id)value {
    [super setValue:value];

    NSString *hexString = value;
    if (![value isKindOfClass:[NSString class]]) {
        return;
    }

    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    if ([hexString hasPrefix:@"#"]) {
        [scanner setScanLocation:1];
    }

    unsigned int hexValue;
    if (![scanner scanHexInt:&hexValue]) {
        return;
    }

    CGFloat red = ((hexValue & 0xFF0000) >> 16) / 255.0;
    CGFloat green = ((hexValue & 0x00FF00) >> 8) / 255.0;
    CGFloat blue = (hexValue & 0x0000FF) / 255.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1];

    [_colorWell setSelectedColor:color];
}

@end