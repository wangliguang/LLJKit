//
//  LLJMacro.h
//  Example
//
//  Created by B.Dog on 16/5/3.
//  Copyright © 2016年 JKSoft. All rights reserved.
//

#ifndef LLJMacro_h
#define LLJMacro_h


//
#pragma mark - Log
/*
 XCode LLVM XXX - Preprocessing中Debug会添加 DEBUG=1 标志
 */
#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif


//
#pragma mark - Screen
/**
 *  主屏幕的尺寸
 */
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_SIZE   [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
/**
 *  屏幕的分辨率 当结果为1时，显示的是普通屏幕，结果为2时，显示的是Retian屏幕
 */
#define SCREEN_SCALE  [UIScreen mainScreen].scale

//
#pragma mark - UI
/**
 *  获取图片
 */
//#define IMAGENAMED(NAME) [UIImage imageNamed:NAME]
/**
 *  获取RGB
 */
//#define RGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
/**
 *  随机色
 */
//#define RANDOM_COLOR ([UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1])

//
#pragma mark - 其他
/**
 *  沙盒路径
 */
#define kPathOfDocuments [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

#endif /* LLJMacro_h */
