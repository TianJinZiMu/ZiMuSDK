//
//  ZiMuBaseNetwork.h
//  GMObjC
//
//  Created by Comodo on 2022/3/9.
//

#import <Foundation/Foundation.h>

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

///网络不好
#define BaseRequestBadNetworkErrorDomain @"com.quantgroup.badnetwork.errordomain"

#define BASE_OPT_GET @"GET"
#define BASE_OPT_POST @"POST"
#define BASE_OPT_PUT @"PUT"

///请求解析方式
typedef NS_ENUM(NSInteger, QGRequestSerializerType)
{
    ///Json
    QGRequestSerializerTypeJSON = 0,
    ///NSdata
    QGRequestSerializerTypeHTTP,
};

///响应解析方式
typedef NS_ENUM(NSInteger, QGResponseSerializerType)
{
    ///Json
    QGResponseSerializerTypeJSON = 0,
    ///NSdata
    QGResponseSerializerTypeHTTP,
};


///请求成功回调block
typedef void (^BaseRequestSuccessBlock)(id responseObject);

///请求失败回调block
typedef void (^BaseRequestFailureBlock)(NSURLSessionDataTask * task, NSError * error);


///所有ZiMuBaseNetwork子类需要实现的单例方法
@protocol ZiMuBaseNetworkInit <NSObject>


@required
/**
 单例类实例化方法 （由于单例继承问题，此实例化方法需要子类自己实现）
 
 @return 实例化对象 子类返回null 腿打断
 */
+ (nullable instancetype)shareManager;


@end


@interface ZiMuBaseNetwork : NSObject <ZiMuBaseNetworkInit>

/**
 网络请求类
 */
@property (nonatomic, strong, readonly) AFHTTPSessionManager * httpManager;

/**
 请求解析类型
 默认是 QGRequestSerializerTypeJSON
 */
@property (nonatomic, assign) QGRequestSerializerType requestSerializerType;

/**
 响应解析类型
 默认是 QGResponseSerializerTypeJSON
 */
@property (nonatomic, assign) QGResponseSerializerType responseSerializerType;

/**
 网络请求超时时间
 默认是30S
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 是否允许打印全局网络请求log
 默认为YES
 */
@property (nonatomic, assign) BOOL enableLog;

/**
 检查businessCode和code是否都是0000
 
 @param responseObject 响应字典
 @return 检测结果
 */
+ (BOOL)checkBusinessCodeAndCodeWithResponseObjectObject:(NSDictionary *)responseObject;

/**
 根据错误信息获取提示
 
 @param error error
 @return 提示文案
 */
+ (NSString *)getMessageWithFailureError:(NSError *)error;

/**
 使用error换业务失败字典
 适用于 APPBackend部分老接口在失败回调里返回业务失败逻辑
 @param error error
 @return 业务字典
 */
+ (nullable NSDictionary *)getFailureResponseDicWithError:(NSError *)error;

/**
 检查网络状态
 
 @return YES 可用 NO 不可用
 */
- (BOOL)checkNetworkStatus;

/**
 设置请求头的header

 @param value value
 @param key key
 */
- (void)setRequestHTTPHeaderValue:(NSString *)value forkey:(NSString *)key;

/**
 重置请求解析构造器
 1、外部需要重置的时候调用 2、每次设置requestSerializerType的时候会默认调用
 */
- (void)resetRequestSerializer;

/**
 配置通用header
 子类配置通用header时需要重写此函数
 */
- (void)configHTTPHeaders;

/**
 子类需要继承，并且返回特定的url字符串
 */
- (NSString *)baseUrlString;

/**
 GET请求
 
 @param URLString 需要拼接的URL
 @param parameters body传参
 @param success 成功回调
 @param failure 失败回调
 */
- (void)GET:(NSString *)URLString parameters:(nullable NSDictionary *)parameters success:(BaseRequestSuccessBlock)success failure:(BaseRequestFailureBlock)failure;

/**
 GET请求 需要设置临时header
 
 @param URLString 需要拼接的URL
 @param headers 此接口单独添加的header
 @param parameters body传参
 @param success 成功回调
 @param failure 失败回调
 */
- (void)GET:(NSString *)URLString headers:(nullable NSDictionary <NSString *, NSString *> *)headers parameters:(nullable NSDictionary *)parameters success:(BaseRequestSuccessBlock)success failure:(BaseRequestFailureBlock)failure;

/**
 POST请求
 
 @param URLString 需要拼接的URL
 @param parameters body传参
 @param success 成功回调
 @param failure 失败回调
 */
- (void)POST:(NSString *)URLString parameters:(nullable NSDictionary *)parameters success:(BaseRequestSuccessBlock)success failure:(BaseRequestFailureBlock)failure;

/**
 POST请求  需要设置临时header
 
 @param URLString 需要拼接的URL
 @param headers 此接口单独添加的header
 @param parameters body传参
 @param success 成功回调
 @param failure 失败回调
 */
- (void)POST:(NSString *)URLString headers:(nullable NSDictionary <NSString *, NSString *> *)headers parameters:(nullable NSDictionary *)parameters success:(BaseRequestSuccessBlock)success failure:(BaseRequestFailureBlock)failure;

/**
 PUT请求
 
 @param URLString 需要拼接的URL
 @param parameters body传参
 @param success 成功回调
 @param failure 失败回调
 */
- (void)PUT:(NSString *)URLString parameters:(nullable NSDictionary *)parameters success:(BaseRequestSuccessBlock)success failure:(BaseRequestFailureBlock)failure;

/**
 发送最基础的请求 调试/特殊场景会使用得到
 
 @param urlString URL全拼，带上域名
 @param headers 请求header
 @param timeoutInterval 超时时间
 @param opt 发送类型
 @param parameters 请求参数
 @param success 成功回调
 @param failure 失败回调
 */
- (void)sendBaseRequestWithUrlString:(NSString *)urlString headers:(nullable NSDictionary <NSString *, NSString *> *)headers timeoutInterval:(NSTimeInterval)timeoutInterval opt:(NSString *)opt parameters:(nullable NSDictionary *)parameters success:(BaseRequestSuccessBlock)success failure:(BaseRequestFailureBlock)failure;



#pragma mark - 需要自己管理发送的网络请求 外部谨慎调用
///此请求依赖NSOperationQueue管理发送，默认只负责创建
- (NSURLSessionDataTask *)AFTaskWithUrlString:(NSString *)urlString opt:(NSString *)opt parameters:(nullable NSDictionary *)parameters success:(BaseRequestSuccessBlock)success failure:(BaseRequestFailureBlock)failure;



///请求成功的回调, 暴露出来，子类需要特殊处理时继承使用
- (void)requestSuccessCallBackWithURL:(NSString *)urlString opt:(NSString *)opt parameters:(NSDictionary *)parameters task:(NSURLSessionDataTask * )task responseObject:(__nullable id)responseObject success:(BaseRequestSuccessBlock)success;


///请求失败的回调, 暴露出来，子类需要特殊处理时继承使用
- (void)requestFailureWithURL:(NSString *)urlString opt:(NSString *)opt parameters:(NSDictionary *)parameters error:(NSError *)error task:(NSURLSessionDataTask * )task failure:(BaseRequestFailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
