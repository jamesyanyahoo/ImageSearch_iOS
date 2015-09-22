//
//  MovieCell.h
//  RottenTomatoSample
//
//  Created by James Yan on 9/19/15.
//  Copyright © 2015 James Yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;



@end
