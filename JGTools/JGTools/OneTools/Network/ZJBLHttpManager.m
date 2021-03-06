//
//  ZJBLHttpManager.m
//  ZJBL-SJ
//
//  Created by 郭军 on 2017/3/17.
//  Copyright © 2017年 ZJNY. All rights reserved.
//

#import "ZJBLHttpManager.h"
#import "AFNetworking.h"
#import "ZJBLHttpBaseModel.h"


typedef enum : NSUInteger {
    POST,
    GET,
} ZJHttpMthod;


@implementation ZJBLHttpManager


/**
 *  Https请求证书设置
 *
 *  @return AFSecurityPolicy
 */

+ (AFSecurityPolicy *)customSecurityPolicy
{
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    NSSet *set = [NSSet setWithObject:certData];
    /**
     AFSecurityPolicy分三种验证模式：
     AFSSLPinningModeNone:只是验证证书是否在信任列表中
     AFSSLPinningModeCertificate：该模式会验证证书是否在信任列表中，然后再对比服务端证书和客户端证书是否一致
     AFSSLPinningModePublicKey：只验证服务端证书与客户端证书的公钥是否一致
     */
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 是否允许使用自签名证书
    [securityPolicy setAllowInvalidCertificates:YES];
    [securityPolicy setPinnedCertificates:set];
    return securityPolicy;
}


+ (AFHTTPSessionManager *)manager {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    
//    manager.requestSerializer.timeoutInterval = 5.f;//设置请求超时时间
//    
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    return manager;
}

/**
 *  广告页接口
 *
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)getADDataSuccess:(success)success
                 failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/getStartupImg",HTTPBaseUrl];
    [self HttpRequestWithHttpMthod:GET URLStr:urlStr parameters:nil progress:nil sueeess:success failure:failure];
}




#pragma mark - 首页 -
////////////////////////////////////////////////////////////////////////////
/********************************* 首页 ************************************/
////////////////////////////////////////////////////////////////////////////
/**
 *  首页商品请求。
 *
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)GetHomePageDataBuyNewSellerIndexSuccess:(success)success
                                        failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getNewSellerIndex",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  首页导航栏，左侧点击 -> 分级目录
 *
 *  @param category   请求链接的后半部分
 *  @param categoryId  分类ID
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)queryHomePageRequestWithLastUrlPartCategory:(NSString *)category
                                         CategoryId:(NSString *)categoryId
                                            success:(success)success
                                            failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/%@",HTTPBaseUrl,category];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (categoryId != nil && categoryId.length) {
        parameters[@"categoryId"] = categoryId;
    }else {
        parameters = nil;
    }
    [self HttpRequestWithHttpMthod:GET URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}



/**
 *  常购清单
 *
 *  @param startRow   起始行数
 *  @param endRow     结束行数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)GetOfenSalesListWithStartRow:(NSInteger)startRow
                              endRow:(NSInteger)endRow
                             success:(success)success
                             failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getOfenSalesList",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"startRow"] = @(startRow);
    parameters[@"endRow"] = @(endRow);
    parameters[@"token"] = TOKEN ;

    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  首页商品请求，品牌推荐 -> 加载更多
 *
 *  @param startRow   起始行数
 *  @param endRow     结束行数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)findHomePageAllBrandRequestWithCategoryidStartRow:(NSInteger)startRow
                                           endRow:(NSInteger)endRow
                                          success:(success)success
                                          failure:(failure)failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/getAllBrand",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"startRow"] = @(startRow);
    parameters[@"endRow"] = @(endRow);
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  首页商品请求，根据关键字查询产品
 *  -> 此接口包含三个部分（顶部搜索查询,首页通过品牌ID查询该品牌下的商品,最新精品更多 采购再去逛逛）
 *
 *  @param startRow   起始行数
 *  @param endRow     结束行数
 *  @param key        搜索关键字
 *  @param sort       排序字段
 *  @param order      排序方式
 *  @param brandId    品牌ID
 *  @param warehouseCode  仓库代码
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)queryAllRequestHomePageSearchWithKey:(NSString *)key
                                        Sort:(NSString *)sort
                                       Order:(NSString *)order
                                     BrandId:(NSString *)brandId
                               warehouseCode:(NSString *)warehouseCode
                                    StartRow:(NSInteger)startRow
                                      endRow:(NSInteger)endRow
                                     success:(success)success
                                     failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/searchGoodsByKey",HTTPBaseUrl];
    NSString *TokenStr = TOKEN;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (TokenStr != nil && TokenStr.length) parameters[@"token"] = TokenStr; //token
    if (key != nil && key.length) parameters[@"key"] = key; //关键字
    if (sort != nil && sort.length) parameters[@"sort"] = sort; //排序字段
    if (order != nil && order.length) parameters[@"order"] = order; //排序方式
    if (brandId != nil && brandId.length) parameters[@"brandId"] = brandId; //品牌ID
    if (warehouseCode != nil && warehouseCode.length) parameters[@"warehouseCode"] = warehouseCode; //仓库代码
    parameters[@"startRow"] = @(startRow);  //开始行
    parameters[@"endRow"] = @(endRow);  //结束行
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  首页分级商品请求，根根据目录查询目录下的商品
 *
 *  @param startRow   起始行数
 *  @param endRow     结束行数
 *  @param categoryId 分类ID
 *  @param sort       排序字段
 *  @param order      排序方式
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)queryHomePageGoodsAccordingToTheDirectoryByCategoetId:(NSString *)categoryId
                                                       plevel:(int)plevel
                                                         Sort:(NSString *)sort
                                                        Order:(NSString *)order
                                                     StartRow:(NSInteger)startRow
                                                       endRow:(NSInteger)endRow
                                                      success:(success)success
                                                      failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/findGoodsByCategory",HTTPBaseUrl];
    
    NSString *TokenStr = TOKEN;

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (TokenStr != nil && TokenStr.length) parameters[@"token"] = TokenStr; //token

    if (sort != nil && sort.length) parameters[@"sort"] = sort; //排序字段
    if (order != nil && order.length) parameters[@"order"] = order; //排序方式
    parameters[@"plevel"] = @(plevel); //一级目录或者二级目录
    parameters[@"categoryid"] = categoryId; //品牌ID
    parameters[@"startRow"] = @(startRow);  //开始行
    parameters[@"endRow"] = @(endRow);  //结束行
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  首页  获取商品详情
 *
 *  @param goodsId 商品ID
 *  @param promotionId 活动商品ID
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getGoodsDetilsRequestWithGoodsId:(NSString *)goodsId promotionId:(NSString *)promotionId success:(success)success failure:(failure)failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/sellerInOrder/getGoodsDetils",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goodsId"] = goodsId;
    parameters[@"promotionId"] = promotionId;
    parameters[@"token"] = TOKEN ;
//    NSString *urlString = [NSString stringWithFormat:@"%@/api/sellerInOrder/getGoodsDetils?goodsId=%@&token=%@",HTTPBaseUrl,goodsId,@"b5d95aed-81c5-4841-b64d-7360321825ad"];
    
    
    
    [self HttpRequestWithHttpMthod:GET URLStr:urlString parameters:parameters progress:nil sueeess:success failure:failure];
}



/**
 *  首页 -> 商品详情 -> 申请合作 -> 直接达成合作
 *
 *  @param mechanismId   供应商id
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)HomePageGoodsDetailApplyCooperationWithMechanismId:(NSString *)mechanismId
                                                   success:(success)success
                                                   failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/achieveCooperation",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"mechanismId"] = mechanismId;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  首页 -> 商品详情 -> 加入售货清单
 *
 *  @param goodsId   供应商id
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)HomePageGoodsDetailAddListWithGoodsId:(NSString *)goodsId
                                      success:(success)success
                                      failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/putInStorage",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"goodsId"] = goodsId;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


#pragma mark - 采购接口 -
/////////////////////////////////////////////////////////////////////////////////////
/************************************  采购接口  *************************************/
/////////////////////////////////////////////////////////////////////////////////////
/**
 * 创建订单前批量校验
 *
 *  @param buyInfo   商家购买的商品信息
 *  buyInfo说明 同一个仓库之间商品使用 | 分割 , 不同仓库之间使用 & 分割
 *  例如:
 *  ( 规格id,购买商品数量,商品价格,活动id,仓库代码1 | 规格id,购买商品数量,商品价格,活动id,仓库代码1
 *  & 规格id,购买商品数量,商品价格,活动id,仓库代码2 | 规格id,购买商品数量,商品价格,活动id,仓库代码2 )
 *  @param lat              纬度
 *  @param lng              经度
 */
