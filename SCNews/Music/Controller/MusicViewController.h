//
//  MusicViewController.h
//  SCNews
//
//  Created by 凌       陈 on 10/25/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicViewController : UITableViewController <UIScrollViewDelegate>

-(void) RequestData: (NSString *)urlString;
-(void) reloadLazyLoadingTableViewData;


@end
