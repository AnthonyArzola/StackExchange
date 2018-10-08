//
//  UsersCollectionViewController.m
//  StackExchange
//
//  Created by Anthony Arzola on 7/8/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

#import "UsersCollectionViewController.h"

// Models or other classes
#import "SEUser.h"
#import "SECache.h"
// UI
#import "UserCollectionViewCell.h"

@interface UsersCollectionViewController ()

@end

@implementation UsersCollectionViewController

@synthesize stackOverflowUsers;

#pragma mark - Life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.stackOverflowUsers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UserCollectionViewCell *cell = (UserCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:UserCollectionViewCell.cellIdentifier forIndexPath:indexPath];
    
    // Configure cell
    SEUser *stackOverflowUser = [self.stackOverflowUsers objectAtIndex:indexPath.row];
    NSNumber *key = [NSNumber numberWithInt:stackOverflowUser.userId];
    
    cell.user = stackOverflowUser;
    [cell setCellValues];
    
    // Retrieve cached image
    if ([[SECache sharedInstance].avatarImages objectForKey:key] != nil) {
        cell.imageViewAvatar.image = [[SECache sharedInstance].avatarImages objectForKey:key];
    }
    else {
        NSLog(@" -- Cached image not found!");
        cell.imageViewAvatar.image = [UIImage imageNamed:@"User"];
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

@end
