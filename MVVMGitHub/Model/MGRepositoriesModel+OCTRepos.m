//
//  MGRepositoriesModel+OCTRepos.m
//  MVVMGitHub
//
//  Created by XingJie on 2017/1/22.
//  Copyright © 2017年 xingjie. All rights reserved.
//

#import "MGRepositoriesModel+OCTRepos.h"
#import "OCTRepository.h"

@implementation MGRepositoriesModel (OCTRepos)


- (OCTRepository *)transToOCTRepository{
    
    NSMutableDictionary *repoDic = [NSMutableDictionary dictionary];
    [repoDic setObject:self.name forKey:@"name"];
    [repoDic setObject:self.owner.login forKey:@"ownerLogin"];
    [repoDic setObject:self.des forKey:@"repoDescription"];
    [repoDic setObject:self.isPrivate forKey:@"private"];
    [repoDic setObject:self.fork forKey:@"fork"];
    [repoDic setObject:self.pushed_at forKey:@"datePushed"];
    [repoDic setObject:self.default_branch forKey:@"defaultBranch"];
    [repoDic setObject:[NSURL URLWithString:self.clone_url] forKey:@"HTTPSURL"];
    [repoDic setObject:[NSURL URLWithString:self.ssh_url] forKey:@"SSHURL"];
    [repoDic setObject:[NSURL URLWithString:self.git_url] forKey:@"gitURL"];
    [repoDic setObject:[NSURL URLWithString:self.html_url] forKey:@"HTMLURL"];
//    [repoDic setObject:[NSURL URLWithString:self.issues_url] forKey:@"issuesHTMLURL"];
    [repoDic setObject:self.ID forKey:@"objectID"];
    OCTRepository *repo = [[OCTRepository alloc]initWithDictionary:repoDic error:nil];
    return repo;
}
@end
