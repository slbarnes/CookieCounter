//
//  CookieCountCell.h
//  LaTables
//
//  Created by Shelley Barnes on 11/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CookieCountCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *cookieNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *quantityLabel;
@property (nonatomic, strong) IBOutlet UIStepper *stepper;
@property (nonatomic, strong) IBOutlet UITextField *donationAmount;
@property (nonatomic, strong) IBOutlet UISegmentedControl *paidDeliveredControl;

@end
