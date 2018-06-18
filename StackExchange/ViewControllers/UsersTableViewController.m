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
    
    // Configure Pull-down refresh, associate with fetchUsers method
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor blackColor];
    [refreshControl addTarget:self action:@selector(fetchUsers:) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
    
    // Check if user requested that existing pictures be deleted and re-downloaded
    // Note: Normally, you would do this in a background thread. For now, I want finish file i/o before I continue.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:SETTINGS_FORCE_DOWNLOAD] != nil && [userDefaults boolForKey:SETTINGS_FORCE_DOWNLOAD])
    {
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDirectory = [path objectAtIndex:0];
        NSString *imagePath = [docDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", @"Avatars"]];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:imagePath];
        NSString *file;
        
        @try {
            // Delete existing avatars
            while (file = [enumerator nextObject]) {
                NSError *error = nil;
                BOOL result = [fileManager removeItemAtPath:[imagePath stringByAppendingPathComponent:file] error:&error];
                
                if (!result && error) {
                    NSLog(@"Unable to remove %@. Error: %@", file, error);
                }
                else {
                    NSLog(@"Successfully remove %@", file);
                }
            }
        } @catch (NSException *exception) {
            NSLog(@"Unable to delete pictures: Exception is:%@", exception);
        } @finally {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setBool:NO forKey:SETTINGS_FORCE_DOWNLOAD];
            [userDefaults synchronize];
        }
    }
    
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

    [self fetchImageForUser:stackOverflowUser withCompletionHandler:^(UIImage *avatarImage) {
        // Update UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageViewAvatar.image = avatarImage;
            [cell.activityIndicatorAvatar stopAnimating];
        });
    }];
    
    return cell;
}

#pragma mark - Navigation

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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *items = [responseObject objectForKey:@"items"];
                [weakSelf.stackOverflowUsers addObjectsFromArray:[SEUser objectFromDictionary:items]];
                
                [weakSelf.tableView reloadData];
            });
            
        } withFailure:^(NSError *error) {
            //TODO: alert user, show toast, log etc.
        }];
    });
    
}

- (void)fetchImageForUser:(SEUser *)stackOverflowUser withCompletionHandler:(void(^)(UIImage *avatarImage))completionHandler {
    
    NSNumber *key = [NSNumber numberWithInt:stackOverflowUser.userId];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [path objectAtIndex:0];
    NSString *imagePath = [docDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%d.png", @"Avatars", stackOverflowUser.userId]];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // 1. Check cache
    // 2. Check file system
    // 3. Download, save to file system and cache it!
    
    if ([[SECache sharedInstance].avatarImages objectForKey:key] != nil) {
        NSLog(@" -- Retrieved cached image.");
        // Get cached image
        UIImage *cachedImage = [[SECache sharedInstance].avatarImages objectForKey:key];
        // Execute block
        completionHandler(cachedImage);
        
    } else if ([fileMgr fileExistsAtPath:imagePath]) {
        NSLog(@" -- Retrieved image from file system AND cached it.");
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Read stored image
            UIImage *localImage = [UIImage imageWithContentsOfFile:imagePath];
            // Cache it
            [[SECache sharedInstance].avatarImages setObject:localImage forKey:key];
            // Execute block
            completionHandler(localImage);
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
                                                NSLog(@" -- Downloaded image, saved it locally and cached it. Yay! Path:%@", mediaPath);
                                                
                                                // Save to file system
                                                [data writeToFile:mediaPath atomically:YES];
                                                // Cache it
                                                [[SECache sharedInstance].avatarImages setObject:image forKey:key];
                                                // Execute block
                                                completionHandler(image);
                                            }
                                        }
                                        @catch (NSException *exception)
                                        {
                                            NSLog(@" -- Exception while saving/caching. Exception:%@", exception);
                                        }
                                    }
                                    else {
                                        NSLog(@" -- Unable to download. Error:%@", error.localizedDescription);
                                    }
                                }];
    }
}

@end