+ (void)CreateInOrderBatchCheckWithBuyInfo:(NSString *)buyInfo
                                       Lat:(NSString *)lat
                                       Lng:(NSString *)lng
                                   success:(success)success
                                   failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/createInOrderBatchCheck",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"buyInfo"] = buyInfo;
    parameters[@"lat"] = lat;
    parameters[@"lng"] = lng;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 * 批量创建订单
 *
 * @param buyInfo           商家购买的商品信息
 *  buyInfo说明 同一个仓库之间商品使用 | 分割 , 不同仓库之间使用 & 分割
 *  例如:
 *  ( 规格id,购买商品数量,商品价格,活动id,仓库代码1 | 规格id,购买商品数量,商品价格,活动id,仓库代码1
 *  & 规格id,购买商品数量,商品价格,活动id,仓库代码2 | 规格id,购买商品数量,商品价格,活动id,仓库代码2 )
 *@param  orderInfo  订单详细信息
 * (仓库代码1,礼券code,礼券金额,业务人员id,备注 | 仓库代码2,礼券code,礼券金额,业务人员id,备注)
 * @param addressId  商家的收货地址Id
 *
 */
+ (void)CreateInOrderBatchWithBuyInfo:(NSString *)buyInfo
                            orderInfo:(NSString *)orderInfo
                            addressId:(NSString *)addressId
                              success:(success)success
                              failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/createInOrderBatch",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"buyInfo"] = buyInfo;
    parameters[@"orderInfo"] = orderInfo;
    parameters[@"addressId"] = addressId;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}



/**
 *  采购 --> 商品校验
 *
 *  @param buyInfo          购买的商品信息
 *  @param warehouseCode    仓库代码
 *  @param lat              纬度
 *  @param lng              经度
 *  @param success          成功回调
 *  @param failure          失败回调
 */
+ (void)PurchasesCheckGoodsCreateInOrderCheckWithBuyInfo:(NSString *)buyInfo
                                           warehouseCode:(NSString *)warehouseCode
                                                     Lat:(NSString *)lat
                                                     Lng:(NSString *)lng
                                                 success:(success)success
                                                 failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/createInOrderCheck",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"buyInfo"] = buyInfo;
    parameters[@"warehouseCode"] = warehouseCode;
    parameters[@"lat"] = lat;
    parameters[@"lng"] = lng;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  采购界面 --> 创建订单
 *  说明: 此处的 freeSign=0, freeSign=0
 *  @param buyInfo          购买的商品信息
 *  @param employeeId       业务员ID
 *  @param warehouseCode    仓库代码
 *  @param addressId        地址ID
 *  @param payChannel       支付渠道 : 0 未指定 ,1 支付宝 ,2 微信,3全余额支付
 *  @param freeSign         是否使用余额 0.不使用 1.使用
 *  @param remark           备注
 *  @param ladingBill       优惠金额
 *  @param voucherCode      优惠码
 *  @param voucherRecordIds 兑换商品ids 格式: 1,2,3
 *  @param success          成功回调
 *  @param failure          失败回调
 */
+ (void)PurchasesCreateTheOrderWithBuyInfo:(NSString *)buyInfo
                                employeeId:(NSString *)employeeId
                             warehouseCode:(NSString *)warehouseCode
                                 addressId:(NSString *)addressId
                                payChannel:(NSString *)payChannel
                                  freeSign:(NSString *)freeSign
                                    remark:(NSString *)remark
                                ladingBill:(NSString *)ladingBill
                               voucherCode:(NSString *)voucherCode
                          voucherRecordIds:(NSString *)voucherRecordIds
                                   success:(success)success
                                   failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/createInOrder",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (remark != nil && remark.length) parameters[@"remark"] = remark; //备注
    if (ladingBill != nil && ladingBill.length) parameters[@"ladingBill"] = ladingBill;
    if (voucherCode != nil && voucherCode.length) parameters[@"voucherCode"] = voucherCode;
    if (voucherRecordIds != nil && voucherRecordIds.length) parameters[@"voucherRecordIds"] = voucherRecordIds;
    if (employeeId != nil && employeeId.length) parameters[@"empoyeeId"] = employeeId;

    parameters[@"token"] = TOKEN;
    parameters[@"buyInfo"] = buyInfo;
    parameters[@"warehouseCode"] = warehouseCode;
    parameters[@"addressId"] = addressId;
    parameters[@"payChannel"] = payChannel;
    parameters[@"freeSign"] = freeSign;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  采购界面 --> 切换支付方式
 *  @param payType          1:在线支付,2:是货到付款；
 *  @param payChannel       支付渠道 : 0 未指定 ,1 支付宝 ,2 微信,3全久币支付 4.银联
 *  @param orderId          ID
 *  @param success          成功回调
 *  @param failure          失败回调
 */
