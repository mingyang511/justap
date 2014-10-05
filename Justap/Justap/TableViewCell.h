//
//  TableViewCell.h
//  Justap
//
//  Created by Lee on 10/5/14.
//  Copyright (c) 2014 Mingyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"

@class TableViewCell;
@protocol TableViewCellDelegate <NSObject>
- (void)cellTapped:(TableViewCell *)cell;
@end

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) id <TableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet FUIButton *button;
- (void)getImageWithId:(NSString *)string;
@end
