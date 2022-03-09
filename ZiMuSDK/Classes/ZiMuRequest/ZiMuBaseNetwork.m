//
//  ZiMuBaseNetwork.m
//  GMObjC
//
//  Created by Comodo on 2022/3/9.
//

#import "ZiMuBaseNetwork.h"

#import "NSString+ZiMu.h"

#define NetworkNormalTimeoutInterval 10.0f



@interface AFHTTPSessionManager (DataTask)

// 暴露出AFN的内部方法，用于自己管理task，主要用于有依赖请求的场景

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                         headers:(NSDictionary <NSString *, NSString *> *)headers
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;
@end


@interface ZiMuBaseNetwork ()

/**
 网络请求管理类
 */
@property (nonatomic, strong, readwrite) AFHTTPSessionManager * httpManager;

@end


@implementation ZiMuBaseNetwork


/**
 检查businessCode和code是否都是0000
 
 @param responseObject 响应字典
 @return 检测结果
 */
+ (BOOL)checkBusinessCodeAndCodeWithResponseObjectObject:(NSDictionary *)responseObject
{
    BOOL result = NO;
    if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
        NSString * businessCode = responseObject[@"businessCode"];
        NSString * code = responseObject[@"code"];
        //检测是否存在以及是否0000
        if (businessCode && code) {
            if ([businessCode isEqualToString:@"0000"] && [code isEqualToString:@"0000"]) {
                result = YES;
            }
        }
    }
    return result;
}

/**
 单例类实例化方法 （由于单例继承问题，此实例化方法需要子类自己实现）
 
 @return 实例化对象
 */
+ (nullable instancetype)shareManager
{
    //base里面不做初始化，子类需要自己实现
    return nil;
}


- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.httpManager = [AFHTTPSessionManager manager];
        self.requestSerializerType = QGRequestSerializerTypeJSON;
        self.responseSerializerType = QGResponseSerializerTypeJSON;
        self.httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"plant/html",@"text/plain",@"text/xml",@"image/jpeg",@"image/png",@"multipart/form-data",@"application/octet-stream", nil];
        
        self.enableLog = YES;
        self.timeoutInterval = NetworkNormalTimeoutInterval;
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        /* 网络请求监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingTaskDidCompleteNotification:) name:AFNetworkingTaskDidCompleteNotification object:nil];
         */
    }
    return self;
}

