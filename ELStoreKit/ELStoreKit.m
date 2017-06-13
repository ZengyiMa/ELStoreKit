//
//  ELStoreKit.m
//  Niupu_SNS
//
//  Created by famulei on 13/06/2017.
//  Copyright © 2017 WE. All rights reserved.
//

#import "ELStoreKit.h"
#import <objc/runtime.h>

@interface ELStoreKit ()<SKPaymentTransactionObserver, SKProductsRequestDelegate>

@end

@interface SKProductsRequest (ELStoreKit)

@property (nonatomic, strong) id el_userInfo;
@end

@implementation ELStoreKit


+ (BOOL)canMakePayments
{
    return [SKPaymentQueue canMakePayments];
}

- (void)startTransaction
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)stopTransaction
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)addPayment:(NSString *)productIdentifier userInfo:(id)userInfo
{
    if (productIdentifier == nil) {
        return;
    }
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:@[productIdentifier]]];
    request.el_userInfo = userInfo;
    request.delegate = self;
    [request start];
}


#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    BOOL isGoon = YES;
    if (self.productsRequestBlock) {
       isGoon = self.productsRequestBlock(request, response, nil);
    }
    if (!isGoon) {
        return;
    }
    if (response.products.count == 0) {
        return;
    }
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:response.products.firstObject];
    if (request.el_userInfo) {
        payment.requestData = [NSKeyedArchiver archivedDataWithRootObject:request.el_userInfo];
    }
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    if (self.productsRequestBlock) {
        self.productsRequestBlock(request, nil, error);
    }
}


#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        if (self.transactionStateBlock) {
            self.transactionStateBlock(transaction.transactionState, queue, transaction);
        }
    }
}

- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

@end




@implementation SKProductsRequest (ELStoreKit)

- (id)el_userInfo
{
   return objc_getAssociatedObject(self, @selector(el_userInfo));
}

- (void)setEl_userInfo:(id)el_userInfo
{
    objc_setAssociatedObject(self, @selector(el_userInfo), el_userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

@end



@implementation SKPaymentTransaction (ELStoreKit)

- (void)el_finishTransaction
{
    [[SKPaymentQueue defaultQueue] finishTransaction:self];
}

- (id)el_userInfo
{
   return [NSKeyedUnarchiver unarchiveObjectWithData:self.payment.requestData];
}

- (NSData *)el_receipt
{
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
   return [NSData dataWithContentsOfURL:receiptURL];
}

- (NSString *)el_base64Receipt
{
    return [[self el_receipt] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

@end
