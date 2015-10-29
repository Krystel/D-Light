//
//  TacoShell.m
//  Pods
//
//  Created by Marcus Kida on 26/07/2014.
//
//

#import "TacoShell.h"

#define BKLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#define kHttpStatusCodes @{\
@400: @"Bad Request",\
@401: @"Unauthorized",\
@402: @"Payment Required",\
@403: @"Forbidden",\
@404: @"Not Found",\
@405: @"Method Not Allowed",\
@406: @"Not Acceptable",\
@407: @"Proxy Authentication Required",\
@408: @"Request Timeout",\
@409: @"Conflict",\
@410: @"Gone",\
@411: @"Length Required",\
@412: @"Precondition Failed",\
@413: @"Payload Too Large",\
@414: @"URI Too Long",\
@415: @"Unsupported Media Type",\
@416: @"Requested Range Not Satisfiable",\
@417: @"Expectation Failed",\
@418: @"I'm A Teapot",\
@422: @"Unprocessable Entity",\
@423: @"Locked",\
@424: @"Failed Dependency",\
@425: @"Unassigned",\
@426: @"Upgrade Required",\
@427: @"Unassigned",\
@428: @"Precondition Required",\
@429: @"Too Many Requests",\
@430: @"Unassigned",\
@431: @"Request Header Fields Too Large",\
@432: @"Unassigned",\
@500: @"Internal Server Error",\
@501: @"Not Implemented",\
@502: @"Bad Gateway",\
@503: @"Service Unavailable",\
@504: @"Gateway Timeout",\
@505: @"HTTP Version Not Supported",\
@506: @"Variant Also Negotiates",\
@507: @"Insufficient Storage",\
@508: @"Loop Detected",\
@509: @"Unassigned",\
@510: @"Not Extended",\
@511: @"Network Authentication Required"\
}

#define kMethodString @{\
@0: @"GET",\
@1: @"HEAD",\
@2: @"PUT",\
@3: @"POST",\
@4: @"DELETE"\
}

#define kRequestContentType @{\
@0: @"",\
@1: @"application/json",\
@2: [@"multipart/form-data; boundary=" stringByAppendingString:BOUNDARY],\
@3: @"application/x-www-form-urlencoded; charset=utf-8",\
@4: @"application/octet-stream"\
}

static NSString *const BOUNDARY = @"------------nSUNNZHqffyIEayXwGKz";
static NSString *const CONTENT_TYPE = @"Content-Type";
static NSString *const APPLICATION_JSON = @"application/json";
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@interface NSData (BKTSBase64)

- (NSString *)bkts_base64Encoding;

@end

@interface TacoShell () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong) NSURLConnection *connection;
@property (strong) NSURLRequest *request;
@property (strong) NSMutableDictionary *requestHeaders;

@property (strong) NSMutableData *responseData;
@property (strong) NSDictionary *responseHeaders;
@property (assign) NSInteger responseStatusCode;
@property (strong) NSString *responseStringEncoding;
@property (strong) NSError *connectionError;
@property (strong) NSURLCredential *credential;

@property (assign) long long responseExpectedLength;
@property (assign) BOOL isJsonResponse;

@end

@implementation TacoShell

#pragma mark - Initialization
- (instancetype)initWithURL:(NSURL *)url
{
    if (self = [super init]) {
        [self setupWithURL:url];
    }
    return self;
}

- (void)setupWithURL:(NSURL *)url
{
    self.responseData = [[NSMutableData alloc] init];
    self.preventRedirects = NO;
    self.method = BKTSRequestMethodGET;
    self.contentType = BKTSRequestContentTypeMultipartFormData;
    self.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    self.timeout = 30;
    self.requestHeaders = [[NSMutableDictionary alloc] init];
    self.url = url;
}

#pragma mark - Start / Cancel
- (void)start
{
    [self startUsingBasicAuthUsername:nil password:nil];
}

