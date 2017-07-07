//
//  MGLoginViewModel.m
//  MVVMGitHub
//
//  Created by XingJie on 2016/12/22.
//  Copyright © 2016年 xingjie. All rights reserved.
//

#import "MGLoginViewModel.h"

@interface MGLoginViewModel()

@property (nonatomic, strong, readwrite) RACCommand *loginSuccessCommand;

@end


@implementation MGLoginViewModel

- (void)initialize{
    
    [OCTClient setClientID:MG_Client_ID clientSecret:MG_Client_Secret];
    
    @weakify(self);
    _loginCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSString *oneTimePassword) {
        @strongify(self);
        OCTUser *user = [OCTUser userWithRawLogin:self.userName server:OCTServer.dotComServer];
        return [[[[OCTClient signInAsUser:user
                               password:self.passWord
                        oneTimePassword:oneTimePassword
                                 scopes:OCTClientAuthorizationScopesRepository|OCTClientAuthorizationScopesUserFollow]
                  doNext:^(OCTClient *authenticatedClient){
                      [SAMKeychain mg_setAccessToken:authenticatedClient.token];
                      [SAMKeychain mg_setPassWord:self.passWord];
                      [SAMKeychain mg_setRawlogin:authenticatedClient.user.rawLogin];
                      [MGSharedDelegate setClient:authenticatedClient];
                  }] then:^RACSignal *{
            return [MGSharedDelegate.client fetchUserInfo];
        }] doNext:^(OCTUser *user) {
            [SAMKeychain mg_setName:user.name];
            [SAMKeychain mg_setlogin:user.login];
        }];
    }];
    
    _canLoginSignal = [RACSignal combineLatest:@[RACObserve(self, userName),RACObserve(self, passWord)] reduce:^id(NSString *userName, NSString *passWord){
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