+ (void)PurchasesSwitchingModeOfPaymentWithPayType:(NSString *)payType
                                        payChannel:(NSString *)payChannel
                                           orderId:(NSString *)orderId
                                           success:(success)success
                                           failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/updatePayChannel",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"payType"] = payType;
    parameters[@"payChannel"] = payChannel;
    parameters[@"orderId"] = orderId;
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  采购界面 --> 微信支付
 *  @param payStage        （1.完全在线支付 2.货到付款在线支付定金 3.货到付款在线支付余额）
 *  @param orderId          ID
 *  @param success          成功回调
 *  @param failure          失败回调
 */
+ (void)PurchasesWeChatPayWithPayStage:(NSString *)payStage
                               orderId:(NSString *)orderId
                           actuDeposit:(NSString *)actuDeposit
                               success:(success)success
                               failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/pay/getWCAppSellerPayDate",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (actuDeposit != nil && actuDeposit.length) parameters[@"actuDeposit"] = actuDeposit; //货到付款 付款金额
    parameters[@"token"] = TOKEN;
    parameters[@"payStage"] = payStage;
    parameters[@"orderId"] = orderId;
        
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  采购界面 -->  支付宝支付
 *  @param payStage        （1.完全在线支付 2.货到付款在线支付定金 3.货到付款在线支付余额）
 *  @param orderId          ID
 *  @param success          成功回调
 *  @param failure          失败回调
 */
+ (void)PurchasesAliPayWithPayStage:(NSString *)payStage
                            orderId:(NSString *)orderId
                        actuDeposit:(NSString *)actuDeposit
                            success:(success)success
                            failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/pay/getAliAppInPayDate",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (actuDeposit != nil && actuDeposit.length) parameters[@"actuDeposit"] = actuDeposit; //货到付款 付款金额
    parameters[@"token"] = TOKEN;
    parameters[@"payStage"] = payStage;
    parameters[@"orderId"] = orderId;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  翼分期
 *  @param orderId          ID
 *  @param success          成功回调
 *  @param failure          失败回调
 */
+ (void)CreditPayWithOrderId:(NSString *)orderId
                     success:(success)success
                     failure:(failure)failure {
        
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/creditPay",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"orderId"] = orderId;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}



/**
 *  采购界面 --> 支付成功回调
 *
 *  @param orderId          ID
 *  @param success          成功回调
 *  @param failure          失败回调
 */
+ (void)PurchasesPayAfterSuccessResultWithOrderId:(NSString *)orderId
                                          success:(success)success
                                          failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/pay/getInOrderState",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"orderId"] = orderId;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  采购界面 --> 采购单详情 (货到付款界面)
 *
 *  @param orderId          ID
 *  @param success          成功回调
 *  @param failure          失败回调
 */
+ (void)PurchasesPayCashOnDeliveryWithOrderId:(NSString *)orderId
                                      success:(success)success
                                      failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getInOrderInfo",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"orderId"] = orderId;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  采购界面 --> 计算并修改订单定金使用久币 (货到付款界面)
 *
 *  @param orderId          ID
 *  @param success          成功回调
 *  @param failure          失败回调
 */
+ (void)PurchasesPayGetJiubiDepositWithOrderId:(NSString *)orderId
                                       success:(success)success
                                       failure:(failure)failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getJiubiDeposit",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"orderId"] = orderId;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  采购界面 --> 全部使用久币支付 (货到付款界面)
 *
 *  @param orderId          ID
 *  @param success          成功回调
 *  @param failure          失败回调
 */
+ (void)PurchasesPayOrderUseJiubiWithOrderId:(NSString *)orderId
                                     success:(success)success
                                     failure:(failure)failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/payOrderUseJiubi",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"orderId"] = orderId;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  采购界面 --> 信誉指数为100的时候，支付订单 (货到付款界面)
 *
 *  @param orderId          ID
 *  @param success          成功回调
 *  @param failure          失败回调
 */
+ (void)PurchasesPayOrderUseNoneMoneyWithOrderId:(NSString *)orderId
                                     success:(success)success
                                     failure:(failure)failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/payOrderUseNoneMoney",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"orderId"] = orderId;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  全余额支付
 *
 *  @param orderId          ID
 *  @param success          成功回调
 *  @param failure          失败回调
 */
+ (void)BalanceFullPayWithOrderId:(NSString *)orderId
                          success:(success)success
                          failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/balanceFullPay",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"orderId"] = orderId;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  全余额支付 恢复商家账户余额缓存
 *
 *  @param orderId          ID
 *  @param success          成功回调
 *  @param failure          失败回调
 */
+ (void)CheckThirdPartyPayWithOrderId:(NSString *)orderId
                              success:(success)success
                              failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/checkThirdPartyPay",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"orderId"] = orderId;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}



#pragma mark - 门店接口 -
//////////////////////////////////////////////////////////////////////////////////////
/************************************   门店接口  *************************************/
//////////////////////////////////////////////////////////////////////////////////////
/**
 *  门店数据获取。
 *
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)getStoreDataByBaseUrlSuccess:(success)success
                             failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/index",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  售货管理 --> 商家一级分类
 *
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)getStoreAfterSalesFirstGoodsClassGroupDataSuccess:(success)success
                                                  failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/getFirstGoodsClassGroup",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  售货管理 --> 商家二级分类
 *
 *  @param classId    classId
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)getStoreAfterSalesgetSecondGoodsClassGroupDataByClassId:(NSString * )classId
                                                        Success:(success)success
                                                        failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/getSecondGoodsClassGroup",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"classId"] = classId;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  售货管理 --> 售货详情，获取单个商家商品
 *
 *  @param goodsId           商品id
 *  @param success           成功回调
 *  @param failure           失败回调
 */
+ (void)getStoreAfterSalesFindSellerGoodsInfoWithGoodsId:(NSString * )goodsId
                                                 Success:(success)success
                                                 failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/findSellerGoodsInfohh",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"goodsId"] = goodsId;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  售货管理 --> 售货详情 修改商品名称，规格名称、价格
 *
 *  @param goodsId           商品id
 *  @param specificationId   规格id
 *  @param goodsName         商品名称
 *  @param specificationName 规格名称
 *  @param price             price
 *  @param success           成功回调
 *  @param failure           失败回调
 */
+ (void)getStoreAfterSalesEditSpecificationPriceWithGoodsId:(NSString * )goodsId
                                            specificationId:(NSString *)specificationId
                                                  goodsName:(NSString *)goodsName
                                          specificationName:(NSString *)specificationName
                                                      price:(NSString *)price
                                                    Success:(success)success
                                                    failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/editSpecificationPrice",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (goodsName != nil && goodsName.length) parameters[@"goodsName"] = goodsName;
    if (specificationName != nil && specificationName.length) parameters[@"specificationName"] = specificationName;

    parameters[@"token"] = TOKEN;
    parameters[@"goodsId"] = goodsId;
    parameters[@"specificationId"] = specificationId;
    parameters[@"price"] = price;

    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  售货管理 --> 售货详情 商品采购记录
 *
 *  @param Id                规格specificationId
 *  @param success           成功回调
 *  @param failure           失败回调
 */
+ (void)getStoreAfterSalesGetPurchaseRecordWithSpecificationId:(NSString *)Id
                                                       Success:(success)success
                                                       failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getPurchaseRecord",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"specificationId"] = Id;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  售货管理 --> 商家对应分类下的商品
 *
 *  @param aClassId   第一级列别id(可为空或0)
 *  @param bClassId    第二级列别id(可为空或0)
 *  @param sort       排序字段
 *  @param order      排序方式
 *  @param isShelves  是否上架
 *  @param startRow   起始行数
 *  @param endRow     结束行数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)queryStoreBusinessesUnderGoodsWithAClassId:(NSString *)aClassId
                                          BClassId:(NSString *)bClassId
                                              Sort:(NSString *)sort
                                             Order:(NSString *)order
                                         IsShelves:(NSString *)isShelves
                                          StartRow:(NSInteger)startRow
                                            endRow:(NSInteger)endRow
                                           success:(success)success
                                           failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/searchSellerGoods",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (aClassId != nil && aClassId.length) parameters[@"aClassId"] = aClassId; //第1级列别
    if (bClassId != nil && bClassId.length) parameters[@"bClassId"] = bClassId; //第2级列别
    if (sort != nil && sort.length) parameters[@"sort"] = sort; //排序字段
    if (order != nil && order.length) parameters[@"order"] = order; //排序方式
    if (isShelves != nil && isShelves.length) parameters[@"isShelves"] = isShelves;
    parameters[@"token"] = TOKEN;
    parameters[@"startRow"] = @(startRow);  //开始行
    parameters[@"endRow"] = @(endRow);  //结束行
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  售货管理 -> 商品上下架
 *
 *  @param goodsIds   ID
 *  @param isShelves  0下架；1上架
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)StoreGoodsUpAndDownWithGoodsIds:(NSString *)goodsIds
                              IsShelves:(NSInteger)isShelves
                                success:(success)success
                                failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/batchShelves",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"goodsIds"] = goodsIds;
    parameters[@"isShelves"] = @(isShelves);
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure]; 
}

