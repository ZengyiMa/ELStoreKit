# ELStoreKit
基于 StoreKit 的封装工具类

## 集成方式
1. 添加 StoreKit.framework 框架。
2. 将 ELStoreKit 文件拖入项目。

## 基本使用
1. 创建 ELStoreKit 对象

 ```
 [ELStoreKit new]
 ```

2. 设置回调 Block 方法，ELStoreKit 提供了 2 个 Block：

  `productsRequestBlock`提供了客户端像 Apple 服务器请求商品的 Block，可以处理请求成功，或者失败等问题。Block 的返回值是 BOOL ，指示让框架继续执行。返回 NO 将停止内购流程。
  
   `transactionStateBlock`提供了内购流程的状态变更。如：购买成功，购买失败，等状态。您可以在此 Block 处理内购之后的流程。**注意：如果要完成一个内购需要调用 SKPaymentTransaction 对象的 el_finishTransaction 方法**

3. 调用 `startTransaction` 开启服务。
4. 购买时调用 `addPayment` 来购买一个后台设置的商品。



