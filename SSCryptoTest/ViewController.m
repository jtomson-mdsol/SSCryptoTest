//
//  ViewController.m
//  SSCryptoTest
//
//  Created by James Tomson on 6/12/15.
//  Copyright (c) 2015 Medidata Solutions, Inc. All rights reserved.
//

#import "ViewController.h"
#import <SSCrypto.h>
#import <MF_Base64Additions.h>

#include "crypto.h"

@interface ViewController ()
@property (nonatomic) SSCrypto *crypto;
@property NSString *key;
@property NSData *cipherData;
@property NSString *plainText;

+ (NSString *)generateKey;
@end

@implementation ViewController

+ (NSString *)generateKey {

    // generate a random key
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:20];
    for (NSUInteger i = 0U; i < 20; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    return [s copy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self doEncrypt];
    [self doDecrypt];
    
}

- (void)doDecrypt {
    
    /*
     ENCODE:
     OpenSSL version: OpenSSL 1.0.1j 15 Oct 2014
     key: I3z1h5l8eH5OEwMxFlEx
     plainText: this is the plaintext
     ciphertext: dJQKg9H82wKWeicnJE7XyEKfa78RzmO0oSTmNXGMNkQ=
     */
    
    self.key = @"I3z1h5l8eH5OEwMxFlEx";
    self.cipherData = [NSData dataWithBase64String:@"dJQKg9H82wKWeicnJE7XyEKfa78RzmO0oSTmNXGMNkQ="];
    self.crypto = [[SSCrypto alloc] initWithSymmetricKey:[self.key dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self.crypto setCipherText:self.cipherData];

    
    NSData *plainData = [self.crypto decrypt:@"aes256"];
    self.plainText = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];

    NSLog(@"\nDECODE:\n"
          "OpenSSL version: %@\n"
          "key: %@\n"
          "plainText: %@\n"
          "ciphertext: %@\n",
          @(SSLeay_version(SSLEAY_VERSION)),
          self.key,
          self.plainText,
          [self.cipherData base64String]);
}

- (void)doEncrypt {
    self.plainText = @"this is the plaintext";
    self.key = [ViewController generateKey];
    
    self.crypto = [[SSCrypto alloc] initWithSymmetricKey:[self.key dataUsingEncoding:NSUTF8StringEncoding]];
    [self.crypto setClearTextWithData:[self.plainText dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.cipherData = [self.crypto encrypt:@"aes256"];
    
    NSLog(@"\nENCODE:\n"
          "OpenSSL version: %@\n"
          "key: %@\n"
          "plainText: %@\n"
          "ciphertext: %@\n",
          @(SSLeay_version(SSLEAY_VERSION)),
          self.key,
          self.plainText,
          [self.cipherData base64String]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