/**
 *  售货管理 -> 删除商家商品
 *
 *  @param goodsIds   ID
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)StoreGoodsDelegateWithGoodsIds:(NSString *)goodsIds
                               success:(success)success
                               failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/removeFromStorage",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"goodsIds"] = goodsIds;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}




/**
 *  门店管理 ->  获取一级分类
 *
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)StoreGetShopTypeByPlevelSuccess:(success)success
                                failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/getShopTypeByPlevel",HTTPBaseUrl];
    
    [self HttpRequestWithHttpMthod:GET URLStr:urlStr parameters:nil progress:nil sueeess:success failure:failure];
}

/**
 *  门店管理 ->  根据一级分类获取二级分类
 *
 *  @param parentId   ID
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)StoreGetGoodsClassWithParentId:(NSString *)parentId
                               success:(success)success
                               failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/getShopTypeByParentId",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"parentId"] = parentId;
//    parameters[@"token"] = TOKEN;

    [self HttpRequestWithHttpMthod:GET URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}



/**
 *  门店管理 ->  修改店铺信息
 *
 *  @param businessName   店铺名称
 *  @param shopType       店铺类型 -> ID拼接
 *  @param cityCode       城市代码 -> 区域编码
 *  @param headImg        店铺头部图片
 *  @param shopBg         店铺背景图片
 *  @param address        店铺地址
 *  @param mapCode        店铺地址定位代码，格式：lat,lng
 *  @param success        成功回调
 *  @param failure        失败回调
 */
+ (void)StoreStoresUpdataSellerForBaseWithBusinessName:(NSString *)businessName
                                              shopType:(NSString *)shopType
                                              cityCode:(NSString *)cityCode
                                               headImg:(NSString *)headImg
                                                shopBg:(NSString *)shopBg
                                               address:(NSString *)address
                                               mapcode:(NSString *)mapCode
                                               success:(success)success
                                               failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/updateSellerForBase",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"businessName"] = businessName;
    parameters[@"shopType"] = shopType;
    parameters[@"cityCode"] = cityCode;
    parameters[@"headImg"] = headImg;
    parameters[@"shopBg"] = shopBg;
    parameters[@"address"] = address;
    parameters[@"mapCode"] = mapCode;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  门店管理 ->  修改店铺营业时间
 *
 *  @param isBusiness   是否营业中的标识：0休息中；1营业中
 *  @param beginTime    开始时间
 *  @param endTime      结束时间
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+ (void)StoreStoresUpdateSellerForActivityWithIsBusiness:(NSString *)isBusiness
                                               beginTime:(NSString *)beginTime
                                                 endTime:(NSString *)endTime
                                                 success:(success)success
                                                 failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/updateSellerForActivity",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"isBusiness"] = isBusiness;
    parameters[@"beginTime"] = beginTime;
    parameters[@"endTime"] = endTime;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  门店管理 ->  修改的配送信息
 *
 *  @param deliveryMinAmount    最低起送金额
 *  @param deliveryFee          配送费
 *  @param deliveryRadius       配送半径
 *  @param since                是否上门自提：1是自提；0不是
 *  @param success              成功回调
 *  @param failure              失败回调
 */
+ (void)StoreStoresUpdateSellerForDeliveryWithDeliveryMinAmount:(NSString *)deliveryMinAmount
                                                    deliveryFee:(NSString *)deliveryFee
                                                 deliveryRadius:(NSString *)deliveryRadius
                                                          since:(NSString *)since
                                                        success:(success)success
                                                        failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/updateSellerForDelivery",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"deliveryMinAmount"] = deliveryMinAmount;
    parameters[@"deliveryFee"] = deliveryFee;
    parameters[@"deliveryRadius"] = deliveryRadius;
    parameters[@"since"] = since;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  门店管理 ->  修改资质
 *
 *  @param imgUrl    图片路径
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)StoreStoresSaveQualificationsWithImgUrl:(NSString *)imgUrl
                                        success:(success)success
                                        failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/saveQualifications",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"imgUrl"] = imgUrl;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}



