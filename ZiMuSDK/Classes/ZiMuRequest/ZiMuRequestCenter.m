//
//  ZiMuRequestCenter.m
//  ZiMuSDK
//
//  Created by Comodo on 2022/3/9.
//

#import "ZiMuRequestCenter.h"
#import <GMObjC/GMObjC.h>
//#import "QGAppMacro.h"
//#import "QGAppStatic.h"
//#import "QGUserInfo.h"
#import <AdSupport/AdSupport.h>
#import "NSString+ZiMu.h"
//#import "QGToolsConfig.h"
//#import "QGGlobalConst.h"
//#import "SensorsAnalyticsSDK.h"
//#import "QGAESEncryptTool.h"
//#import "QGCalendarManager.h"
//#import "QGRSA.h"
//#import "QGHUDManager.h"
//#import "QGNetworkNameSpace.h"



FOUNDATION_STATIC_INLINE NSString * public_key_string () {return @"MFkwEwYHKoZIzj0CAQYIKoEcz1UBgi0DQgAEKBhM8nhPB6gyRQnIULcOZWhrs/f0lh/qDP9ibWnmYzw5/jLwHEZn6X7R1wm2sTxd8H1LuFXHq4SBFPwRChTinA=="; }
FOUNDATION_STATIC_INLINE NSString* private_key_string () {return @"MIGTAgEAMBMGByqGSM49AgEGCCqBHM9VAYItBHkwdwIBAQQgF4n24Tb06IP0xm6h8k3ciz/e2eoxqi+ocHqsn2NXqJygCgYIKoEcz1UBgi2hRANCAAQoGEzyeE8HqDJFCchQtw5laGuz9/SWH+oM/2JtaeZjPDn+MvAcRmfpftHXCbaxPF3wfUu4VcerhIEU/BEKFOKc";}

FOUNDATION_STATIC_INLINE NSString * uuidString()
{
    NSString * idfaString = @"";
    
    if ([idfaString isKindOfClass:[NSString class]] && idfaString.length == 0) {
        idfaString = nil;
    }
    
    if (!idfaString || [idfaString hasPrefix:@"00000000"]) {
        idfaString = nil;
    }
    // 没有IDFA，则使用IDFV
    if (!idfaString && NSClassFromString(@"UIDevice")) {
        idfaString = [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    
    // 没有IDFV，则使用UUID
    if (!idfaString) {
        idfaString = [[NSUUID UUID] UUIDString];
    }
    
    if (!idfaString) {
        idfaString = @"error";
    }
    
    return idfaString;
}

@implementation ZiMuRequestCenter

+ (instancetype)shareManager {
    static ZiMuRequestCenter *manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [[self alloc] init];
    });
    return manager;
}


#pragma mark - Login & Logout


- (instancetype)init
{
    if (self = [super init]) {
        [self resetRequestSerializer];
        [self configHTTPHeaders];
    }
    return self;
}


///配置通用header
- (void)configHTTPHeaders
{
    [self setRequestHTTPHeaderValue:@"10001001" forkey:@"x-loong-app-id"]; // appid
    [self setRequestHTTPHeaderValue:uuidString() forkey:@"x-loong-request-id"]; // uuid
}

- (void)requestSuccessCallBackWithURL:(NSString *)urlString opt:(NSString *)opt parameters:(NSDictionary *)parameters task:(NSURLSessionDataTask *)task responseObject:(id)responseObject success:(BaseRequestSuccessBlock)success
{
    [super requestSuccessCallBackWithURL:urlString opt:opt parameters:parameters task:task responseObject:responseObject success:success];

    //解析 businessCode 查看token是否过期
    if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
        NSString * businessCode = responseObject[@"businessCode"];
        //token 鉴权失败,需要退出登录
        if ([businessCode isEqualToString:@"0401"] || [businessCode isEqualToString:@"401"]) {
            NSLog(@"token异常");

        }
        else if ([businessCode isEqualToString:@"439"]){
            NSString * msg = responseObject[@"msg"] ? responseObject[@"msg"] : @"服务器异常请稍后重试";
            NSLog(@"%@",msg);
         }
    }
}

