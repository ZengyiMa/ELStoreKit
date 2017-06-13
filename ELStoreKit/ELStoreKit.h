//
//  ELStoreKit.h
//  Niupu_SNS
//
//  Created by famulei on 13/06/2017.
//  Copyright © 2017 WE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface ELStoreKit : NSObject


/**
 交易状态发生变化的回调 block
 */
@property (nonatomic, copy) void(^transactionStateBlock)(SKPaymentTransactionState state, SKPaymentQueue *queue, SKPaymentTransaction *transaction);


/**
 请求商品数据的 block
 */
@property (nonatomic, copy) BOOL(^productsRequestBlock)(SKRequest *reqeust, SKProductsResponse *response, NSError *error);

/**
 查询当前设置是否可以支付

 @return YES 为可以，NO 为不行
 */
+ (BOOL)canMakePayments;

/**
 开启交易监听
 */
- (void)startTransaction;

/**
 停止交易监听
 */
- (void)stopTransaction;
/**
 添加一个购买项目

 @param productIdentifier 商品id
 @param userInfo 附加值，会保存在 SKPaymentTransaction.el_userInfo 中,可归档对象
 */
- (void)addPayment:(NSString *)productIdentifier userInfo:(id<NSCoding>)userInfo;
@end



@interface SKPaymentTransaction (ELStoreKit)
- (void)el_finishTransaction;
- (id)el_userInfo;
- (NSData *)el_receipt;
- (NSString *)el_base64Receipt;
@end