/*
- (void)networkingTaskDidCompleteNotification:(NSNotification *)notif
{
    NSDictionary *userInfo = notif.userInfo;
    NSError * error = userInfo[AFNetworkingTaskDidCompleteErrorKey];
    NSURLSessionTaskMetrics *sessionTaskMetrics = userInfo[AFNetworkingTaskDidCompleteSessionTaskMetrics];
    NSArray<NSURLSessionTaskTransactionMetrics *> *transactionMetrics = sessionTaskMetrics.transactionMetrics;
    for (NSURLSessionTaskTransactionMetrics * transactionMetric in transactionMetrics) {
        if (transactionMetric.resourceFetchType == NSURLSessionTaskMetricsResourceFetchTypeNetworkLoad) {
            NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)transactionMetric.response;
            NSMutableDictionary * metricDic = [NSMutableDictionary dictionaryWithCapacity:0];
            [metricDic setObject:transactionMetric.request.URL.absoluteString forKey:@"101、请求url"];
            [metricDic setObject:transactionMetric.request.HTTPMethod forKey:@"101、requestMethod"];
            [metricDic setObject:@(httpResponse ? httpResponse.statusCode : error.code) forKey:@"102、状态码"];
            [metricDic setObject:@(sessionTaskMetrics.taskInterval.duration) forKey:@"103、请求总时耗时"];
            [metricDic setObject:@(sessionTaskMetrics.redirectCount) forKey:@"104、重定向次数"];
            [metricDic setObject:transactionMetric.networkProtocolName forKey:@"105、网络协议名"];
            [metricDic setObject:transactionMetric.proxyConnection ? @"YES" : @"NO"  forKey:@"106、是否使用了代理"];
            [metricDic setObject:@(transactionMetric.fetchStartDate.timeIntervalSince1970) forKey:@"107、客户端开始请求的时间"];
            [metricDic setObject:@(transactionMetric.domainLookupStartDate.timeIntervalSince1970) forKey:@"108、DNS开始解析的时间"];
            [metricDic setObject:@(transactionMetric.domainLookupEndDate.timeIntervalSince1970) forKey:@"109、DNS结束解析的时间"];
            [metricDic setObject:@(transactionMetric.connectStartDate.timeIntervalSince1970) forKey:@"110、客户端与服务端建立TCP连接开始的时间"];
            [metricDic setObject:@(transactionMetric.secureConnectionStartDate.timeIntervalSince1970) forKey:@"111、HTTPS的TLS握手开始的时间"];
            [metricDic setObject:@(transactionMetric.secureConnectionEndDate.timeIntervalSince1970) forKey:@"112、HTTPS的TLS握手结束的时间"];
            [metricDic setObject:@(transactionMetric.connectEndDate.timeIntervalSince1970) forKey:@"113、客户端与服务器建立TCP连接完成的时间，包括TLS握手时间"];
            [metricDic setObject:@(transactionMetric.requestStartDate.timeIntervalSince1970) forKey:@"114、开始传输HTTP请求的header第一个字节的时间"];
            [metricDic setObject:@(transactionMetric.requestEndDate.timeIntervalSince1970) forKey:@"115、HTTP请求最后一个字节传输完成的时间"];
            [metricDic setObject:@(transactionMetric.responseStartDate.timeIntervalSince1970) forKey:@"116、客户端接收响应的第一个字节的时间"];
            [metricDic setObject:@(transactionMetric.responseEndDate.timeIntervalSince1970) forKey:@"117、客户端接收响应的最后一个字节的时间"];
            if (@available(iOS 13.0, *)) {
                [metricDic setObject:transactionMetric.localAddress forKey:@"118、当前连接下的本地接口 IP 地址"];
                [metricDic setObject:transactionMetric.localPort forKey:@"119、当前连接下的本地端口号"];
                [metricDic setObject:transactionMetric.remoteAddress forKey:@"120、当前连接下的远端 IP 地址"];
                [metricDic setObject:transactionMetric.remotePort forKey:@"121、当前连接下的远端端口号"];
                [metricDic setObject:transactionMetric.negotiatedTLSProtocolVersion ? transactionMetric.negotiatedTLSProtocolVersion : @"" forKey:@"122、连接协商用的TLS协议版本号"];
            }
            NSLogger(LoggerManagerZhang, @"%@",metricDic);
        }
    }
}
 */