///请求失败的回调
- (void)requestFailureWithURL:(NSString *)urlString opt:(NSString *)opt parameters:(NSDictionary *)parameters error:(NSError *)error task:(NSURLSessionDataTask * )task failure:(BaseRequestFailureBlock)failure
{
    [super requestFailureWithURL:urlString opt:opt parameters:parameters error:error task:task failure:failure];
    
    //网络层的通用处理有时候会到这里
    NSData * errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if ([errorData isKindOfClass:[NSData class]] && errorData.length > 0) {
        NSDictionary * jsonObj = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:nil];
        if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]]) {
            NSString * businessCode = jsonObj[@"businessCode"];
            if ([businessCode isEqualToString:@"0401"] || [businessCode isEqualToString:@"401"]) {
                NSLog(@"token异常");
            }
            else if ([businessCode isEqualToString:@"439"]){
                NSString * msg = jsonObj[@"msg"] ? jsonObj[@"msg"] : @"服务器异常请稍后重试";
                NSLog(@"%@",msg);
            }

        }
    }
}




/**
 支持加密GET请求
 */
- (void)encryptionGET:(NSString *)URLString headers:(nullable NSDictionary <NSString *, NSString *> *)headers parameters:(nullable NSDictionary *)parameters success:(BaseRequestSuccessBlock)success failure:(BaseRequestFailureBlock)failure
{
    NSDictionary * infoDic = [self addBaseRequestParamWithDic:parameters opt:BASE_OPT_GET];
    [super GET:URLString headers:headers parameters:infoDic success:success failure:failure];
}

/**
 支持加密POST请求
 */
- (void)encryptionPOST:(NSString *)URLString headers:(nullable NSDictionary <NSString *, NSString *> *)headers parameters:(nullable NSDictionary *)parameters success:(BaseRequestSuccessBlock)success failure:(BaseRequestFailureBlock)failure
{
    NSDictionary * infoDic = [self addBaseRequestParamWithDic:parameters opt:BASE_OPT_POST];
    [super POST:URLString headers:headers parameters:infoDic success:success failure:failure];
}


-(NSDictionary *)addBaseRequestParamWithDic:(NSDictionary * )parameters opt:(NSString *)opt
{
    //添加基础的参数
    NSMutableDictionary * infoDic = [NSMutableDictionary dictionaryWithCapacity:0];
    //把请求参数加入进来
    if (parameters && [parameters isKindOfClass:[NSDictionary class]]) {
        NSString * bodyString = @"";
        //key=value&key=value拼接方式
        if ([opt isEqualToString:BASE_OPT_GET])
        {
            //与AFN保持一致
            bodyString = AFQueryStringFromParameters(parameters);
        }
        //json拼接方式
        else if ([opt isEqualToString:BASE_OPT_POST])
        {
            bodyString = [self convertToJsonData:parameters];
        }
        else
        {
            NSAssert(YES, @"未指定sign拼接方式，需扩展功能");
        }

        NSString * bodyGMString = [GMSm2Utils encryptText:bodyString publicKey:public_key_string()];
        if (bodyGMString) {
            [infoDic setObject:bodyGMString forKey:@"body"];
        }
        
        NSString *signString = [NSString stringWithFormat:@"body=%@&%@",[self convertToJsonData:infoDic],[self convertToJsonData:self.httpManager.requestSerializer.HTTPRequestHeaders]];
        NSString *signGMString = [GMSm3Utils hmacWithSm3:public_key_string() plaintext:signString];
        NSString *signNewString = [NSString base64StringFromText:signGMString];
        [self setRequestHTTPHeaderValue:signNewString forkey:@"x-loong-sign"];
        
    }
   
    return infoDic;
}


-(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"请求参数转json失败%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}




- (NSString *)baseUrlString
{
    return [NSString stringWithFormat:@"%@/",@"http://yapi.quantgroups.com/mock/535"];
}

@end