/**
 *  上传图片
 *
 *  @param type    1:修改基本信息上传图片 9:资质管理上传图片
 *  @param sellerId  用户ID
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)UploadPhotoWithType:(NSString *)type
                   sellerId:(NSString *)sellerId
                   photoImg:(UIImage *)img
                    success:(success)success
                    failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/common/upload",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"sellerId"] = sellerId;
    parameters[@"type"] = type;
    
    AFHTTPSessionManager *manager = [self manager];
    [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"platform"];
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 获取图片数据
        NSData *fileData = UIImagePNGRepresentation(img);
        // 设置上传图片的名字
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        [formData appendPartWithFileData:fileData name:@"image" fileName:fileName mimeType:@"image/png"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        //上传成功后回调
        [self responseSuccessHandleWithResponseObject:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //失败回调
        failure(ZJResponseError,nil,@"上传失败");
    }];
}


/**
 *  门店 --> 采购管理
 *
 *  @param type  类型:1:全部 2:待发货 3:待验货 4:待收货 5:已完成
 *  @param startRow  开始行
 *  @param endRow    结束行
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)StoreStoresGetOrderDataWithType:(int)type
                               StartRow:(NSInteger)startRow
                                 EndRow:(NSInteger)endRow
                                success:(success)success
                                failure:(failure)failure {
    NSString *urlStr;
    if (type == 1) {
        urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getAllInOrderList",HTTPBaseUrl];
    }else if (type == 2) {
        urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getNoAndPayInOrderList",HTTPBaseUrl];
    }else if (type == 3) {
        urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getNoInspectionInOrderList",HTTPBaseUrl];
    }else if (type == 4) {
        urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getNoSureInOrderList",HTTPBaseUrl];
    }else if (type == 5) {
        urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getCompletedInOrderList",HTTPBaseUrl];
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"startRow"] = @(startRow);  //开始行
    parameters[@"endRow"] = @(endRow);  //结束行

    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}



/**
 *  门店 --> 采购管理(取消订单)
 *
 *  @param orderId  ID
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)StoreStoresCancelMyInOrderWithOrderId:(NSString *)orderId
                                      success:(success)success
                                      failure:(failure)failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/cancelMyInOrder",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"orderId"] = orderId;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  门店 --> 采购管理(查看物流)
 *
 *  @param inOrderId  ID
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)StoreStoresGetInOrderInfoWithInOrderId:(NSString *)inOrderId
                                       success:(success)success
                                       failure:(failure)failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getInOrderLogistics",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"inOrderId"] = inOrderId;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  门店 --> 采购管理(验货界面商品)
 *
 *  @param inOrderId  ID
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)StoreStoresGetInOrderGoodsListWithInOrderId:(NSString *)inOrderId
                                            success:(success)success
                                            failure:(failure)failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getInOrderGoodsList",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"inOrderId"] = inOrderId;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  门店 --> 采购管理(提交验货信息)
 *
 *  @param orderId  ID
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)StoreStoresUpOrderCheckWithOrderId:(NSString *)orderId
                                   success:(success)success
                                   failure:(failure)failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/upOrderCheck",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"orderId"] = orderId;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  门店 --> 采购管理(更新订单产品验货状态)
 *  说明：goodsId 为空 导航栏UISWitch按钮 不为空 单个商品UISWitch
 *  @param goodsId   ID
 *  @param orderId   ID
 *  @param isCheck   (0.未验 1.已验)
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)StoreStoresCancelMyInOrderWithGoodsId:(NSString *)goodsId
                                      orderId:(NSString *)orderId
                                      isCheck:(NSInteger)isCheck
                                      success:(success)success
                                      failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/upOrderGoodsCheck",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (goodsId != nil && goodsId.length) parameters[@"goodsId"] = goodsId;
    parameters[@"token"] = TOKEN;
    parameters[@"orderId"] = orderId;
    parameters[@"isCheck"] = @(isCheck);
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}



/**
 *  门店 --> 资产管理 -> 获取账户中的资产明细
 *
 *  @param startRow  开始行
 *  @param endRow    结束行
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)StoreStoresAssetsManagerGetSellerAccountListWithStartRow:(NSInteger)startRow
                                                          endRow:(NSInteger)endRow
                                                         success:(success)success
                                                         failure:(failure)failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getSellerAccountList",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"token"] = TOKEN;
    parameters[@"startRow"] = @(startRow);
    parameters[@"endRow"] = @(endRow);
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  门店 --> 资产管理 -> 创建充值订单
 *
 *  @param price   ID
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)StoreStoresAssetsManagerCreateSellerRechargeOrderWithPrice:(NSString *)price
                                                           success:(success)success
                                                           failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/createSellerRechargeOrder",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"price"] = price;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  门店 --> 资产管理 -> 切换充值订单支付方式
 *
 *  @param orderId      ID
 *  @param payChannel  （1 支付宝 ,2 微信）
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+ (void)StoreStoresAssetsManagerUpdateSellerRechargeChannelWithOrderId:(NSString *)orderId
                                                            payChannel:(NSInteger)payChannel
                                                               success:(success)success
                                                               failure:(failure)failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/updateSellerRechargeChannel",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"orderId"] = orderId;
    parameters[@"payChannel"] = @(payChannel);
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  门店 --> 资产管理 -> 充值订单-支付宝支付
 *
 *  @param orderId   ID
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)StoreStoresAssetsManagerGetAliAppSellerRechargeWithOrderId:(NSString *)orderId
                                                           success:(success)success
                                                           failure:(failure)failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@/pay/getAliAppSellerRecharge",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"orderId"] = orderId;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  门店 --> 资产管理 -> 充值订单-微信支付
 *
 *  @param orderId   ID
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)StoreStoresAssetsManagerGetAppSellerRechargeWithOrderId:(NSString *)orderId
                                                        success:(success)success
                                                        failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/pay/getAppSellerRecharge",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"orderId"] = orderId;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  门店 --> 资产管理 -> 充值订单 - 获充值订单支付状态
 *
 *  @param orderId   ID
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)StoreStoresAssetsManagerGetRechargeOrderStateWithOrderId:(NSString *)orderId
                                                         success:(success)success
                                                         failure:(failure)failure{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/pay/getRechargeOrderState",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"orderId"] = orderId;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}



//=====================   二次校验    ======================================
/**
 *   订单支付校验
 *  @param buyInfo          商家购买的商品列表 （规格id,购买商品数量,商品价格）
 *  @param orderId          ID
 *  @param success          成功回调
 *  @param failure          失败回调
 */
+ (void)payInOrderCheckWithBuyInfo:(NSString *)buyInfo
                           orderId:(NSString *)orderId
                           success:(success)success
                           failure:(failure)failure {
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/payInOrderCheck",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"buyInfo"] = buyInfo;
    parameters[@"orderId"] = orderId;
    
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}



