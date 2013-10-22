//
//  DetailViewController.h
//  Sample
//
//  Created by Burton Lee on 10/22/13.
//  Copyright (c) 2013 Buffalo Ladybug LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
