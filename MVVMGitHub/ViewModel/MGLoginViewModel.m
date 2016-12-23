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
@property (nonatomic, strong, readwrite) RACCommand *loginSuccessCommand;

@end


@implementation MGLoginViewModel

- (void)initialize{
    
    @weakify(self);
    
    void(^doNext)(OCTClient *authenticatedClient) = ^(OCTClient *authenticatedClient){
        
        NSLog(@"token === %@",authenticatedClient.token);
        [self.service setClient:[OCTClient authenticatedClientWithUser:authenticatedClient.user token:authenticatedClient.token]];
        
        [[OCTClient fetchMetadataForServer:OCTServer.dotComServer] subscribeNext:^(id x) {
            
        }];
        
        [SSKeychain setPassword:self.passWord forService:MGSSKeychainLoginService account:self.userName];
        
        [self.loginSuccessCommand execute:@YES];
    };
    
    void (^doError)(NSError *error) = ^(NSError *error){
        
        if ([error.domain isEqual:OCTClientErrorDomain] &&
            error.code == OCTClientErrorTwoFactorAuthenticationOneTimePasswordRequired) {
        }
    };
    
    self.loginCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self);
        OCTUser *user = [OCTUser userWithRawLogin:self.userName server:OCTServer.dotComServer];
       return [[[OCTClient signInAsUser:user password:self.passWord oneTimePassword:nil scopes:OCTClientAuthorizationScopesUser] deliverOn:[RACScheduler mainThreadScheduler]] doNext:doNext];
    }];
    
    self.canLoginSignal = [RACSignal combineLatest:@[RACObserve(self, userName),RACObserve(self, passWord)] reduce:^id(NSString *userName, NSString *passWord){
        return @(userName.length>0 && passWord.length>0);
    }];
    
    self.loginSuccessCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSNumber *input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:input];
            return nil;
        }];
    }];
    
    
    
}

@end
