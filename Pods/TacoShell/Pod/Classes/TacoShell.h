//
//  TacoShell.h
//  Pods
//
//  Created by Marcus Kida on 26/07/2014.
//
//

#import <Foundation/Foundation.h>

/**
 *  Supported HTTP Method Types
 */
typedef NS_ENUM(NSInteger, BKTSRequestMethod) {
    /**
     *  HTTP GET
     */
    BKTSRequestMethodGET,
    /**
     *  HTTP HEAD
     */
    BKTSRequestMethodHEAD,
    /**
     *  HTTP PUT
     */
    BKTSRequestMethodPUT,
    /**
     *  HTTP POST
     */
    BKTSRequestMethodPOST,
    /**
     *  HTTP DELETE
     */
    BKTSRequestMethodDELETE
};

/**
 *  Supported HTTP Content-Types
 */
typedef NS_ENUM(NSInteger, BKTSRequestContentType) {
    /**
     *  No Content-Type set
     */
    BKTSRequestContentTypeNone,
    /**
     *  HTTP Content-Type `application/json`
     */
    BKTSRequestContentTypeApplicationJSON,
    /**
     *  HTTP Content-Type `multipart/form-data`
     */
    BKTSRequestContentTypeMultipartFormData,
    /**
     *  HTTP Content-Type `application/x-www-form-urlencoded`
     */
    BKTSRequestContentTypeFormUrlencoded,
    /**
     *  HTTP Content-Type `application/octet-stream`
     */
    BKTSRequestContentTypeApplicationOctetStream
};

/**
 *  Upload Progress Block, invoked whenever there is progress uploading the desired data.
 *
 *  @param written         Total bytes written in this connection.
 *  @param writtenTotal Expected number of overall bytes to be written.
 */
typedef void (^TSUploadProgressBlock)(NSInteger written, NSInteger writtenTotal);

/**
 *  Download Progress Block, invoked whenever there is a progress downloading the desired data.
 *
 *  @param received          Total bytes read in this connection.
 *  @param receivedTotal Expected nunmber of overall bytes to be read.
 */
typedef void (^TSDownloadProgressBlock)(NSUInteger received, long long receivedTotal);

/**
 *  Completion Block, invoked whenever the connection has completed.
 *
 *  @param headers The response headers.
 *  @param httpResponseStatusCode The HTTP Response Status Code
 *  @param response The response Object, either as NSData or, if response Content-Type contains `application/json`, as deserialized JSON Object.
 */
typedef void (^TSCompletionBlock)(NSDictionary *headers, NSInteger httpResponseStatusCode, id response);

/**
 *  Error Block, invoked whenever an error occurs.
 *
 *  @param error Error object describing the error.
 */
typedef void (^TSErrorBlock)(NSError *error);

/**
 *  The TacoShell super lightweight-NSURLConnection wrapper.
 */
@interface TacoShell : NSObject

/**
 *  Upload Progress Callback Block
 */
@property (copy) TSUploadProgressBlock uploadProgressBlock;

/**
 *  Download Progress Callback Block
 */
@property (copy) TSDownloadProgressBlock downloadProgressBlock;

/**
 *  Completion Callback Block
 */
@property (copy) TSCompletionBlock completionBlock;

/**
 *  Error Callback Block
 */
@property (copy) TSErrorBlock errorBlock;

/**
 *  The Endpoint URL
 */
@property (strong) NSURL *url;

/**
 *  Desired HTTP Method, default: BKTSRequestMethodGET
 */
@property (assign) BKTSRequestMethod method;

/**
 *  Desired HTTP Content-Mode, default: BKTSRequestContentTypeApplicationJSON
 */
@property (assign) BKTSRequestContentType contentType;

/**
 *  Desired NSURLRequestCachePolicy, default: NSURLRequestUseProtocolCachePolicy
 */
@property (assign) NSURLRequestCachePolicy cachePolicy;

/**
 *  HTTP Request Timeout, default: 30 seconds
 */
@property (assign) NSTimeInterval timeout;

/**
 *  Wether the client shall prevent (bail out at) redirects, default: NO
 */
@property (assign) BOOL preventRedirects;

/**
 *  POST Form fields, as NSDictionary.
 *  Overrides POSTData (if set).
 */
@property (strong) NSDictionary *POSTDictionary;

/**
 *  Raw POST Body Data, as NSData
 *  Will be overridden by POSTDictionary (in case it's set)
 */
@property (strong) NSData *POSTData;

/**
 *  Initializer for TacoShell, provide NSURL wit Endpoint.
 *
 *  @param url NSURL containing the desired Endpoint
 *
 *  @return An instance of TacoShell (or it's subclass)
 */
- (instancetype)initWithURL:(NSURL *)url;

/**
 *  Starts Network request (asynchronously)
 */
- (void)start;

/**
 *  Starts Network request (asynchronously) using provided Basic Auth credentials
 *
 *  @param username Basic Auth Username as NSString
 *  @param password Basic Auth Password as NSString
 */
- (void)startUsingBasicAuthUsername:(NSString *)username password:(NSString *)password;

/**
 *  Cancels running Network request.
 *  `errorBlock` will be invoked.
 */
- (void)cancel;

/**
 *  Set custom HTTP Request Headers
 *
 *  @param value NSString containing the HTTP Request Header's Value (e.g. Authentication)
 *  @param field NSString containing the HTTP Request Header's Name (e.g. Bearer XYZ)
 */
- (void)setHeaderValue:(NSString *)value headerField:(NSString *)field;

/**
 *  Removes Header for desired `Header Field`
 *
 *  @param field The Field name of whom's Header to remove
 */
- (void)removeHeaderValueForField:(NSString *)field;

@end
