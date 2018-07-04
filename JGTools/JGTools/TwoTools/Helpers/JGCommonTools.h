//
//  JGCommonTools.h
//  ZJBL-SJ
//
//  Created by 郭军 on 2017/3/20.
//  Copyright © 2017年 ZJNY. All rights reserved.
//

#import <Foundation/Foundation.h>
//控制器
#import "QJBaseTabbarController.h"
#import "QJTextView.h"


typedef NS_ENUM(NSInteger, ArbitraryCornerRadiusViewType) {
    /** 默认全角 */
    ArbitraryCornerRadiusViewTypeDefault = 0,
    /** 左上角 */
    ArbitraryCornerRadiusViewTypeTopLeft = 1,
    /** 右上角 */
    ArbitraryCornerRadiusViewTypeTopRight = 2,
    /** 左下角 */
    ArbitraryCornerRadiusViewTypeBottomLeft = 3,
    /** 右下角 */
    ArbitraryCornerRadiusViewTypeBottomRight = 4,
    /** 左上角和右上角 */
    ArbitraryCornerRadiusViewTypeTopLeftTopRight = 5,
    /** 左上角和左下角 */
    ArbitraryCornerRadiusViewTypeTopLeftBottomLeft = 6,
    /** 左上角和右下角 */
    ArbitraryCornerRadiusViewTypeTopLeftBottomRight = 7,
    /** 右上角和左下角 */
    ArbitraryCornerRadiusViewTypeTopRightBottomLeft = 8,
    /** 右上角和右下角 */
    ArbitraryCornerRadiusViewTypeTopRightBottomRight = 9,
    /** 左下角和右下角 */
    ArbitraryCornerRadiusViewTypeBottomLeftBottomRight = 10,
    /** 左上角和右上角和左下角 */
    ArbitraryCornerRadiusViewTypeTopLeftTopRightBottomLeft = 11,
    /** 左上角和右上角和右下角 */
    ArbitraryCornerRadiusViewTypeTopLeftTopRightBottomRight = 12,
    /** 左上角和左下角和右下角 */
    ArbitraryCornerRadiusViewTypeTopLeftBottomLeftBottomRight = 13,
    /** 右上角和左下角和右下角 */
    ArbitraryCornerRadiusViewTypeTopRightBottomLeftBottomRight = 14,
};

@interface JGCommonTools : NSObject

/**********************  公共方法  *************************/
/**
 配置 label 的圆角颜色
 
 @param view 要配置的 view
 @param backgroundColor  背景颜色
 @param cornerRadius 圆角大小
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 */
+ (void)configPropertyWithView:(UIView *)view backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 视图切任意方向圆角
 
 @param view 要切圆角的视图
 @param cornerRadius 圆角大小
 @param type 圆角类型
 */
+ (void)configArbitraryCornerRadiusView:(UIView *)view cornerRadius:(CGFloat)cornerRadius withType:(ArbitraryCornerRadiusViewType)type;

/**********************  label 相关  *************************/
/**
 配置 label 的属性
 
 @param label 要配置的 label
 @param font  字体大小
 @param color 字体颜色
 @param textAlignment 文字对齐方式
 */
+ (void)configPropertyWithLabel:(UILabel *)label font:(CGFloat)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment numberOfLine:(CGFloat)numberOfLine;

/**
 配置 label 的行间距
 
 @param label 要配置的 label
 @param font 要配置的 label 的字体大小
 @param lineSpace  行间距
 @param maxWidth 要展示的最大宽度
 */
+ (void)configPropertyWithLabel:(UILabel *)label font:(CGFloat)font lineSpace:(CGFloat)lineSpace maxWidth:(CGFloat)maxWidth;

/**
 设置行间距的前提下的 label 高度
 
 @param label 要获取的 label
 @param font  字体大小
 @param lineSpace 行间距
 @param maxWidth 最大显示宽度
 @return 要展示的 label 的高度
 */
+ (CGFloat)getHeightWithLabel:(UILabel *)label font:(CGFloat)font lineSpace:(CGFloat)lineSpace maxWidth:(CGFloat)maxWidth;

/**
 获取 label 单行显示的时候需要的宽度
 
 @param label 要获取的 label
 @param font  字体大小
 @return 宽度
 */
+ (CGFloat)getWidthWithLabel:(UILabel *)label font:(CGFloat)font;

/**********************  button 相关  *************************/
/**
 配置按钮的文字
 
 @param button 要配置的按钮
 @param title 按钮显示的文字
 @param titleColor 文字的颜色
 @param font 文字的大小
 */
+ (void)configPropertyWithButton:(UIButton *)button title:(NSString *)title titleColor:(UIColor *)titleColor titleLabelFont:(CGFloat)font;

/**
 配置按钮背景图片
 
 @param button 要配置的按钮
 @param normalBackgroundImage 普通状态下的按钮背景图片
 @param highlightBackgroundImage 高亮状态下的按钮图片
 */