///设置请求头的header
- (void)setRequestHTTPHeaderValue:(NSString *)value forkey:(NSString *)key
{
    if (value && key) {
        [self.httpManager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
}

/**
 重置请求解析构造器
 1、外部需要重置的时候调用 2、每次设置requestSerializerType的时候会默认调用
 */
- (void)resetRequestSerializer
{
    switch (_requestSerializerType) {
        case QGRequestSerializerTypeJSON:
            self.httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        case QGRequestSerializerTypeHTTP:
            self.httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        default:
            break;
    }
}

/**
 配置通用header
 子类配置通用header时需要重写此函数
 */
- (void)configHTTPHeaders
{
    //需要子类自己实现
}

#pragma mark - Setter
- (void)setRequestSerializerType:(QGRequestSerializerType)requestSerializerType
{
    _requestSerializerType = requestSerializerType;
    //重建构造器
    [self resetRequestSerializer];
    //配置通用header
    [self configHTTPHeaders];
}

- (void)setResponseSerializerType:(QGResponseSerializerType)responseSerializerType
{
    _responseSerializerType = responseSerializerType;
    switch (_responseSerializerType) {
        case QGResponseSerializerTypeJSON:
            self.httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case QGResponseSerializerTypeHTTP:
            self.httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        default:
            break;
    }
}


- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval
{
    if (_timeoutInterval != timeoutInterval) {
        _timeoutInterval = timeoutInterval;
        
        [self.httpManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        self.httpManager.requestSerializer.timeoutInterval = _timeoutInterval > 0 ? _timeoutInterval : NetworkNormalTimeoutInterval;
        [self.httpManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
    }
   
}


/**
 检查网络状态

 @return YES 可用 NO 不可用
 */
- (BOOL)checkNetworkStatus
{
    AFNetworkReachabilityStatus networkReachabilityStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        return NO;
    }
    return YES;
}





/**
 GET请求

 @param URLString 需要拼接的URL
 @param parameters body传参
 @param success 成功回调
 @param failure 失败回调
 */
- (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(BaseRequestSuccessBlock)success failure:(BaseRequestFailureBlock)failure {
    [self GET:URLString headers:nil parameters:parameters success:success failure:failure];
}


/**
 GET请求 需要设置临时header
 
 @param URLString 需要拼接的URL
 @param headers 此接口单独添加的header
 @param parameters body传参
 @param success 成功回调
 @param failure 失败回调
 */
- (void)GET:(NSString *)URLString headers:(nullable NSDictionary <NSString *, NSString *> *)headers parameters:(NSDictionary *)parameters success:(BaseRequestSuccessBlock)success failure:(BaseRequestFailureBlock)failure
{
    [self privateSendRequestWithUrlString:URLString headers:headers timeoutInterval:NetworkNormalTimeoutInterval opt:BASE_OPT_GET parameters:parameters success:success failure:failure];
}

/**
 POST请求
 
 @param URLString 需要拼接的URL
 @param parameters body传参
 @param success 成功回调
 @param failure 失败回调
 */
- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(BaseRequestSuccessBlock)success failure:(BaseRequestFailureBlock)failure {
    [self POST:URLString headers:nil parameters:parameters success:success failure:failure];
}

/**
 POST请求  需要设置临时header
 
 @param URLString 需要拼接的URL
 @param headers 此接口单独添加的header
 @param parameters body传参
 @param success 成功回调
 @param failure 失败回调
 */
- (void)POST:(NSString *)URLString headers:(nullable NSDictionary <NSString *, NSString *> *)headers parameters:(NSDictionary *)parameters success:(BaseRequestSuccessBlock)success failure:(BaseRequestFailureBlock)failure
{
    [self privateSendRequestWithUrlString:URLString headers:headers timeoutInterval:NetworkNormalTimeoutInterval opt:BASE_OPT_POST parameters:parameters success:success failure:failure];
}

/**
 PUT请求
 
 @param URLString 需要拼接的URL
 @param parameters body传参
 @param success 成功回调
 @param failure 失败回调
 */
- (void)PUT:(NSString *)URLString parameters:(NSDictionary *)parameters success:(BaseRequestSuccessBlock)success failure:(BaseRequestFailureBlock)failure {
    [self privateSendRequestWithUrlString:URLString headers:nil timeoutInterval:NetworkNormalTimeoutInterval opt:BASE_OPT_PUT parameters:parameters success:success failure:failure];
}

#pragma mark - task
///此请求依赖NSOperationQueue管理发送，默认只负责创建
- (NSURLSessionDataTask *)AFTaskWithUrlString:(NSString *)urlString opt:(NSString *)opt parameters:(NSDictionary *)parameters success:(BaseRequestSuccessBlock)success failure:(BaseRequestFailureBlock)failure
{
    self.timeoutInterval = NetworkNormalTimeoutInterval;
    
    //如果url不包含http://或者https://信息则拼接baseUrl
    if (![urlString containsString:@"http://"] && ![urlString containsString:@"https://"]) {
        NSString * baseUrl = [NSString isEmpty:[self baseUrlString]] ? @"" : [self baseUrlString];
        urlString = [baseUrl stringByAppendingString:urlString];
    }
    
    if (self.enableLog) {
        NSLog(@"🙏🙏🙏\n---sendStart----\n【%@】sendrequest:%@ parameters:%@\n----sendEnd-----\n\n",opt,urlString, parameters);

    }
    
    NSURLSessionDataTask *task = [self.httpManager dataTaskWithHTTPMethod:opt URLString:urlString parameters:parameters headers:nil uploadProgress:nil downloadProgress:nil success:^(NSURLSessionDataTask * task, id responseObject) {
        [self requestSuccessCallBackWithURL:urlString opt:opt parameters:parameters task:task responseObject:responseObject success:success];
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        [self requestFailureWithURL:urlString opt:opt parameters:parameters error:error task:task failure:failure];
    }];
    
    return task;
}


#pragma mark - private
- (void)privateSendRequestWithUrlString:(NSString *)urlString headers:(nullable NSDictionary <NSString *, NSString *> *)headers timeoutInterval:(NSTimeInterval)timeoutInterval opt:(NSString *)opt parameters:(NSDictionary *)parameters success:(BaseRequestSuccessBlock)success failure:(BaseRequestFailureBlock)failure {

    [self sendBaseRequestWithUrlString:urlString headers:headers timeoutInterval:timeoutInterval opt:opt parameters:parameters success:success failure:failure];
}


#pragma mark - normal request

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
- (void)sendBaseRequestWithUrlString:(NSString *)urlString headers:(nullable NSDictionary <NSString *, NSString *> *)headers timeoutInterval:(NSTimeInterval)timeoutInterval opt:(NSString *)opt parameters:(NSDictionary *)parameters success:(BaseRequestSuccessBlock)success failure:(BaseRequestFailureBlock)failure
{
    
    //网络状况检查
    /*
     BOOL networkStatus = [self checkNetworkStatus];
     if (!networkStatus) {
     NSDictionary * userInfo = [NSDictionary dictionaryWithObject:@"当前网络不可用" forKey:@"message"];
     NSError * failError = [[NSError alloc]initWithDomain:BaseRequestBadNetworkErrorDomain code:-10 userInfo:userInfo];
     if (failure) {
     failure(failError);
     }
     return;
     }
     */
    
    //如果url不包含http://或者https://信息则拼接baseUrl
    if (![urlString containsString:@"http://"] && ![urlString containsString:@"https://"]) {
        NSString * baseUrl = [NSString isEmpty:[self baseUrlString]] ? @"" : [self baseUrlString];
        urlString = [baseUrl stringByAppendingString:urlString];
    }
    
    self.timeoutInterval = timeoutInterval;
    
//    NSLogger(LoggerManagerTalosNetwork, @"timeoutInterval = %f", self.httpManager.requestSerializer.timeoutInterval);
    if (self.enableLog) {
        NSLog(@"🙏🙏🙏\n【%@】sendrequest:%@ parameters:%@\n", opt, urlString, parameters);
    }
    
    //GET
    if ([opt isEqualToString:BASE_OPT_GET]) {
        [self.httpManager GET:urlString parameters:parameters headers:headers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self requestSuccessCallBackWithURL:urlString opt:opt parameters:parameters task:task responseObject:responseObject success:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self requestFailureWithURL:urlString opt:opt parameters:parameters error:error task:task failure:failure];
        }];
    }
    //PUT
    else if ([opt isEqualToString:BASE_OPT_PUT]) {
        [self.httpManager PUT:urlString parameters:parameters headers:headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self requestSuccessCallBackWithURL:urlString opt:opt parameters:parameters task:task responseObject:responseObject success:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self requestFailureWithURL:urlString opt:opt parameters:parameters error:error task:task failure:failure];
        }];
    }
    //POST
    else if ([opt isEqualToString:BASE_OPT_POST]) {
        [self.httpManager POST:urlString parameters:parameters headers:headers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self requestSuccessCallBackWithURL:urlString opt:opt parameters:parameters task:task responseObject:responseObject success:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self requestFailureWithURL:urlString opt:opt parameters:parameters error:error task:task failure:failure];
        }];
    } else {
        NSLog(@"请求类型错误，请检查请求库");
    }
}


