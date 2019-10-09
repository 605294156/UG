//
//  SocketManager.m
//  digitalCurrency
//
//  Created by sunliang on 2018/4/9.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "SocketManager.h"
#import "SocketUtils.h"
static  NSString * s_host = @"13.125.234.204";
//static  NSString * s_host = @"13.125.234.204";//币呗
//static  NSString * s_host = @"47.74.212.105";//测试
//static  NSString * s_host = @"47.75.42.199";//cayman
//static  NSString * s_host = @"47.75.144.65";//ATC
//static  NSString * s_host = @"54.169.253.210";//数交所
static const uint16_t s_port = 28901;
#define kMaxReconnection_time 5//异常中断时，重连次数
/*
 socket断开连接后，为了不给服务器造成连接压力，必须控制重新连接的频率。否则一旦服务器出现异常，而客户端又不断向服务器发送连接请求，势必会给服务器雪上加霜，甚至出现崩溃的情况！所以限制重连次数
 */
@interface SocketManager()<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *gcdSocket;
    int _reconnection_time;//重连次数
    NSTimer*_timer;
}
@property (nonatomic, strong) NSMutableData *readBuf;// 缓冲区
@property (nonatomic, retain) NSTimer        *connectTimer; // 心跳包计时器

@end
@implementation SocketManager

+ (instancetype)share
{
    static dispatch_once_t onceToken;
    static SocketManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        [instance initSocket];
    });
    return instance;
}
- (void)initSocket
{
    gcdSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}
//建立连接
- (BOOL)connect
{
    return  [gcdSocket connectToHost:s_host onPort:s_port error:nil];
}

//主动断开连接
- (void)disConnect
{
    [gcdSocket disconnect];
    gcdSocket=nil;
    [_timer invalidate];
    _timer=nil;
    [self.connectTimer invalidate];
    self.connectTimer=nil;
}
//发送消息
- (void)sendMsgWithLength:(int)length withsequenceId:(long)sequenceId withcmd:(short)cmd withVersion:(int)Version withRequestId:(int)RequestId withbody:(NSDictionary*)jsonDict{
    NSString* Terminal=SOCKETTERMINAL;//4字节
    NSMutableData*Data = [[NSMutableData alloc]init];
    NSError *error = nil;
    if ([jsonDict isKindOfClass:[NSDictionary class]] ) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&error];
        
        if ([jsonData length] > 0 &&error == nil)
        {
            [Data appendData:[SocketUtils bytesFromUInt32:(length+(int)jsonData.length)]];
        }else{
            [Data appendData:[SocketUtils bytesFromUInt32:length]];//4个字节
        }
        [Data appendData:[SocketUtils bytesFromUInt64:sequenceId]];//8个字节.token
        [Data appendData:[SocketUtils bytesFromUInt16:cmd]];//2字节
        [Data appendData:[SocketUtils bytesFromUInt32:Version]]; //4字节
        [Data appendData:[SocketUtils dataFromString:Terminal]];//4字节
        [Data appendData:[SocketUtils bytesFromUInt32:RequestId]];//4字节，标签
        [Data appendData:jsonData];
    }else{
        [Data appendData:[SocketUtils bytesFromUInt32:length]];//4个字节
        [Data appendData:[SocketUtils bytesFromUInt64:sequenceId]];//8个字节.token
        [Data appendData:[SocketUtils bytesFromUInt16:cmd]];//2字节
        [Data appendData:[SocketUtils bytesFromUInt32:Version]]; //4字节
        [Data appendData:[SocketUtils dataFromString:Terminal]];//4字节
        [Data appendData:[SocketUtils bytesFromUInt32:RequestId]];//4字节，标签
    }
    
    [gcdSocket writeData:Data withTimeout:-1 tag:0];
}
#pragma mark - GCDAsynSocket Delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"行情socket连接成功");
    // 存储接收数据的缓存区，处理数据的粘包和断包
    _readBuf = [[NSMutableData alloc] init];
    [gcdSocket readDataWithTimeout:-1 tag:0];
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
    [self.connectTimer fire];
}
// 心跳连接
-(void)longConnectToSocket{
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:HEARTBEAT withVersion:COMMANDS_VERSION withRequestId: 0 withbody:nil];
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"发送指令");
}
//收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    [self didReadData:data withTag:tag];

}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"交易类socket断开连接");
    //[APPLICATION.window ug_showToastWithToast:@"交易类socket断开连接"];
    if(_reconnection_time>=0&&_reconnection_time<=kMaxReconnection_time)
    {
        [_timer invalidate];
        _timer=nil;
        int time = 2;//设置重连时间
        _timer= [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(reconnection) userInfo:nil repeats:NO];
        _reconnection_time++;
    }else{
        _reconnection_time=0;
    }
}
//重连
-(void)reconnection{
    [gcdSocket connectToHost:s_host onPort:s_port error:nil];
}


- (void)didReadData:(NSData *)data withTag:(long)tag{
    //    //将接收到的数据保存到缓存数据中
    [_readBuf appendData:data];
    while (_readBuf.length >= 22)//因为头部固定22个字节，数据长度至少要大于22个字节，我们才能得到完整的消息描述信息
    {
        NSData *head = [_readBuf subdataWithRange:NSMakeRange(0, 22)];//取得头部数据
        NSData *lengthData = [head subdataWithRange:NSMakeRange(0, 4)];//取得长度数据
        NSInteger length = CFSwapInt32BigToHost(*(int*)([lengthData bytes]));
        if (length <= 22) {
            DLog(@"####包长度不够返回了#####");
            return;
        }
        NSInteger complateDataLength = length ;//算出一个包完整的长度(内容长度＋头长度)
//        DLog(@"完整长度complateDataLength&%ld-----缓存区长度_readBuf&%lu",(long)complateDataLength,(unsigned long)_readBuf.length);
        
        if (_readBuf.length >= complateDataLength)//如果缓存中数据够一个整包的长度
        {
            if (_readBuf.length > complateDataLength) {
                DLog(@"超出一个包 complateDataLength&%ld-----缓存区长度_readBuf&%lu",(long)complateDataLength,(unsigned long)_readBuf.length);
            }
            DLog(@"一个包");
            NSData *data = [_readBuf subdataWithRange:NSMakeRange(0, complateDataLength)];//截取一个包的长度(处理粘包)
            [self handleTcpResponseData:data withTag:tag];//处理包数据
            //从缓存中截掉处理完的数据,继续循环
            _readBuf = [NSMutableData dataWithData:[_readBuf subdataWithRange:NSMakeRange(complateDataLength, _readBuf.length - complateDataLength)]];
        }
        else//如果缓存中的数据长度不够一个包的长度，则包不完整(处理半包，继续读取)
        {
            DLog(@"不够一个包！！！！！  complateDataLength&%ld-----缓存区长度_readBuf&%lu",(long)complateDataLength,(unsigned long)_readBuf.length);
            [gcdSocket readDataWithTimeout:-1 tag:tag];//继续读取数据
            break;
        }
    }
    [gcdSocket readDataWithTimeout:-1 tag:tag];
    
    
}
-(void)handleTcpResponseData:(NSData*)data withTag:(long)tag{
    
    // 处理接收到服务器的数据data
    if (_delegate && [_delegate respondsToSelector:@selector(delegateSocket:didReadData:withTag:)]) {
        [_delegate delegateSocket:gcdSocket didReadData:data withTag:tag];
    }
    
}


@end
