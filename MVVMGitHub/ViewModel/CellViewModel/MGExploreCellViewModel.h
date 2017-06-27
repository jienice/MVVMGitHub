//
//  MGExploreCellViewModel.h
//  MVVMGitHub
//
//  Created by XingJie on 2017/5/25.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,MGExploreCellType){
    
    MGExploreCellTypeOfUser,
    MGExploreCellTypeOfRepo
};

@interface MGExploreCellViewModel : NSObject<MGViewModelProtocol>

@property (nonatomic, assign, readonly) MGExploreCellType cellType;
@property (nonatomic, strong, readonly) NSArray *cellData;
@property (nonatomic, strong, readonly) NSDictionary *params;
@property (nonatomic, copy, readonly) NSString *cellTitle;

@end
