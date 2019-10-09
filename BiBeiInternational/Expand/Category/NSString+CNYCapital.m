//
//  NSString+CNYCapital.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/13.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "NSString+CNYCapital.h"

@implementation NSString (CNYCapital)

//数字金额转大写
-(NSString *)changetochinese
{
    if (self.length == 0) {
        return @"";
    }
    
    double numberals=[self doubleValue];
    
    NSArray *numberchar = @[@"零",@"壹",@"贰",@"叁",@"肆",@"伍",@"陆",@"柒",@"捌",@"玖"];
    
    NSArray *inunitchar = @[@"",@"拾",@"佰",@"仟"];
    
    NSArray *unitname = @[@"",@"万",@"亿",@"万亿"];
    
    //金额乘以100转换成字符串（去除圆角分数值）
    
    NSString *valstr=[NSString stringWithFormat:@"%.2f",numberals];
    
    NSString *prefix;
    
    NSString *suffix;
    
    if (valstr.length<=2) {
        
        prefix=@"零元";
        
        if (valstr.length==0) {
            
            suffix=@"零角零分";
            
        }
        
        else if (valstr.length==1)
            
        {
            
            suffix=[NSString stringWithFormat:@"%@分",[numberchar objectAtIndex:[valstr intValue]]];
            
        }
        
        else
            
        {
            
            NSString *head=[valstr substringToIndex:1];
            
            NSString *foot=[valstr substringFromIndex:1];
            
            suffix=[NSString stringWithFormat:@"%@角%@分",[numberchar objectAtIndex:[head intValue]],[numberchar objectAtIndex:[foot intValue]]];
            
        }
        
    }
    
    else
        
    {
        
        prefix=@"";
        
        suffix=@"";
        
        NSInteger flag=valstr.length-2;
        
        NSString *head=[valstr substringToIndex:flag-1];
        
        NSString *foot=[valstr substringFromIndex:flag];
        
        if (head.length>13) {
            
            return@"数值太大（最大支持13位整数），无法处理";
            
        }
        if ([head isEqualToString:@"0"]) {
            
        }else {
            //处理整数部分
            
            NSMutableArray *ch=[[NSMutableArray alloc]init];
            
            for (int i = 0; i < head.length; i++) {
                
                NSString * str=[NSString stringWithFormat:@"%x",[head characterAtIndex:i]-'0'];
                
                [ch addObject:str];
                
            }
            
            int zeronum=0;
            
            
            
            for (int i=0; i<ch.count; i++) {
                
                int index=(ch.count -i-1)%4;//取段内位置
                
                NSInteger indexloc=(ch.count -i-1)/4;//取段位置
                
                if ([[ch objectAtIndex:i] isEqualToString:@"0"]) {
                    
                    zeronum++;
                    
                }
                
                else
                    
                {
                    
                    if (zeronum!=0) {
                        
                        if (index!=3) {
                            
                            prefix=[prefix stringByAppendingString:@"零"];
                            
                        }
                        
                        zeronum=0;
                        
                    }
                    
                    prefix=[prefix stringByAppendingString:[numberchar objectAtIndex:[[ch objectAtIndex:i]intValue]]];
                    
                    prefix=[prefix stringByAppendingString:[inunitchar objectAtIndex:index]];
                    
                }
                
                if (index ==0 && zeronum<4) {
                    
                    prefix=[prefix stringByAppendingString:[unitname objectAtIndex:indexloc]];
                    
                }
                
            }
            
            prefix =[prefix stringByAppendingString:@"元"];
        }
        
        
        //处理小数位
        
        if ([foot isEqualToString:@"00"]) {
            if ([head isEqualToString:@"0"]) {
                
            }else {
                suffix =[suffix stringByAppendingString:@"整"];
            }
            
            
        }else if ([foot hasPrefix:@"0"]) {
            
            NSString *footch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:1]-'0'];
            
            suffix=[NSString stringWithFormat:@"%@分",[numberchar objectAtIndex:[footch intValue] ]];
            
        }else {
            NSString *headch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:0]-'0'];
            
            NSString *footch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:1]-'0'];
            if ([footch isEqualToString:@"0"]) {
                suffix=[NSString stringWithFormat:@"%@角",[numberchar objectAtIndex:[headch intValue]]];
            }else {
                suffix=[NSString stringWithFormat:@"%@角%@分",[numberchar objectAtIndex:[headch intValue]],[numberchar objectAtIndex:[footch intValue]]];
            }
            
            
        }
        
    }
    
    return [prefix stringByAppendingString:suffix];
    
}


@end
