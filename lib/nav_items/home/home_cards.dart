import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/nav_items/my_purchases.dart';
import 'package:nandikrushi_farmer/product/product_provider.dart';

import '../../product/my_products_page.dart';
import '../../product/orders_page.dart';

homeOrdersCard(context, productProvider) {
  return productProvider.orders.isNotEmpty
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text(
                  "Upcoming Orders",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OrdersPage(
                                onBack: () {
                                  Navigator.of(context).pop();
                                },
                              )));
                    },
                    child: const Text("View More")),
              ],
            ),
            const Opacity(
              opacity: 0.6,
              child: Text("Prepare the orders you need to deliver"),
            ),
            const SizedBox(
              height: 16,
            ),
            ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, itemIndex) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: productProvider.orders[itemIndex]
                                    ["order_status"] ==
                                "1"
                            ? Colors.amber.shade100
                            : Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Expanded(
                          child: ListView.separated(
                              primary: false,
                              shrinkWrap: true,
                              separatorBuilder: (_, __) {
                                return const Divider();
                              },
                              itemCount: 1,
                              // productProvider
                              //     .orders[itemIndex]["products"].length,
                              itemBuilder: (context, productOrderIndex) {
                                var product = productProvider.orders[itemIndex]
                                    ["products"][productOrderIndex];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      ClipOval(
                                        child: Image.network(
                                          product["url"] ??
                                              "https://img.etimg.com/thumb/msid-64411656,width-640,resizemode-4,imgsize-226493/cow-milk.jpg",
                                          height: 48,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product["product_name"] ?? "Name",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          Text(
                                            "${product["quantity"]} ${product["units"]?.toString().replaceFirst("1", "") ?? " unit"}${(int.tryParse(product["quantity"]) ?? 1) > 1 ? "s" : ""}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    color: productProvider
                                                                        .orders[
                                                                    itemIndex][
                                                                "order_status"] ==
                                                            "1"
                                                        ? Colors.orange.shade900
                                                            .withOpacity(0.6)
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                            .withOpacity(0.6)),
                                          ),
                                          Opacity(
                                            opacity: 0.4,
                                            child: Text(
                                              productProvider
                                                          .orders[itemIndex]
                                                              ["products"]
                                                          .length >
                                                      1
                                                  ? "${productProvider.orders[itemIndex]["products"].length - 1} More products in this basket"
                                                  : "Only one product in this basket",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                        Transform.rotate(
                          angle: pi / 2,
                          child: Text(
                            productProvider.orders[itemIndex]["order_status"] ==
                                    "1"
                                ? "Pending".toUpperCase()
                                : productProvider.orders[itemIndex]
                                        ["order_status"]
                                    .toString()
                                    .toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: productProvider.orders[itemIndex]
                                                ["order_status"] ==
                                            "1"
                                        ? Colors.amber
                                        : Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.6)),
                          ),
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, _) {
                  return const SizedBox(
                    height: 16,
                  );
                },
                itemCount: productProvider.orders.length > 2
                    ? 2
                    : productProvider.orders.length),
          ],
        )
      : const SizedBox();
}

homeMyProductsCard(context, productProvider) {
  return productProvider.myProducts.isNotEmpty
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text(
                  "My Products",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MyProductsPage()));
                    },
                    child: const Text("View More")),
              ],
            ),
            const Opacity(
              opacity: 0.6,
              child: Text("A wide range of the products you're selling"),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 80,
              child: ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, itemIndex) {
                    var product = productProvider.myProducts[itemIndex];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8.0),
                      child: Row(
                        children: [
                          Image.network(
                            product["image"] ??
                                "https://img.etimg.com/thumb/msid-64411656,width-640,resizemode-4,imgsize-226493/cow-milk.jpg",
                            height: 48,
                            width: 48,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product["product_name"] ?? "Name",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                  "Rs. ${double.tryParse(product["price"] ?? "00.00")?.toStringAsFixed(2) ?? 00.00}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.grey.shade900)),
                              Opacity(
                                opacity: 0.5,
                                child: Text(
                                  "${product["quantity"]} ${product["units"]?.toString().replaceFirst("1", "") ?? " unit"}${(int.tryParse(product["quantity"] ?? "") ?? 1) > 1 ? "s" : ""}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: (double.tryParse(
                                                          product["quantity"] ??
                                                              "") ??
                                                      0.0) <
                                                  2.0
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .error
                                              : null),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, _) {
                    return const SizedBox(
                      width: 12,
                    );
                  },
                  itemCount: productProvider.myProducts.length),
            ),
          ],
        )
      : const SizedBox();
}

homeMyPurchasesCard(context, ProductProvider productProvider) {
  return productProvider.myPurchases.isNotEmpty
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text(
                  "Recent Purchases",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MyPurchasesScreen()));
                    },
                    child: const Text("View More")),
              ],
            ),
            const Opacity(
              opacity: 0.6,
              child: Text("Hope you loved the products you bought"),
            ),
            const SizedBox(
              height: 16,
            ),
            ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, itemIndex) {
                  return Container(
                    // margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(12)),
                    child: ListView.separated(
                        primary: false,
                        shrinkWrap: true,
                        separatorBuilder: (_, __) {
                          return const Divider();
                        },
                        itemCount: 1,
                        // productProvider
                        //     .myPurchases[itemIndex]["products"].length,
                        itemBuilder: (context, productOrderIndex) {
                          var product = productProvider.myPurchases[itemIndex]
                              .productDetails[productOrderIndex];
                          return Row(
                            children: [
                              Image.network(
                                product.image,
                                height: 48,
                                width: 48,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    "${product.orderQuantity} ${product.units.toString().replaceFirst("1", "")}${((product.orderQuantity)) > 1 ? "s" : ""}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Opacity(
                                    opacity: 0.4,
                                    child: Text(
                                      productProvider.myPurchases[itemIndex]
                                                  .productDetails.length >
                                              1
                                          ? "${productProvider.myPurchases[itemIndex].productDetails.length - 1} More products in this basket"
                                          : "Only one product in this basket",
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                  );
                },
                separatorBuilder: (context, _) {
                  return const SizedBox(
                    height: 16,
                  );
                },
                itemCount: productProvider.myPurchases.length > 2
                    ? 2
                    : productProvider.myPurchases.length),
          ],
        )
      : const SizedBox();
}
