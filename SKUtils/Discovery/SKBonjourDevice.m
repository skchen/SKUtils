//
//  SKBonjourDevice.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/6/20.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKBonjourDevice.h"

#include <arpa/inet.h>

static NSString * const kKeyIp = @"ip";
static NSString * const kKeyPort = @"port";

@implementation SKBonjourDevice

- (nonnull instancetype)initWithNetService:(NSNetService *)netService {
    self = [super init];
    [self parseIpAndPort:netService];
    return self;
}

- (void)parseIpAndPort:(NSNetService *)service {
    char addressBuffer[INET6_ADDRSTRLEN];
    
    for (NSData *data in service.addresses) {
        memset(addressBuffer, 0, INET6_ADDRSTRLEN);
        
        typedef union {
            struct sockaddr sa;
            struct sockaddr_in ipv4;
            struct sockaddr_in6 ipv6;
        } ip_socket_address;
        
        ip_socket_address *socketAddress = (ip_socket_address *)[data bytes];
        
        if(socketAddress) {
            if(socketAddress->sa.sa_family == AF_INET) {    // IPv4
                const char *addressStr = inet_ntop(
                                                   socketAddress->sa.sa_family,
                                                   (void *)&(socketAddress->ipv4.sin_addr),
                                                   addressBuffer,
                                                   sizeof(addressBuffer));
                
                _ip = [NSString stringWithUTF8String:addressStr];
                _port = ntohs(socketAddress->ipv4.sin_port);
                break;
            } else if(socketAddress->sa.sa_family == AF_INET6) {    // IPv6
                const char *addressStr = inet_ntop(
                                                   socketAddress->sa.sa_family,
                                                   (void *)&(socketAddress->ipv6.sin6_addr),
                                                   addressBuffer,
                                                   sizeof(addressBuffer));
                
                _ip = [NSString stringWithUTF8String:addressStr];
                _port = ntohs(socketAddress->ipv6.sin6_port);
            }
        }
    }
}

- (BOOL)isEqual:(id)object {
    if([object isKindOfClass:[SKBonjourDevice class]]) {
        SKBonjourDevice *rightHandSide = (SKBonjourDevice *)object;
        
        if(![_ip isEqual:rightHandSide.ip]) return NO;
        if(_port!=rightHandSide.port) return NO;
        
        return YES;
    }
    
    return NO;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    _ip = [decoder decodeObjectForKey:kKeyIp];
    _port = [[decoder decodeObjectForKey:kKeyPort] intValue];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_ip forKey:kKeyIp];
    [encoder encodeObject:@(_port) forKey:kKeyPort];
}

@end
