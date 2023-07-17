import 'dart:developer';

import 'package:flutter/material.dart';

import '../../nav_items/my_account.dart';
import '../../reusable_widgets/snackbar.dart';
import '../../reusable_widgets/text_widget.dart';

productPageActions(context, productProvider, productDetails, profileProvider) {
  log(productDetails["verify_seller"].toString());
  return Row(
    children: [
      productDetails["verify_seller"] == "1"
          ? productProvider.cart
                  .where((e) => e["product_id"] == productDetails["product_id"])
                  .isNotEmpty
              ? OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero,
                      // Set this
                      padding: const EdgeInsets.all(4),
                      // and this
                      side: BorderSide(
                          width: 1,
                          color: Theme.of(context).colorScheme.outline),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100))),
                  onPressed: () {
                    productProvider.modifyProductToCart(
                        context: context,
                        productID: productDetails["product_id"] ?? "",
                        onSuccessful: () => null,
                        showMessage: (_) {
                          snackbar(context, _);
                        },
                        profileProvider: profileProvider);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.edit,
                          size: 14,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        TextWidget("Modify".toUpperCase(),
                            weight: FontWeight.bold,
                            size: Theme.of(context).textTheme.button?.fontSize),
                      ],
                    ),
                  ),
                )
              : OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero,
                      // Set this
                      padding: const EdgeInsets.all(4),
                      // and this
                      side: const BorderSide(width: 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100))),
                  onPressed: () {
                    productProvider.addProductToCart(
                        context: context,
                        productID: productDetails["product_id"] ?? "",
                        onSuccessful: () => null,
                        showMessage: (_) {
                          snackbar(context, _);
                        },
                        profileProvider: profileProvider);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add,
                          size: 14,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        TextWidget("Add".toUpperCase(),
                            weight: FontWeight.bold,
                            size: Theme.of(context).textTheme.button?.fontSize),
                      ],
                    ),
                  ),
                )
          : const SizedBox(),
      const SizedBox(
        width: 12,
      ),
      OutlinedButton(
        style: OutlinedButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: Size.zero,
            // Set this
            padding: const EdgeInsets.all(4),
            // and this
            side: BorderSide(
                width: 1, color: Theme.of(context).colorScheme.primary),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100))),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              builder: (context) {
                return Container(
                  height: 250,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        "Contact Us",
                        size: Theme.of(context).textTheme.titleLarge?.fontSize,
                        weight: FontWeight.bold,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextWidget(
                        "Choose one of the following sources to get support",
                        flow: TextOverflow.visible,
                        size: Theme.of(context).textTheme.bodyLarge?.fontSize,
                        weight:
                            Theme.of(context).textTheme.bodyLarge?.fontWeight,
                      ),
                      const Spacer(),
                      Row(
                        children: const [
                          Expanded(
                            flex: 3,
                            child: Icon(Icons.email_rounded, size: 48),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 3,
                            child: Icon(Icons.phone_rounded, size: 48),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              onPressed: () async {
                                launchEmail();
                              },
                              child: const Text(
                                "Email",
                              ),
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 3,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              onPressed: () async {
                                dialCall(
                                    mobileNumber:
                                        productDetails["seller_mobile"] ?? "");
                              },
                              child: const Text("Phone"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
          child: TextWidget(
            "Contact".toUpperCase(),
            size: Theme.of(context).textTheme.button?.fontSize,
            weight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    ],
  );
}
