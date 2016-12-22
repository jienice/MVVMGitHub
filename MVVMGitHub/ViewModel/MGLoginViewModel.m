//
//  MGLoginViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGLoginViewModel.h"

@interface MGLoginViewModel()

@property (nonatomic, strong, readwrite) RACSignal *canLoginSignal;
@property (nonatomic, strong, readwrite) RACCommand *loginCommand;

@end


@implementation MGLoginViewModel

- (void)initialize{
    
    @weakify(self);
    
    void(^doNext)(OCTClient *authenticatedClient) = ^(OCTClient *authenticatedClient){
        
        NSLog(@"token === %@",authenticatedClient.token);
    };
    
    void (^doError)(NSError *error) = ^(NSError *error){
        
        if ([error.domain isEqual:OCTClientErrorDomain] &&
            error.code == OCTClientErrorTwoFactorAuthenticationOneTimePasswordRequired) {
        }
    };
    
    self.loginCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self);
        OCTUser *user = [OCTUser userWithRawLogin:self.userName server:OCTServer.dotComServer];
        [[[OCTClient signInAsUser:user password:self.passWord oneTimePassword:nil scopes:OCTClientAuthorizationScopesUser] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(OCTClient *authenticatedClient) {
            doNext(authenticatedClient);
        } error:^(NSError *error) {
            doError(error);
        }];
        return [RACSignal empty];
    }];
    
    self.canLoginSignal = [RACSignal combineLatest:@[RACObserve(self, userName),RACObserve(self, passWord)] reduce:^id(NSString *userName, NSString *passWord){
        return @(userName.length>0 && passWord.length>0);
    }];
    
    
    
}

@end
