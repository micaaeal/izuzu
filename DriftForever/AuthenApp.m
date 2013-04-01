//
//  AuthenViewController.m
//  DriftForever
//
//  Created by Adawat Chanchua on 4/1/56 BE.
//
//

#import "AuthenApp.h"
#import "SBJSON.h"

@interface AuthenApp ()

@property (retain) NSMutableData* data;

@end

@implementation AuthenApp

- (id) init
{
    self    = [super init];
    if (self)
    {
        _data   = [[NSMutableData alloc] init];
    }
    return self;
}

- (void) dealloc
{
    [_data release];
    _data   = nil;
    
    [super dealloc];
}

- (void) startAppAuthen
{
    NSString *post = @"product_key=isuzu_ios";
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:@"https://spur-gears.appspot.com/api/dp_check"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString* str   = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    printf ("str: %s", [str UTF8String]);
    printf ("\n");
    
    if ( _delegate )
    {
        SBJsonParser* parser    = [[SBJsonParser alloc] init];
        id jsonObj  = [parser objectWithString:str];
        
        if ( [jsonObj isKindOfClass:[NSDictionary class]] )
        {
            
            NSDictionary* jsonDict  = (NSDictionary*)jsonObj;
            NSString* message       = [jsonDict objectForKey:@"message"];
            NSString* result        = [jsonDict objectForKey:@"result"];
            
            if ( [result isEqualToString:@"fail"] )
            {
                [_delegate onAuthenFailed:self];
                
                // alert
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
                [alert show];
                [alert release];
                alert   = nil;
            }
            else
            {
                [_delegate onAuthenSuccess:self];
            }
            
        }
        
        [parser release];
        parser  = nil;
    }
    
    [str release];
    str = nil;
    
}

@end
