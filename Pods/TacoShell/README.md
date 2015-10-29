![TacoShell](http://www.burritokit.com/img/tacoshell.png)

# TacoShell

[![CI Status](http://img.shields.io/travis/BurritoKit/TacoShell.svg?style=flat)](https://travis-ci.org/BurritoKit/TacoShell)
[![Version](https://img.shields.io/cocoapods/v/TacoShell.svg?style=flat)](http://cocoadocs.org/docsets/TacoShell)
[![License](https://img.shields.io/cocoapods/l/TacoShell.svg?style=flat)](http://cocoadocs.org/docsets/TacoShell)
[![Platform](https://img.shields.io/cocoapods/p/TacoShell.svg?style=flat)](http://cocoadocs.org/docsets/TacoShell)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first. For futher documentation, please visit the [CocoaDocs Page](http://cocoadocs.org/docsets/TacoShell).

Using *TacoShell* a `GET` request is simple as this:

```objective-c
TacoShell *ts = [[TacoShell alloc] initWithURL:[NSURL URLWithString:@"http://guacamole.burritokit.com/"]];
ts.completionBlock = ^(NSDictionary *dictionary, NSInteger httpResponseStatusCode, id response){
	NSLog(@"Your IP Address is: %@", response[@"meta"][@"ip"]);
};
[ts start];
```
That's it! *TacoShell* automatically deserialized JSON responses if the respective `Content-Type` contains `application/json`.

To perform a `POST` request using `multipart/form-data` just pass in the desired fields into the `POSTDictionary`:

```objective-c
...
ts.method = BKTSRequestMethodPOST;
ts.POSTDictionary = @{"username": "karl"};
...
```
When no `Content-Type` is specified, and the `POSTDictionary` is set, the `Content-Type` will default to `multipart/form-data`.

If you'd like to `POST` the `POSTDictionary` as `JSON` in the `Body` then just set the `Content-Type` to `BKTSRequestContentTypeApplicationJSON` like so:

```objective-c
...
ts.contentType = BKTSRequestContentTypeApplicationJSON;
...
```

Easy, isn't it?

## Requirements

* CocoaPods

## Installation

TacoShell is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "TacoShell"

## Author

Marcus Kida, marcus@kida.io

## License

TacoShell is available under the MIT license. See the LICENSE file for more info.
