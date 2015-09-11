
#import "ZSyncURLConnection.h"
#import "PrimaryTools.h"
#import "JsonHandler.h"
#define YYEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]
@implementation ZSyncURLConnection

+ (id)request:(NSString *)requestUrl  completeBlock:(CompleteBlock_t)compleBlock errorBlock:(ErrorBlock_t)errorBlock;
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return [[self alloc] initWithRequest:requestUrl completeBlock:compleBlock errorBlock:errorBlock];
}

+ (id)request:(NSString *)requestUrl requestParameter:(NSDictionary*)rParameter  completeBlock:(CompleteBlock_t)compleBlock errorBlock:(ErrorBlock_t)errorBlock
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return [[self alloc] initWithRequest:requestUrl requestParameter:rParameter completeBlock:compleBlock errorBlock:errorBlock];
}


- (id)initWithRequest:(NSString *)requestUrl requestParameter:(NSDictionary*)rParameter completeBlock:(CompleteBlock_t)compleBlock errorBlock:(ErrorBlock_t)errorBlock
{
    
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval=10.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST"; //设置请求方法
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    NSLog(@"url:%@",url);
    NSLog(@"rParameter:%@",rParameter);

    NSDictionary *convertParameter =  [NSDictionary dictionaryWithObjectsAndKeys:[JsonHandler jsonStringWithDictionary:rParameter],@"p", nil];
      NSLog(@"convertParameter:%@",convertParameter);
    NSString *param=[PrimaryTools creatStringUseThe:@"=" And:@"&" from:convertParameter isNeedTotransCoding:YES];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"param:%@",param);
    
    
    
    if (self = [super initWithRequest:request delegate:self startImmediately:NO]) {
        data_ = [[NSMutableData alloc] init];
        completeBlock_ = [compleBlock copy];
        errorBlock_ = [errorBlock copy];
        [self start];
    }
   
    return self;
}


- (id)initWithRequest:(NSString *)requestUrl completeBlock:(CompleteBlock_t)compleBlock errorBlock:(ErrorBlock_t)errorBlock
{
 
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    if (self = [super initWithRequest:request delegate:self startImmediately:NO]) {
        data_ = [[NSMutableData alloc] init];
        
        completeBlock_ = [compleBlock copy];
        errorBlock_ = [errorBlock copy];
        
        [self start];
    }

    return self;
}

#pragma mark- NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [data_ setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [data_ appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    completeBlock_(data_);
     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    [PrimaryTools alert:@"网络好像出现了点问题哦，请确认处于联网状态后，重试。"];
    errorBlock_(error);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//The following two mothed mean: https(SSL) certificate set always trust
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//    NSLog(@"didReceiveAuthenticationChallenge %@ %zd", [[challenge protectionSpace] authenticationMethod], (ssize_t) [challenge previousFailureCount]);
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        [[challenge sender]  useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
    }
}

+ (void)test:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError)) handler
{
    // 发送请求
    [NSURLConnection sendAsynchronousRequest:nil queue:[NSOperationQueue currentQueue]
                           completionHandler:handler];
}

+ (void)upload:(NSString *)name filename:(NSString *)filename mimeType:(NSString *)mimeType data:(NSData *)data
        parmas:(NSDictionary *)params strUrl:(NSString*)strUrl completionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError)) handler
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // 文件上传
    NSURL *url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 设置请求体
    NSMutableData *body = [NSMutableData data];
    NSDictionary *convertParameter =  [NSDictionary dictionaryWithObjectsAndKeys:[JsonHandler jsonStringWithDictionary:params],@"p", nil];
    /***************文件参数***************/
    // 参数开始的标志
    [body appendData:YYEncode(@"--YY\r\n")];
    // name : 指定参数名(必须跟服务器端保持一致)
    // filename : 文件名
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, filename];
    [body appendData:YYEncode(disposition)];
    NSString *type = [NSString stringWithFormat:@"Content-Type: %@\r\n", mimeType];
    [body appendData:YYEncode(type)];
    
    [body appendData:YYEncode(@"\r\n")];
    [body appendData:data];
    [body appendData:YYEncode(@"\r\n")];
    
    /***************普通参数***************/
    [convertParameter enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        // 参数开始的标志
        [body appendData:YYEncode(@"--YY\r\n")];
        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key];
        [body appendData:YYEncode(disposition)];
        
        [body appendData:YYEncode(@"\r\n")];
        [body appendData:YYEncode(obj)];
        [body appendData:YYEncode(@"\r\n")];
    }];
    
    /***************参数结束***************/
    // YY--\r\n
    [body appendData:YYEncode(@"--YY--\r\n")];
    request.HTTPBody = body;
    
    // 设置请求头
    // 请求体的长度
    [request setValue:[NSString stringWithFormat:@"%zd", body.length] forHTTPHeaderField:@"Content-Length"];
    // 声明这个POST请求是个文件上传
    [request setValue:@"multipart/form-data; boundary=YY" forHTTPHeaderField:@"Content-Type"];
    
    // 发送请求
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if (data) {
////            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
////            if ([oId isKindOfClass:[UIViewController class]]) {
////                [oId dismissViewControllerAnimated:YES completion:NULL];
////            }
////            NSLog(@"upload:--------------%@", dict);
//        } else {
////            NSLog(@"上传失败");
//        }
//    }];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue]
                           completionHandler:handler];
}


@end