///请求成功的回调
- (void)requestSuccessCallBackWithURL:(NSString *)urlString opt:(NSString *)opt parameters:(NSDictionary *)parameters task:(NSURLSessionDataTask * )task responseObject:(nullable id)responseObject success:(BaseRequestSuccessBlock)success
{
    
    if (self.enableLog) {
        NSDictionary * httpHeader = self.httpManager.requestSerializer.HTTPRequestHeaders;
        NSLog(@"🎉🎉🎉🎉请求成功了🎉🎉🎉🎉\nURLSting = %@ \n opt = %@ \n headers = %@ \n parameters =\n%@ \n responseObject = %@",urlString,opt, httpHeader ,parameters,responseObject);
    }
    if (success) {
        success(responseObject);
    }
}

///请求失败的回调
- (void)requestFailureWithURL:(NSString *)urlString opt:(NSString *)opt parameters:(NSDictionary *)parameters error:(NSError *)error task:(NSURLSessionDataTask * )task failure:(BaseRequestFailureBlock)failure
{
    if (failure) {
        failure(task,error);
    }

    //backend有时候会从此处传递业务处理失败信息
    NSData * errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (errorData) {
        NSString * errorStr = [[NSString alloc]initWithData:errorData encoding:NSUTF8StringEncoding];
        if (self.enableLog) {
            NSDictionary * httpHeader = self.httpManager.requestSerializer.HTTPRequestHeaders;
            NSLog(@"❗️❗️❗️❗️请求成功，业务失败了❗️❗️❗️❗️\nURLSting = %@ \n opt = %@ \n headers = %@ \n parameters =\n%@ \n error = %@ \n errorCode = %ld",urlString, opt, httpHeader, parameters,errorStr,error.code);
        }
    }
    else
    {
        NSDictionary * httpHeader = self.httpManager.requestSerializer.HTTPRequestHeaders;
        NSLog(@"❗️❗️❗️❗️服务器响应失败了❗️❗️❗️❗️\nURLSting = %@ \n opt = %@ \n headers = %@ \n parameters =\n%@ \n error = %@ \n errorCode = %ld",urlString,opt, httpHeader, parameters,error, error.code);
    }
    
}



