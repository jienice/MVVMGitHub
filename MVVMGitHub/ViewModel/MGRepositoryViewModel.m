//
//  MGRepositoryViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/23.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGRepositoryViewModel.h"

@implementation MGRepositoryViewModel


- (void)initialize{
    
    [[self.service.client fetchUserRepositories] subscribeNext:^(id x) {
        
    } e];
}


@end
