//
//  UsersTableViewController.m
//  StackExchange
//
//  Created by Anthony Arzola on 6/6/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

// Views
#import "UsersTableViewController.h"
#import "UserTableViewCell.h"
#import "UserDetailsViewController.h"

// Web service
#import "SEWebService.h"

// Models or other classes
#import "SEUser.h"
#import "SEBadges.h"
#import "SEConstants.h"
#import "SECache.h"

// External libs
#import "OCMapper.h"

@interface UsersTableViewController ()

@property (nonatomic, strong) SEWebService *webService;
@property (nonatomic, strong) NSMutableArray *stackOverflowUsers;
@property (nonatomic, strong) NSDictionary *cachedImages;

@end

@implementation UsersTableViewController

@synthesize webService;
@synthesize stackOverflowUsers;

#pragma mark - Constructors

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        webService = [SEWebService new];
        stackOverflowUsers = [NSMutableArray new];
    }
    
    return self;
}

#pragma mark - Life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    // Configure Pull-down refresh, associate with loadData method
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor blackColor];
    [refreshControl addTarget:self action:@selector(fetchUsers:) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
    
    [self fetchUsers:nil];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stackOverflowUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.stackOverflowUsers.count == 0)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = NSLocalizedString(@"Unable to load users.",
                                                @"Unable to load users.");
        return cell;
    }
    
    // Configure the cell...
    static NSString *userCellIdentifier = @"StackOverflowUserCell";
    
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userCellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userCellIdentifier];
    }
    
    SEUser *stackOverflowUser = [self.stackOverflowUsers objectAtIndex:indexPath.row];
    
    cell.user = stackOverflowUser;
    [cell setCellValues];
        
    cell.labelRank.text = [NSString stringWithFormat:@"%d", 1 + (int)indexPath.row];

    NSNumber *key = [NSNumber numberWithInt:stackOverflowUser.userId];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [path objectAtIndex:0];
    NSString *imagePath = [docDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%d.png", @"Avatars", stackOverflowUser.userId]];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    //NSLog(@" -- Image Key:%@, Path:%@", key, imagePath);
    
    // 1. Check cache
    // 2. Check file system
    // 3. Download, save to file system and cache it!
    
    if ([[SECache sharedInstance].avatarImages objectForKey:key] != nil) {
        NSLog(@" -- Lookup cached image.");
        
        UIImage *cachedImage = [[SECache sharedInstance].avatarImages objectForKey:key];
        // Set cell's avatar
        cell.imageViewAvatar.image = cachedImage;
        
    } else if ([fileMgr fileExistsAtPath:imagePath]) {
        NSLog(@" -- Lookup image from file system AND cache it.");
        
        // Set cell's avatar
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Perform file I/O asynchronously
            UIImage *localImage = [UIImage imageWithContentsOfFile:imagePath];
            [[SECache sharedInstance].avatarImages setObject:localImage forKey:key];
            
            // Update UI on the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageViewAvatar.image = localImage;
            });
        });
        
    } else {
        NSURL *imageURL = [[NSURL alloc] initWithString:stackOverflowUser.profileImage];
        SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
        
        [downloader downloadImageWithURL:imageURL options:SDWebImageDownloaderLowPriority
                                progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                    // NOP
                                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                    if (image && finished && error == nil) {
                                        
                                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                        NSString *documentDirectory = [paths objectAtIndex:0];
                                        NSString *mediaPath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%d.png", @"Avatars", stackOverflowUser.userId]];
                                        NSFileManager *fileManager = [NSFileManager defaultManager];
                                        
                                        bool imageExists = [fileManager fileExistsAtPath:mediaPath];
                                        
                                        @try {
                                            if (!imageExists) {
                                                NSLog(@" -- Saving, caching and setting image. Yay! Path:%@", mediaPath);
                                                
                                                // Save to file system
                                                [data writeToFile:mediaPath atomically:YES];
                                                // Cache it
                                                [[SECache sharedInstance].avatarImages setObject:image forKey:key];
                                                // Set cell
                                                cell.imageViewAvatar.image = image;
                                            }
                                        }
                                        @catch (NSException *exception)
                                        {
                                            NSLog(@" -- Exception while saving, caching or setting image. Exception:%@", exception);
                                        }
                                    }
                                    else {
                                        NSLog(@" -- Unable to download. Error:%@", error.localizedDescription);
                                    }
                                }];
    }
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // This isn't necessary now, but just in case we segue into a different
    // part of the app in the future
    if([segue.identifier isEqualToString:@"toUserDetails"])
    {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        SEUser *stackOverflowUser = [stackOverflowUsers objectAtIndex:indexPath.row];
        
        // Set a few properties
        UserDetailsViewController *detailsViewController = (UserDetailsViewController *)segue.destinationViewController;
        detailsViewController.user = stackOverflowUser;
    }
}

#pragma mark - Private methods

- (void)fetchUsers:(UIRefreshControl *)refreshControl {
    
    if (refreshControl != nil) {
        [refreshControl endRefreshing];
        [self.stackOverflowUsers removeAllObjects];
    }
    
    __weak UsersTableViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf.webService requestUsers:^(id responseObject) {
            
            NSLog(@"Success!");
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *items = [responseObject objectForKey:@"items"];
                [weakSelf.stackOverflowUsers addObjectsFromArray:[SEUser objectFromDictionary:items]];
                
                [weakSelf.tableView reloadData];
            });
            
        } withFailure:^(NSError *error) {
            NSLog(@"Failure");
        }];
    });
    
}

@end
