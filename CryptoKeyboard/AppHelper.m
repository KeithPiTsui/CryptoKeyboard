

#import "AppHelper.h"

#include <sys/mount.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#import <ifaddrs.h>
#import <MobileCoreServices/MobileCoreServices.h>


static AppHelper *_appHelper = nil;

@implementation AppHelper

+ (AppHelper *)shareHelper {
    if (_appHelper == nil) {
        _appHelper = [[AppHelper alloc] init];
    }
    return _appHelper;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}
+(NSString*)pathByDeletingDocumentsDirectory:(NSString*)destDir
{
    NSString* appDir = [[AppHelper shareHelper] applicationDocumentsDirectory];
    NSAssert([destDir hasPrefix:appDir], @"Parameter MUST be a valid path in this application sandbox!");
    NSString* ret = destDir;
    NSUInteger prefixLength = [appDir length];
    NSUInteger dirLength = [destDir length];
    NSRange range = {prefixLength, dirLength - prefixLength};
    ret = [destDir substringWithRange:range];
    return ret;
}
+(NSString*)applicationDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSApplicationDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}
-(NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}
-(NSUInteger)getFreeDiskSpace
{
    NSString* path = [[AppHelper shareHelper] applicationDocumentsDirectory];
    NSDictionary* dict = [[NSFileManager defaultManager] attributesOfFileSystemForPath:path error:nil];
    NSNumber* n = [dict objectForKey:NSFileSystemFreeSize];
    NSUInteger freeSizeInBytes = [n unsignedIntegerValue];
    return freeSizeInBytes;
}
- (NSString *)applicationCachesDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+(BOOL)getiDeviceTotalSpace:(int64_t*)totalSpaceSize andFreeSpace:(int64_t*)freeSpaceSize
{
    struct statfs buf;
    BOOL success = NO;
    *totalSpaceSize = 0;
    *freeSpaceSize = 0;
    
    if (statfs("/var", &buf) >= 0)
    {
        success = YES;
        *totalSpaceSize = buf.f_bsize*buf.f_blocks;
        *freeSpaceSize = buf.f_bsize*buf.f_bfree;
    }
    return success;
}

- (NSString *)getFileSizeString:(unsigned long long)fileSize
{
    
    NSString *result = nil;
    
    double size = fileSize;
    int unit = 0;
    while(size > 1024.0)
    {
        size /= 1024.0;
        unit ++;
    }
    
    NSString *unitString = @"byte";
    if(unit == 1){
        unitString = @"K";
    }else if(unit == 2){
        unitString = @"M";
    }else if(unit == 3){
        unitString = @"G";
    }else if(unit == 4){
        unitString = @"T";
    }
    
    if (unit > 0) {
        result = [NSString stringWithFormat:@"%.2f %@", size, unitString];
    } else {
        result = [NSString stringWithFormat:@"%.0f %@", size, unitString];
    }
    
    
    return result;
}

- (NSString *)getFileExtensionWithName:(NSString *)name {
    
    NSArray *arr = [name componentsSeparatedByString:@"."];
    if (1 < [arr count]) {
        return [NSString stringWithFormat:@".%@", [arr objectAtIndex:1]];
    } else {
        return @"";
    }
}



// Return the localized IP address - From Erica Sadun's cookbook
- (NSString *)localIPAddress
{
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString* bridgeAddress = nil;
    NSString* wifiAddress = nil;
    BOOL foundAddress = NO;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                NSString* ifaName = [NSString stringWithUTF8String:temp_addr->ifa_name];

                //以下为热点启动后，所有ipv4网卡的情况:
                //lo0         //本地ip, 127.0.0.1
                //en0        //局域网ip, 192.168.1.23
                //pdp_ip0  //WWAN地址，即3G ip,
                //bridge0  //桥接、热点ip，172.20.10.1
                if([ifaName hasPrefix:@"bridge"])
                {
                    foundAddress = YES;
                    bridgeAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    break;
                }
                else if([ifaName hasPrefix:@"en"])
                {
                    foundAddress = YES;
                    wifiAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }

    NSString* address = NSLocalizedString(@"error", nil);
    if (YES == foundAddress)
    {
        address = bridgeAddress ? bridgeAddress : wifiAddress;
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

- (NSString *)listeningPorts
{
#if !TARGET_IPHONE_SIMULATOR
    return @"80";
#else
    return @"8080";
#endif
}

- (NSString *)hostName
{
    char baseHostName[256];
    int success = gethostname(baseHostName, 255);
    if (success != 0) {
        return nil;
    }
    baseHostName[255] = '\0';
    
#if !TARGET_IPHONE_SIMULATOR
    return [NSString stringWithFormat:@"%s.local", baseHostName];
#else
    return [NSString stringWithFormat:@"%s", baseHostName];
#endif
}

- (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)string
{
    static NSDateFormatter *localDateFormatter = nil;
    if (nil == localDateFormatter) {
        localDateFormatter = [[NSDateFormatter alloc] init];
        [localDateFormatter setLocale:[NSLocale currentLocale]];
    }
	[localDateFormatter setDateFormat:string];
	return [localDateFormatter stringFromDate:date];
}
- (NSString*)stringIdentifierForThisDevice
{
//    UICKeyChainStore* store = [UICKeyChainStore keyChainStoreWithService:[[NSBundle mainBundle] bundleIdentifier]];
//    NSString* stringIdentifier = [store stringForKey:PDIdentifierKey];
//    if (!stringIdentifier)
//    {
//        NSUUID* uuid =
//        stringIdentifier = [uuid UUIDString];
//        [store setString:stringIdentifier forKey:PDIdentifierKey];
//    }
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}
@end
