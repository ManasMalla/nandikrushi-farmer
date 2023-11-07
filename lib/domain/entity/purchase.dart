import 'package:nandikrushi_farmer/domain/entity/product.dart';

class ProductOrder extends Product {
  final int orderQuantity;
  final int dateOrdered;
  ProductOrder({
    required super.productId,
    required super.name,
    required super.description,
    required super.image,
    required super.price,
    required super.quantity,
    required super.units,
    required super.canBeSold,
    required super.category,
    required super.categoryId,
    required super.subcategory,
    required super.subCategoryId,
    required super.produceLocation,
    required super.seller,
    required super.aggregateRating,
    required super.reviews,
    required this.orderQuantity,
    required this.dateOrdered,
    required super.disabled,
  });
  factory ProductOrder.fromProduct(
          Product product, int orderQuantity, int dateOrdered) =>
      ProductOrder(
        productId: product.productId,
        name: product.name,
        description: product.description,
        image: product.image,
        price: product.price,
        quantity: product.quantity,
        units: product.units,
        canBeSold: product.canBeSold,
        category: product.category,
        categoryId: product.categoryId,
        subcategory: product.subcategory,
        subCategoryId: product.subCategoryId,
        produceLocation: product.produceLocation,
        seller: product.seller,
        aggregateRating: product.aggregateRating,
        reviews: product.reviews,
        orderQuantity: orderQuantity,
        dateOrdered: dateOrdered,
        disabled: product.disabled,
      );
}

class OrderStoreDetails {
  final int storeId;
  final String storeName;
  const OrderStoreDetails({
    required this.storeId,
    required this.storeName,
  });
}

class OrderCustomerDetails {
  final int customerId;
  final String firstName;
  final String lastName;
  final String email;
  final String telephone;
  const OrderCustomerDetails({
    required this.customerId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.telephone,
  });
}

class OrderPaymentDetails {
  final String paymentFirstName;
  final String paymentLastName;
  final String paymentAddress1;
  final String paymentAddress2;
  final String paymentCity;
  final String paymentPostcode;
  final String paymentCountry;
  final String paymentZone;
  final String paymentMethod;
  const OrderPaymentDetails({
    required this.paymentFirstName,
    required this.paymentLastName,
    required this.paymentAddress1,
    required this.paymentAddress2,
    required this.paymentCity,
    required this.paymentPostcode,
    required this.paymentCountry,
    required this.paymentZone,
    required this.paymentMethod,
  });
}

class OrderShippingDetails {
  final String shippingFirstName;
  final String shippingLastName;
  final String shippingAddress1;
  final String shippingAddress2;
  final String shippingCity;
  final String shippingPostcode;
  final String shippingCountry;
  final String shippingZone;
  final String houseNo;
  const OrderShippingDetails({
    required this.shippingFirstName,
    required this.shippingLastName,
    required this.shippingAddress1,
    required this.shippingAddress2,
    required this.shippingCity,
    required this.shippingPostcode,
    required this.shippingCountry,
    required this.shippingZone,
    required this.houseNo,
  });
}

class OrderDeliveryDetails {
  final int deliveryDate;
  final String deliveryTime;
  final int orderStatus;
  const OrderDeliveryDetails({
    required this.deliveryDate,
    required this.deliveryTime,
    required this.orderStatus,
  });
}

class Purchase {
  final int orderId;
  final int orderStatusId;
  final String orderStatus;
  final List<ProductOrder> productDetails;
  final List<OrderStoreDetails> storeDetails;
  final OrderCustomerDetails customerDetails;
  final OrderPaymentDetails paymentDetails;
  final OrderShippingDetails shippingDetails;
  final String couponStatus;
  final List<OrderDeliveryDetails> deliveryDetails;
  final double totalOrderPrice;
  const Purchase({
    required this.orderId,
    required this.orderStatusId,
    required this.orderStatus,
    required this.productDetails,
    required this.storeDetails,
    required this.customerDetails,
    required this.paymentDetails,
    required this.shippingDetails,
    required this.couponStatus,
    required this.deliveryDetails,
    required this.totalOrderPrice,
  });
}
