import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/product/product_card.dart';

import '../../reusable_widgets/text_widget.dart';

moreFarmerProducts(productProvider, productDetails) {
  return Column(
    children: [
      (productProvider.categorizedProducts[productDetails["category_id"]]
                  ?.where((element) =>
                      element["product_id"] != productDetails["product_id"])
                  .isNotEmpty ??
              false)
          ? const Divider(
              thickness: 1,
            )
          : const SizedBox(),
      (productProvider.categorizedProducts[productDetails["category_id"]]
                  ?.where((element) =>
                      element["product_id"] != productDetails["product_id"])
                  .isNotEmpty ??
              false)
          ? TextWidget(
              'More Farmer Products'.toUpperCase(),
              weight: FontWeight.w800,
              size: 16,
            )
          : const SizedBox(),
      ListView.builder(
        itemBuilder: (context, index) {
          return ProductCard(
            verify: productProvider.categorizedProducts["verify_seller"] ?? "0",
            includeHorizontalPadding: false,
            type: CardType.product,
            productId: productProvider
                    .categorizedProducts[productDetails["category_id"]]
                    ?.where((element) =>
                        element["product_id"] != productDetails["product_id"])
                    .toList()[index]["product_id"] ??
                "XYZ",
            productName: productProvider
                    .categorizedProducts[productDetails["category_id"]]
                    ?.where((element) =>
                        element["product_id"] != productDetails["product_id"])
                    .toList()[index]["name"] ??
                "Name",
            productDescription: productProvider
                    .categorizedProducts[productDetails["category_id"]]
                    ?.where((element) =>
                        element["product_id"] != productDetails["product_id"])
                    .toList()[index]["description"] ??
                "Description",
            imageURL: productProvider
                    .categorizedProducts[productDetails["category_id"]]
                    ?.where((element) =>
                        element["product_id"] != productDetails["product_id"])
                    .toList()[index]["url"] ??
                "https://img.etimg.com/thumb/msid-64411656,width-640,resizemode-4,imgsize-226493/cow-milk.jpg",
            price: double.tryParse(productProvider
                        .categorizedProducts[productDetails["category_id"]]
                        ?.where((element) =>
                            element["product_id"] !=
                            productDetails["product_id"])
                        .toList()[index]["price"] ??
                    "00.00") ??
                00.00,
            units: productProvider
                    .categorizedProducts[productDetails["category_id"]]
                    ?.where((element) =>
                        element["product_id"] != productDetails["product_id"])
                    .toList()[index]["units"] ??
                "1 unit",
            location: productProvider
                    .categorizedProducts[productDetails["category_id"]]
                    ?.where((element) =>
                        element["product_id"] != productDetails["product_id"])
                    .toList()[index]["place"] ??
                "Visakhapatnam",
          );
        },
        itemCount: productProvider
            .categorizedProducts[productDetails["category_id"]]
            ?.where((element) =>
                element["product_id"] != productDetails["product_id"])
            .length,
        primary: false,
        shrinkWrap: true,
      )
    ],
  );
}
