//
//  HelperClass.m
//  CookieCounter
//
//  Created by Shelley Barnes on 11/11/13.
//
//

#import "HelperClass.h"

@implementation HelperClass

+ (UITableViewCell *) getTableViewCellFromSubview:(UIView*)subview  {
    
    UITableViewCell* tableViewCell = nil;
    while (subview.superview != Nil) {
        if ([subview.superview isKindOfClass:[UITableViewCell class]]) {
            tableViewCell = (UITableViewCell*)subview.superview;
            break;
        }
        else  {
            subview = subview.superview;
        }
    }

    return tableViewCell;
}

+ (UITableView *) getTableViewFromSubview:(UIView*)subview  {
    
    UITableView* tableViewCell = nil;
    while (subview.superview != Nil) {
        if ([subview.superview isKindOfClass:[UITableView class]]) {
            tableViewCell = (UITableView*)subview.superview;
            break;
        }
        else  {
            subview = subview.superview;
        }
    }
    
    return tableViewCell;
}

@end