/**
 *  门店 --> 兑换管理 -> 查看兑换管理列表
 *
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)StoreGetExchangeValidateListWithSuccess:(success)success
                                        failure:(failure)failure {
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getExchangeValidateList",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;

    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  门店 --> 提现 -> 获取提现账户信息
 *  return  Seller 商户信息对象  lastpayAccouont 最近一次付款账户   支付宝账户或微信openid
 *                         lastpayChannel 最近一次付款渠道    0 未指定 ,1 支付宝 ,2 微信
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)StoreGetWithdrawPayChannelWithSuccess:(success)success
                                      failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getWithdrawPayChannel",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  门店 --> 提现 -> 申请提现
 *
 *  @param amount 提现金额
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)ApplyWithdrawCashWithAmount:(NSString *)amount
                            success:(success)success
                            failure:(failure)failure {
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/applyWithdrawCash",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"amount"] = amount;

    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  验证支付（提现）密码
 *
 *  @param password  密码
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)ValidatePayPwdWithPassword:(NSString *)password
                           success:(success)success
                           failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/validatePayPwd",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"password"] = password;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  修改支付（提现）密码
 *
 *  @param oldPassword  旧密码
 *  @param newPassword  新密码
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)ModifyPayPwdWithOldPassword:(NSString *)oldPassword
                        newPassword:(NSString *)newPassword
                            success:(success)success
                            failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/modifyPayPwd",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"oldPassword"] = oldPassword;
    parameters[@"newPassword"] = newPassword;

    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
    
}

/**
 *  重置支付（提现）密码
 *
 *  @param tel        电话
 *  @param password   密码
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)ResetPayPwdWithUserTel:(NSString *)tel
                      password:(NSString *)password
                       success:(success)success
                       failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/resetPayPwd",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"password"] = password;
    parameters[@"tel"] = tel;

    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}





#pragma mark - 订单 -
//////////////////////////////////////////////////////////////////////////////////////
/************************************  订单接口  *************************************/
/**
 *  订单 --> 我的订单
 *
 *  @param startRow  开始行
 *  @param endRow    结束行
 *  @param flag      1.全部订单，2.代发货订单，3.待交货订单，4.已完成
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)OrderGetAllOrderListWithStartRow:(NSInteger)startRow
                                  endRow:(NSInteger)endRow
                                    flag:(NSInteger)flag
                                 success:(success)success
                                 failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/getAllOrderList",HTTPBaseUrl];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"startrow"] = @(startRow);  //开始行
    parameters[@"endrow"] = @(endRow);  //结束行
    parameters[@"flag"] = @(flag);  //订单种类

    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *   订单 --> 订单详情
 *  @param orderId          订单ID
 *  @param success          成功回调
 *  @param failure          失败回调
 */
+ (void)OrderOrderDetilsWithOrderId:(NSString *)orderId
                            success:(success)success
                            failure:(failure)failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/orderDetils",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"orderId"] = orderId;
    parameters[@"token"] = TOKEN;
    
    [self HttpRequestWithHttpMthod:GET URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *   订单 --> 确认发货
 *  @param orderId          订单ID
 *  @param success          成功回调
 *  @param failure          失败回调
 */
+ (void)OrderSendOrderGoodsWithOrderId:(NSString *)orderId
                               success:(success)success
                               failure:(failure)failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/sendOrderGoods",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"orderId"] = orderId;
    parameters[@"token"] = TOKEN;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *   订单 --> 确认交货
 *  @param orderId          订单ID
 *  @param success          成功回调
 *  @param failure          失败回调
 */
+ (void)OrderSellerSureForMyOrderWithOrderId:(NSString *)orderId
                                     success:(success)success
                                     failure:(failure)failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/sellerSureForMyOrder",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"orderId"] = orderId;
    parameters[@"token"] = TOKEN;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *   订单 --> 商家拒单
 *  @param orderId          订单ID
 *  @param success          成功回调
 *  @param failure          失败回调
 */
+ (void)OrderRefuesedOrdersWithOrderId:(NSString *)orderId
                               success:(success)success
                               failure:(failure)failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/refuesedOrders",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"orderId"] = orderId;
    parameters[@"token"] = TOKEN;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *   订单 --> 交货验证
 *  @param orderId          订单ID
 *  @param checkCode        验证码
 *  @param success          成功回调
 *  @param failure          失败回调
 */
+ (void)OrderGoodsCheckCodeWithOrderId:(NSString *)orderId
                             checkCode:(NSString *)checkCode
                               success:(success)success
                               failure:(failure)failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/goodsCheckCode",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"orderId"] = orderId;
    parameters[@"checkCode"] = checkCode;
    parameters[@"token"] = TOKEN;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}



#pragma mark - 我的接口 -
//////////////////////////////////////////////////////////////////////////////////////
/************************************  我的接口  *************************************/
//////////////////////////////////////////////////////////////////////////////////////

/**
 *  注册  (注册商家信息)
 *
 *  @param trueName 姓名
 *  @param tel 手机号码
 *  @param code 验证码
 *  @param businessName 店铺名称
 *  @param detailedAddress 详细地址
 *  @param recommenderPhone 邀约人手机号码
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)ApiSellerAddWithTrueName:(NSString *)trueName
                             tel:(NSString *)tel
                            code:(NSString *)code
                    businessName:(NSString *)businessName
                 detailedAddress:(NSString *)detailedAddress
                recommenderPhone:(NSString *)recommenderPhone
                         success:(success)success
                         failure:(failure)failure {
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/apiSellerAdd",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"tel"] = tel;
    parameters[@"code"] = code;
    parameters[@"trueName"] = trueName;
    parameters[@"businessName"] = businessName;
    parameters[@"detailedAddress"] = detailedAddress;
    if (recommenderPhone != nil && recommenderPhone.length) parameters[@"recommenderPhone"] = recommenderPhone; //邀约人手机号码

    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}



/**
 *  登录
 *
 *  @param userName   用户名
 *  @param password   密码
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)mineMyInfoLoginRequrestWithUserName:(NSString *)userName
                                   Password:(NSString *)password
                                    success:(success)success
                                    failure:(failure)failure {
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/login",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"userName"] = userName;
    parameters[@"password"] = password;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure]; 
}


/**
 *  发送注册验证码
 *
 *  @param tel   电话号
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)SendRegCodeWithTel:(NSString *)tel
                   success:(success)success
                   failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/sendRegCode",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"tel"] = tel;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  找回密码时验证的手机号
 *
 *  @param telPhone   电话号
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)mineMyInfoFindPwdWithUserPhone:(NSString *)telPhone
                               success:(success)success
                               failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/validateSellerTel",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"tel"] = telPhone;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  找回密码时验证验证码
 *
 *  @param tel        电话
 *  @param code       验证码
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)mineMyInfoCheckPwdWithUserTel:(NSString *)tel
                                 code:(NSString *)code
                              success:(success)success
                              failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/checkCode",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"tel"] = tel;
    parameters[@"code"] = code;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  重设密码
 *
 *  @param tel        电话
 *  @param password   密码
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)mineMyInfoReSetPwdWithUserTel:(NSString *)tel
                             password:(NSString *)password
                              success:(success)success
                              failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/resetPwd",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"tel"] = tel;
    parameters[@"password"] = password;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  修改密码
 *
 *  @param oldPassword   旧密码
 *  @param newPassword   新密码
 *  @param success       成功回调
 *  @param failure       失败回调
 */
