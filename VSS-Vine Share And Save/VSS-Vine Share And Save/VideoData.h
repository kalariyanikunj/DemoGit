//
//  VideoData.h
//  VineApp
//
//  Created by alpesh7 on 11/28/13.
//  Copyright (c) 2013 Creative Infoway. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoData : NSObject
{
    NSString *avatarUrl;
    NSString *commentCount;
    NSString *created;
    NSString *description;
    NSString *likesCount;
    NSString *thumbnailUrl;
    NSString *userId;
    NSString *username;
    NSString *videoUrl;
}
@property (nonatomic,retain) NSString *avatarUrl;
@property (nonatomic,retain) NSString *commentCount;
@property (nonatomic,retain) NSString *created;
@property (nonatomic,retain) NSString *description;
@property (nonatomic,retain) NSString *likesCount;
@property (nonatomic,retain) NSString *thumbnailUrl;
@property (nonatomic,retain) NSString *userId;
@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) NSString *videoUrl;
@property (nonatomic,retain) NSString *postId;
@property (nonatomic,retain) NSString *shareURL;
@property (nonatomic,retain) NSString *liked;
@property (nonatomic,retain) NSArray *likesArray;
@end
