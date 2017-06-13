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


@property (nonatomic, copy) void(^transactionStateBlock)(SKPaymentTransactionState state, SKPaymentQueue *queue, SKPaymentTransaction *transaction);
@property (nonatomic, copy) BOOL(^productsRequestBlock)(SKRequest *reqeust, SKProductsResponse *response, NSError *error);

- (void)startTransaction;
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
@end