+ (void)mineMyInfoFixPwdWithOldPassword:(NSString *)oldPassword
                            newPassword:(NSString *)newPassword
                                success:(success)success
                                failure:(failure)failure {
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/seller/modifyPwd",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"oldPassword"] = oldPassword;
    parameters[@"newPassword"] = newPassword;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}



/**
 *  我的 -> 我的信息 ->地址（添加或编辑收货地址）
 *
 *  @param contacter    收货人
 *  @param tel          联系电话
 *  @param address      详细地址
 *  @param Id           首次添加为0
 *  @param mainAddress  所在区域
 *  @param lat          纬度
 *  @param lng          经度
 *  @param isDefault    是否为默认地址
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+ (void)mineMyInfoAddOrEditAddressWithContacter:(NSString *)contacter
                                            Tel:(NSString *)tel
                                        Address:(NSString *)address
                                             Id:(NSString *)Id
                                    MainAddress:(NSString *)mainAddress
                                            Lat:(NSString *)lat
                                            Lng:(NSString *)lng
                                      IsDefault:(NSString *)isDefault
                                        Success:(success)success
                                        Failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/editAddress",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"contacter"] = contacter;
    parameters[@"tel"] = tel;
    parameters[@"address"] = address;
    parameters[@"id"] = Id;
    parameters[@"mainAddress"] = mainAddress;
    parameters[@"lat"] = lat;
    parameters[@"lng"] = lng;
    parameters[@"isDefault"] = isDefault;
//    JGLog(@"parameters:%@",parameters);
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  我的 -> 我的信息 ->地址（获取商家收货地址列表）
 *
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+ (void)mineMyInfoGetSellerAddressSuccess:(success)success Failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getSellerAddress",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    //    JGLog(@"parameters:%@",parameters);
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  我的 -> 我的信息 ->地址（ 删除收货地址）
 *
 *  @param addressId   地址ID
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)mineMyInfoDeleteAddressWithAddressId:(NSString *)addressId
                                     success:(success)success
                                     failure:(failure)failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/delAddress",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"addressId"] = addressId;
    //    JGLog(@"parameters:%@",parameters);
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  我的 -> 我的信息 ->地址（ 设置默认地址）
 *
 *  @param addressId   地址ID
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)mineMyInfoSetDefaultAddressWithAddressId:(NSString *)addressId
                                         success:(success)success
                                         failure:(failure)failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/setDefaultAddress",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"addressId"] = addressId;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  我的 -> 我的供应商列表
 *
 *  @param startRow  开始行
 *  @param endRow    结束行
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)mineGetMyMechisamListWithStartRow:(NSInteger)startRow
                                   endRow:(NSInteger)endRow
                                  success:(success)success
                                  failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getMyMechisamList",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"startRow"] = @(startRow);
    parameters[@"endRow"] = @(endRow);

    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  我的 -> 我的界面中消息中心的数量
 *
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)mineGetMyNewMechisamNumSuccess:(success)success
                               failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getReceiveVoucherNum",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"memberId"] = USER_ID;

    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  我的 -> 消息中心中新的供应商列表
 *
 *  @param startRow  开始行
 *  @param endRow    结束行
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)mineGetMyMechisamRequestWithStartRow:(NSInteger)startRow
                                      endRow:(NSInteger)endRow
                                     success:(success)success
                                     failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getMyMechisamRequest",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"startRow"] = @(startRow);
    parameters[@"endRow"] = @(endRow);
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  我的 -> 消息中心中    收到的提货券列表
 *
 *  @param startRow  开始行
 *  @param endRow    结束行
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)mineGetReceiveVoucherListWithStartRow:(NSInteger)startRow
                                       endRow:(NSInteger)endRow
                                      success:(success)success
                                      failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getReceiveVoucherList",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"memberId"] = USER_ID;
    parameters[@"startRow"] = @(startRow);
    parameters[@"endRow"] = @(endRow);
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}



/**
 *  我的 -> 同意供应商的请求
 *
 *  @param Id   ID
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)mineAgreeMyMechisamRequestWithId:(NSString *)Id
                                 success:(success)success
                                 failure:(failure)failure {
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/agreeMyMechisamRequest",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"id"] = Id;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  我的 -> 我的客户
 *
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)mineGetMyMembersSuccess:(success)success
                        failure:(failure)failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getMyMembers",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}




/**
 *  我的 -> 积分商城--礼券
 *
 *  @param type      礼券类型
 *  @param startRow  开始行
 *  @param endRow    结束行
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)mineGetVoucherListWithType:(NSUInteger)type
                          StartRow:(NSInteger)startRow
                            endRow:(NSInteger)endRow
                           success:(success)success
                           failure:(failure)failure {
    
    NSString *urlStr;
    if (type == 1) { //提货券
        urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getVoucherList",HTTPBaseUrl];
    }else if (type == 2) { //旅游门票
        urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getTicketList",HTTPBaseUrl];
    }
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"startRow"] = @(startRow);
    parameters[@"endRow"] = @(endRow);
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  我的 -> 我的可用 / 不可用提货券
 *
 *  @param type      我的可用(0) / 不可用提货券(1)
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)mineGetMyVoucherListWithType:(NSUInteger)type
                             success:(success)success
                             failure:(failure)failure {
    
    
    NSString *urlStr = @"";
    if (type == 0) { //可用
        urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/myEnableVoucherList",HTTPBaseUrl];
    }else if (type == 1) { //不可用
        urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/myDisEnableVoucherList",HTTPBaseUrl];
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"memberId"] = USER_ID;

    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  我的 -> 我的门票
 *
 *  @param type      未领取(0) / 已领取(1)
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)mineGetMyTicketVoucherListWithType:(NSUInteger)type
                                   Success:(success)success
                                   failure:(failure)failure {
    
    NSString *urlStr;
    if (type == 0) { //未领取
        urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/myDisableTicketVoucherList",HTTPBaseUrl];
    }else if (type == 1) { //已领取
        urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/myEnableTicketVoucherList",HTTPBaseUrl];
    }
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  我的 --> 提货券 --> 提货券详情
 *
 *  @param voucherCode 代码
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)mineGetVoucherDetailWithVoucherCode:(NSString *)voucherCode
                                    success:(success)success
                                    failure:(failure)failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/voucherDetail",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"voucherCode"] = voucherCode;

    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  我的 --> 提货券 --> 提货券详情 激活绑定
 *
 *  @param voucherCode 代码
 *  @param exchangeCode 代码
 *  @param memberId 兑换的商家ID
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)mineBindVoucherWithVoucherCode:(NSString *)voucherCode
                          exchangeCode:(NSString *)exchangeCode
                              memberId:(NSString *)memberId
                               success:(success)success
                               failure:(failure)failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/bindVoucher",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"memberId"] = memberId;
    parameters[@"exchangeCode"] = exchangeCode;
    parameters[@"voucherCode"] = voucherCode;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  我的 -> 兑换记录
 *
 *  @param startRow  开始行
 *  @param endRow    结束行
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)mineGetMemberVouvherRecordWithStartRow:(NSInteger)startRow
                                        endRow:(NSInteger)endRow
                                       success:(success)success
                                       failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getMemberVouvherRecord",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"memberId"] = USER_ID;
    parameters[@"start"] = @(startRow);
    parameters[@"end"] = @(endRow);
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  我的 -> 兑换记录 -> 有资格领取门票的商家列表
 *
 *  @param voucherCode  礼券代码
 *  @param address   店铺地址
 *  @param startRow  开始行
 *  @param endRow    结束行
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)mineGetReceiveVoucherSellersWithvoucherCode:(NSString *)voucherCode
                                            address:(NSString *)address
                                           StartRow:(NSInteger)startRow
                                             endRow:(NSInteger)endRow
                                            success:(success)success
                                            failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getReceiveVoucherSellers",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (address != nil && address.length) parameters[@"address"] = address;
    parameters[@"token"] = TOKEN;
    parameters[@"voucherCode"] = voucherCode;
    parameters[@"startRow"] = @(startRow);
    parameters[@"endRow"] = @(endRow);
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  我的 -> 兑换记录 -> 确定选择待领取的地点
 *
 *  @param voucherCode  礼券代码
 *  @param sellerId  店家用户ID
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)mineSetExchangeTicketsWithvoucherCode:(NSString *)voucherCode
                                     sellerId:(NSString *)sellerId
                                      success:(success)success
                                      failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/setExchangeTickets",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"sellerId"] = sellerId;
    parameters[@"voucherCode"] = voucherCode;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}

/**
 *  我的 -> 兑换记录 -> 查看兑换凭证
 *
 *  @param voucherCode  礼券代码
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)mineGetExchangeValidateCodeWithvoucherCode:(NSString *)voucherCode
                                           success:(success)success
                                            failure:(failure)failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getExchangeValidateCode",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"voucherCode"] = voucherCode;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  我的 --> 久币商城 --> 提货券 久币兑换提货券
 *
 *  @param voucherCode 代码
 *  @param jiubiNum 久币数量
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)mineExchangeVoucherWithVoucherCode:(NSString *)voucherCode
                                  jiubiNum:(NSString *)jiubiNum
                                   success:(success)success
                                   failure:(failure)failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/exchangeVoucher",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"memberId"] = USER_ID;
    parameters[@"jiubiNum"] = jiubiNum;
    parameters[@"voucherCode"] = voucherCode;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


////////////////////////////////////////////////////////////////////////////////////
/************************************  公共接口  *************************************/
/**
 *  我的界面/货到付款(采购)/资产管理(门店) --> 获取信誉、商家星级 (货到付款界面) 资金池金额
 *
 *  @param success          成功回调
 *  @param failure          失败回调
 */
