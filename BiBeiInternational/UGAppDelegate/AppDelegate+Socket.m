//
//  AppDelegate+Socket.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/10.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "AppDelegate+Socket.h"

@implementation AppDelegate (Socket)

- (void)connectSocket {
    [[SocketManager share] connect];//连接行情socket
    [[ChatSocketManager share] connect];//连接聊天socket
    // [ChatSocketManager share].delegate=self;

}

- (void)sendSocketMesssageWithDeviceToken:(NSString *)deviceToken {
    if ([[UGManager shareInstance] hasLogged] && deviceToken.length > 0) {
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[UGManager shareInstance].hostInfo.ID, @"uid",deviceToken, @"token",nil];
        [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_APNS withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
        // [ChatSocketManager share].delegate=self;
    }
    
}

#pragma mark - SocketDelegate Delegate,点击icon进来会触发
- (void)ChatdelegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSData *endData = [data subdataWithRange:NSMakeRange(SOCKETRESPONSE_LENGTH, data.length -SOCKETRESPONSE_LENGTH)];
    NSString *endStr= [[NSString alloc] initWithData:endData encoding:NSUTF8StringEncoding];
    NSData *cmdData = [data subdataWithRange:NSMakeRange(12,2)];
    uint16_t cmd=[SocketUtils uint16FromBytes:cmdData];
    if (cmd==SUBSCRIBE_APNS) {
        NSLog(@"订阅APNS");
        
    }else if (cmd==UNSUBSCRIBE_APNS)
    {
        NSLog(@"取消订阅APNS");
    }
    else{
        // NSLog(@"聊天消息-%@--%d",endStr,cmd);
    }
    NSLog(@"APNS消息-%@--%d",endStr,cmd);
}


@end