/**
 使用error换业务失败字典
 适用于 APPBackend部分老接口在失败回调里返回业务失败逻辑
 @param error error
 @return 业务字典
 */
+ (nullable NSDictionary *)getFailureResponseDicWithError:(NSError *)error
{
    NSDictionary * errorDic;
    //backend有时候会从此处传递业务处理失败信息
    NSData * errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (errorData) {
        errorDic = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
    }
    return errorDic;
}


/**
 根据错误信息获取提示

 @param error error
 @return 提示文案
 */
+ (NSString *)getMessageWithFailureError:(NSError *)error
{
    NSString * errorMessage = @"";
    //backend有时候会从此处传递业务处理失败信息
    NSData * errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (errorData) {
        NSDictionary * errorDic = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
        if (errorDic && [errorDic isKindOfClass:[NSDictionary class]]) {
            errorMessage = errorDic[@"msg"] ? errorDic[@"msg"] : errorDic[@"message"];
        }
    }
    else
    {
        //超时
        if (error.code == NSURLErrorTimedOut) {
            errorMessage = @"网络请求超时";
        }
    }
    return ![NSString isEmpty:errorMessage] ? errorMessage : @"服务器异常请稍后重试";
}


/**
 子类需要继承，并且返回特定的url字符串
 */
- (NSString *)baseUrlString
{
    return @"";
}

- (void)dealloc
{
//    [self.httpManager invalidateSessionCancelingTasks:YES resetSession:NO];
//    NSLog(@"Base NetWork");
}


@end