- (void)startUsingBasicAuthUsername:(NSString *)username password:(NSString *)password
{
    self.credential = nil;
    if (username.length > 0 && password.length > 0) {
        self.credential = [NSURLCredential credentialWithUser:username password:password persistence:NSURLCredentialPersistenceNone];
    }
    
    NSURL *requestUrl = self.url;
    if (self.credential) {
        requestUrl = [self urlByAddingCredentials:self.credential toURL:self.url];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl cachePolicy:self.cachePolicy timeoutInterval:self.timeout];
    [request setHTTPMethod:kMethodString[[NSNumber numberWithInt:self.method]]];
    
    if(self.credential) {
        NSString *authString = [NSString stringWithFormat:@"%@:%@", self.credential.user, self.credential.password];
        NSData *authData = [authString dataUsingEncoding:NSASCIIStringEncoding];
        NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData bkts_base64Encoding]];
        [request addValue:authValue forHTTPHeaderField:@"Authorization"];
    }
    
    // Content Type
    if (self.contentType != BKTSRequestContentTypeNone) {
        [self setHeaderValue:kRequestContentType[[NSNumber numberWithInt:self.contentType]] headerField:CONTENT_TYPE];
    }
    
    // POSTDictionary or POSTData
    if ((self.POSTDictionary || self.POSTData) && self.contentType == BKTSRequestContentTypeNone) {
        [self setHeaderValue:[@"multipart/form-data; boundary=" stringByAppendingString:BOUNDARY] headerField:CONTENT_TYPE];
    }
    
    // Headers
    [self.requestHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request addValue:obj forHTTPHeaderField:key];
    }];
    
    // POST Body
    if (self.POSTDictionary) {
        if (self.contentType == BKTSRequestContentTypeApplicationJSON){
            self.POSTData = [NSJSONSerialization dataWithJSONObject:self.POSTDictionary options:0 error:nil];
        } else {
            NSMutableData *POSTData = [[NSMutableData alloc] init];
            [self.POSTDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [POSTData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
                [POSTData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
                [POSTData appendData:[[obj description] dataUsingEncoding:NSUTF8StringEncoding]];
            }];
            [POSTData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
            self.POSTData = POSTData;
        }
    }
    
    if (self.POSTData) {
        [request setHTTPBody:self.POSTData];
    }

    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    self.request = self.connection.currentRequest;
    [self.connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self.connection start];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.connection) {
            if (self.errorBlock) {
                self.errorBlock([self errorWithCode:0 localizedDescription:@"Can't establish connection"]);
            }
        }
    });
}

- (void)cancel
{
    [self.connection cancel];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.errorBlock) {
            self.errorBlock([self errorWithCode:0 localizedDescription:@"Request cancelled by user"]);
        }
    });
}

#pragma mark  - Error
- (NSError *)errorWithCode:(NSInteger)code localizedDescription:(NSString *)description
{
    return [NSError errorWithDomain:NSStringFromClass(self.class) code:0 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(description, nil)}];
}

#pragma mark - Headers
- (void)setHeaderValue:(NSString *)value headerField:(NSString *)field
{
    if (!value || !field) {
        return;
    }
    [[self requestHeaders] setObject:value forKey:field];
}

- (void)removeHeaderValueForField:(NSString *)field
{
    if (!field) {
        return;
    }
    [[self requestHeaders] removeObjectForKey:field];
}

