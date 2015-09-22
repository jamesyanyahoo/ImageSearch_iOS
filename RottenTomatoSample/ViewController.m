//
//  ViewController.m
//  RottenTomatoSample
//
//  Created by James Yan on 9/19/15.
//  Copyright © 2015 James Yan. All rights reserved.
//

#import "ViewController.h"
#import <UIImageView+AFNetworking.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.posterImage setImageWithURL:[NSURL URLWithString:self.imageInfo[@"url"]]];

    self.titleLabel.text = self.imageInfo[@"titleNoFormatting"];
    self.summaryLabel.text = self.imageInfo[@"contentNoFormatting"];
    [self.summaryLabel sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