+ (void)GetNextReputationIndexSuccess:(success)success
                              failure:(failure)failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/getNextReputationIndex",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    
    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}


/**
 *  采购支付、门店支付 ---> 资金池校验
 *
 *  @param orderId 订单ID
 *  @param flag 1表示全余额支付,2支付宝+余额 ，3微信+余额 4翼分期
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)CheckbalanceWithOrderId:(NSString *)orderId
                           flag:(int)flag
                        success:(success)success
                        failure:(failure)failure {
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sellerInOrder/checkbalance",HTTPBaseUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = TOKEN;
    parameters[@"flag"] = @(flag);
    parameters[@"orderId"] = orderId;

    [self HttpRequestWithHttpMthod:POST URLStr:urlStr parameters:parameters progress:nil sueeess:success failure:failure];
}




#pragma mark - 公有方法 -
////////////////////////////////////////////////////////////////////////////////////
/***********************************  公有方法   ************************************/
////////////////////////////////////////////////////////////////////////////////////
/**
 *  创建一个http请求
 *
 *  @param httpMthod      请求方法 GET OR POST
 *  @param URLStr         请求URL字符串
 *  @param parameters     请求参数
 *  @param progress       请求进度(可忽略)
 *  @param success        请求成功的回调
 *  @param failure        请求失败的回调
 */
+ (void)HttpRequestWithHttpMthod:(ZJHttpMthod)httpMthod
                          URLStr:(NSString *)URLStr
                      parameters:(NSDictionary *)parameters
                        progress:(void (^)(NSProgress * _Nonnull))progress
                         sueeess:(success)success
                         failure:(failure)failure {
    
    AFHTTPSessionManager *manager = [self manager];
    [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"platform"];
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    switch (httpMthod) {
        case GET:
        {
            [manager GET:URLStr parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self responseSuccessHandleWithResponseObject:responseObject success:success failure:failure];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(ZJResponseFailed,error,@"网络请求失败");
            }];
        }
            break;
        case POST:
        {
            [manager POST:URLStr parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self responseSuccessHandleWithResponseObject:responseObject success:success failure:failure];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(ZJResponseFailed,error,@"网络请求失败");
            }];
        }
            break;
        default:
            break;
    }
}




/**
 *  处理请求成功的方法
 *
 *  @param responseObject JSON 对象
 *  @param success        成功回调
 *  @param failure        失败回调（不是网络请求的失败，而是服务端返回的失败。例:参数错误，未登录等）
 */
+ (void)responseSuccessHandleWithResponseObject:(id)responseObject
                                        success:(success)success
                                        failure:(failure)failure {
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    
    ZJBLHttpBaseModel *baseModel = [[ZJBLHttpBaseModel alloc] initWithObject:dict];
    switch (baseModel.resultCode) {
        case ZJResponseSuccess:
            success(baseModel.data);
            break;
            
        default:
            failure(ZJResponseUnknown,nil,baseModel.resultMessage);
            break;
    }
}

@end