#pragma mark - NSURLConnectionDelegate
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
    
    if(redirectResponse) {
        if (self.preventRedirects) {
            return nil;
        }
        NSMutableURLRequest *redirectRequest = [self.request mutableCopy];
        redirectRequest.URL = request.URL;
        return redirectRequest;
    }
    
    return request;
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    NSURLProtectionSpace *protectionSpace = [challenge protectionSpace];
    NSString *authenticationMethod = [protectionSpace authenticationMethod];
    
    if ([authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPDigest] ||
        [authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic]) {
        
        if([challenge previousFailureCount] == 0) {
            [[challenge sender] useCredential:self.credential forAuthenticationChallenge:challenge];
        } else {
            self.credential = nil;
            [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
        }
    } else {
        [[challenge sender] performDefaultHandlingForAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.connectionError = error;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.errorBlock) {
            self.errorBlock(error);
        }
    });
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // JSON Response?
    self.isJsonResponse = ([[(NSHTTPURLResponse *)response allHeaderFields][CONTENT_TYPE] rangeOfString:APPLICATION_JSON].location != NSNotFound);
    
    // Reset responseData
    [self.responseData setLength:0];
    
    // Store responseHeaders
    if ([response isKindOfClass:NSHTTPURLResponse.class]) {
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
        self.responseHeaders = urlResponse.allHeaderFields;
        self.responseStatusCode = urlResponse.statusCode;
        self.responseStringEncoding = urlResponse.textEncodingName;
        self.responseExpectedLength = urlResponse.expectedContentLength;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append current chunk of data to stack
    [self.responseData appendData:data];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.downloadProgressBlock) {
            self.downloadProgressBlock([self.responseData length], self.responseExpectedLength);
        }
    });
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *jsonError = nil;
    id response = self.responseData;
    if (self.isJsonResponse) {
        response = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:&jsonError];
    }
    
    // HTTP Status Code indicating an Error?
    if (self.responseStatusCode >= 400) {
        self.connectionError = [self errorWithCode:self.responseStatusCode localizedDescription:[self descriptionForHTTPStatus:self.responseStatusCode]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.errorBlock) {
                self.errorBlock(self.connectionError);
                return;
            }
        });
    }
    
    // JSON deserialization Error?
    if (jsonError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.errorBlock) {
                self.errorBlock(jsonError);
                return;
            }
        });
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.completionBlock) {
            self.completionBlock(self.responseHeaders, self.responseStatusCode, response);
        }
    });
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.uploadProgressBlock) {
            self.uploadProgressBlock(totalBytesWritten, totalBytesExpectedToWrite);
        }
    });
}

#pragma mark - Helper Methods
- (NSURL *)urlByAddingCredentials:(NSURLCredential *)credentials toURL:(NSURL *)url
{
    
    if(!credentials) {
        return nil;
    }
    
    NSString *scheme = [url scheme];
    NSString *host = [url host];
    BOOL hostAlreadyContainsCredentials = ([host rangeOfString:@"@"].location != NSNotFound);
    if (hostAlreadyContainsCredentials) {
        return url;
    }
    
    NSMutableString *resourceSpecifier = [[url resourceSpecifier] mutableCopy];
    if(![resourceSpecifier hasPrefix:@"//"]) {
        return nil;
    }
    
    NSString *userPassword = [NSString stringWithFormat:@"%@:%@@", credentials.user, credentials.password];
    [resourceSpecifier insertString:userPassword atIndex:2];
    NSString *urlString = [NSString stringWithFormat:@"%@:%@", scheme, resourceSpecifier];
    return [NSURL URLWithString:urlString];
}

- (NSString *)stringWithData:(NSData *)data encodingName:(NSString *)encodingName
{
    if(!data) {
        return nil;
    }

    NSStringEncoding encoding = NSUTF8StringEncoding;
    if(encodingName != nil) {
        encoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((CFStringRef)encodingName));
        if(encoding == kCFStringEncodingInvalidId) {
            encoding = NSUTF8StringEncoding;
        }
    }
    
    return [[NSString alloc] initWithData:data encoding:encoding];
}

- (NSString *)descriptionForHTTPStatus:(NSUInteger)status
{
    NSString *statusString = [NSString stringWithFormat:@"HTTP Status %@", @(status)];
    NSString *description = kHttpStatusCodes[[NSNumber numberWithInteger:status]];
    if(description) {
        statusString = [statusString stringByAppendingFormat:@": %@", description];
    }
    
    return statusString;
}

@end

#pragma mark - Categories

@implementation NSData (BKTSBase64)

- (NSString *)bkts_base64Encoding;
{
	if ([self length] == 0) {
		return @"";
    }
    
    char *characters = malloc((([self length] + 2) / 3) * 4);
	if (characters == NULL) {
		return nil;
    }
    
	NSUInteger length = 0;
	NSUInteger i = 0;
	while (i < [self length]) {
		char buffer[3] = {0,0,0};
		short bufferLength = 0;
		while (bufferLength < 3 && i < [self length])
			buffer[bufferLength++] = ((char *)[self bytes])[i++];
        
		//  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
		characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
		characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
		if (bufferLength > 1)
			characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
		else characters[length++] = '=';
		if (bufferLength > 2)
			characters[length++] = encodingTable[buffer[2] & 0x3F];
		else characters[length++] = '=';
	}
    
	return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

@end
