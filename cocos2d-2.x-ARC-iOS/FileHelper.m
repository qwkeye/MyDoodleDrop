//
//  FileHelper.m
//  SpidersDrop
//
//  Created by Developer on 4/1/14.
//
//

#import "FileHelper.h"

@implementation FileHelper
+ (NSString *)getPrivateDocsDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    
    return documentsDirectory;
    
}
@end