+ (void)configPropertyWithButton:(UIButton *)button normalBackgroundImage:(NSString *)normalBackgroundImage highlightBackgroundImage:(NSString *)highlightBackgroundImage;

/**********************  textField 相关  *************************/
/**
 配置 textField 输入框
 
 @param textField 要配置的 textField
 @param textFont 字体大小
 @param textColor 字体颜色
 @param placeHolder 占位文字
 @param textPlaceHolderFont 占位文字大小
 @param textPlaceHolderTextColor 占位文字颜色
 @param textAlignment 字体对齐方式
 */
+ (void)configPropertyWithTextField:(UITextField *)textField textFont:(CGFloat)textFont textColor:(UIColor *)textColor textPlaceHolder:(NSString *)placeHolder textPlaceHolderFont:(CGFloat)textPlaceHolderFont textPlaceHolderTextColor:(UIColor *)textPlaceHolderTextColor textAlignment:(NSTextAlignment)textAlignment;


/**
 配置带有占位文字包含字体间距的 textView
 
 @param textView  要配置的 textView
 @param textFont textView 字体大小
 @param textColor textView 字体颜色
 @param lineSpace textView 行间距
 @param placeHolder textView 占位文字
 @param textPlaceHolderFont textView 占位文字大小
 @param textPlaceHolderTextColor textView 占位文字颜色
 @param textAlignment 文字对齐方式
 */
+ (void)configPropertyWithTextView:(QJTextView *)textView textFont:(CGFloat)textFont textColor:(UIColor *)textColor lineSpace:(CGFloat)lineSpace textPlaceHolder:(NSString *)placeHolder textPlaceHolderFont:(CGFloat)textPlaceHolderFont textPlaceHolderTextColor:(UIColor *)textPlaceHolderTextColor textAlignment:(NSTextAlignment)textAlignment;


#pragma mark - 计算行高 -
// 通过给定文字和字体大小在指定的最大宽度下，计算文字实际所占的尺寸
+ (CGSize)sizeForLblContent:(NSString *)strContent fixMaxWidth:(CGFloat)w andFondSize:(int)fontSize;


/*!
 * @brief json格式字符串转数组
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+  (id)toArrayWithJsonString:(NSString *)jsonString;

#pragma mark - 把格式化的JSON格式的字符串转换成字典 -
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/*!
 * @brief 把字典转换成JSON
 * @param dict 字典
 * @return 返回JSON
 */
+ (NSString *)convertToJsonData:(NSDictionary *)dict;



#pragma mark - 判断网络状态
+ (BOOL)isNetWorkReachable;


#pragma mark - 沙盒相关 -
// 往沙盒中存数据
+ (void)saveToUserDefaults:(id)object key:(NSString *)key;
//从沙盒中取数据
+ (id)getUserDefaultsWithKey:(NSString *)key;

+ (NSString *)get1970timeString;

//获取当前时间戳  精确到毫秒
+ (NSString *)currentTimeStr;


/**
 获取当前时间戳

 @return 当前时间戳
 */
+ (long )getCurrentTimeInterval;

/**
 根据传入的时间戳返回N月后的时间戳

 @param timeStamp 传入的时间戳
 @param month N月
 @return N月后的时间戳
 */
+(long )getPriousorLaterDateFromDate:(long )timeStamp withMonth:(int)month;


#pragma mark - MD5加密 -
+ (NSString *)md5String:(NSString *)str;


/**
 根据UIlabel的文字获取删除线

 @param LblText UIlabel上的文字
 @return 删除线
 */
+ (NSMutableAttributedString *)getDeleteLineWithString:(NSString *)LblText;


/**
 从像素px转换为ios的点阵pt
 */
+(CGFloat)pxTopt:(CGFloat)pt;


//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;

/** 根据图片二进制流获取图片格式 */
+ (NSString *)imageTypeWithData:(NSData *)data;


#pragma mark - 窗口的跟控制器
+ (QJBaseTabbarController *)sharedTabbarController;


//时间戳转换日期 formatter:格式
+ (NSString *)timeWithTimeIntervalString:(long )time dateFormatter:(NSString *)formatter;

//请求下拉加载更多结束数据 提示语
+ (NSString *)TheEndOfTheData;


//红包类型 10 购物鼓励金红包  11 拼手气鼓励金红包
//12 好友赠送红包 13 好友赠送红包  2 补贴卡
+ (NSString *)getTypeWithRedpacketType:(int)redpacket_type;

/**
 通过银行卡名字获取银行卡图标

 @param bankTitle 银行卡名字
 @return 银行卡图标
 */
+ (NSString *)getBankIconWithBankName:(NSString *)bankTitle;

//判断一个字符串中是否都是数字
+ (BOOL)isAllNum:(NSString *)string;


//iOS 解决打电话反应慢的问题（换一种方式）
+ (void)callPhoneStr:(NSString*)phoneStr  withVC:(UIViewController *)selfvc;

@end
