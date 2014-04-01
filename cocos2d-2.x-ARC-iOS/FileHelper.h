//
//  FileHelper.h
//  SpidersDrop
//
//  Created by Developer on 4/1/14.
//
//

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject
{
    
}
/**
 *  获得一个私有目录，例如是 /Library/Private Documents
 *
 *
 *  @return 私有目录的路径
 */
+ (NSString *)getPrivateDocsDir;
@end
