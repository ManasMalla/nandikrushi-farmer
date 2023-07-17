import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/product/product_card.dart';

import '../../reusable_widgets/elevated_button.dart';
import '../../reusable_widgets/text_widget.dart';
import '../address_bottom_sheet.dart';

productPageAppBar(context, productProvider, profileProvider){
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.background,
    toolbarHeight: kToolbarHeight,
    elevation: 0,
    actions: [
      InkWell(
        onTap: () {
          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return StatefulBuilder(
                    builder: (context, setSheetState) {
                      return Container(
                        height: 600,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color:
                            Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(16)
                                .copyWith(
                                bottomRight: Radius.zero,
                                bottomLeft: Radius.zero)),
                        child: productProvider.cart.isNotEmpty
                            ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              'Basket',
                              size: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.fontSize,
                              weight: FontWeight.w700,
                            ),
                            productProvider.cart.isNotEmpty
                                ? TextWidget(
                              '${productProvider.cart.length} items',
                              size: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.fontSize,
                              weight: FontWeight.w500,
                            )
                                : const SizedBox(),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListView.separated(
                                      separatorBuilder:
                                      ((context, index) {
                                        return const Divider();
                                      }),
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: productProvider
                                          .cart.length,
                                      physics:
                                      const NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                      ((context, index) {
                                        return ProductCard(
                                          verify:productProvider.cart[index]["verify_seller"] ??
                                                      "0",
                                            type: CardType.product,
                                            productId:
                                            productProvider.cart[index]["product_id"] ??
                                                "",
                                            productName:
                                            productProvider.cart[index]
                                            ["name"] ??
                                                "",
                                            productDescription: "",
                                            imageURL: productProvider
                                                .cart[index]
                                            ["url"] ??
                                                "",
                                            price: double.tryParse(productProvider.cart[index]["price"] ?? "") ??
                                                0.0,
                                            units: productProvider.cart[index]
                                            ["unit"] ??
                                                "",
                                            location: productProvider
                                                .cart[index]
                                            ["place"] ??
                                                "");
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      'Total'.toUpperCase(),
                                      weight: FontWeight.w600,
                                      size: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.fontSize,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                    ),
                                    TextWidget(
                                      'Rs. ${(productProvider.cart.map((e) => (double.tryParse(e['price'] ?? "0") ?? 0) * (double.tryParse(e['quantity'] ?? "0") ?? 0)).reduce(
                                            (value, element) =>
                                        value + element,
                                      ) + 100.00).toStringAsFixed(2)}',
                                      weight: FontWeight.w700,
                                      size: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.fontSize,
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 16,
                                        left: 24,
                                        right: 24),
                                    child: ElevatedButtonWidget(
                                      iconColor: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      borderRadius: 8,
                                      onClick: () {
                                        showAddressesBottomSheet(
                                            context,
                                            profileProvider,
                                            Theme.of(context));
                                      },
                                      height: 54,
                                      // borderRadius: 16,
                                      bgColor: Theme.of(context)
                                          .colorScheme
                                          .surfaceVariant,
                                      textColor: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      textStyle: FontWeight.bold,
                                      buttonName: "Select Address"
                                          .toUpperCase(),
                                      trailingIcon:
                                      Icons.arrow_forward,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                            : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Image(
                                    image: AssetImage(
                                        'assets/images/empty_basket.png')),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextWidget(
                                  'Basket Is Empty',
                                  weight: FontWeight.w800,
                                  size: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.fontSize,
                                  color: Colors.grey.shade800,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                TextWidget(
                                  'Looks like you have no items in your shopping basket',
                                  weight: FontWeight.w600,
                                  color: Colors.grey,
                                  flow: TextOverflow.visible,
                                  align: TextAlign.center,
                                  size: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.fontSize,
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 42),
                                  child: ElevatedButtonWidget(
                                    bgColor: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                    trailingIcon: Icons.add_rounded,
                                    buttonName:
                                    'Shop Items'.toUpperCase(),
                                    textColor: Colors.white,
                                    textStyle: FontWeight.w800,
                                    borderRadius: 8,
                                    innerPadding: 0.03,
                                    onClick: () {
                                      productProvider
                                          .changeScreen(1);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              });
        },
        child: SizedBox(
          width: 50,
          child: Stack(
            children: [
              const Positioned(
                top: 16,
                child: Icon(
                  Icons.shopping_basket_outlined,
                  size: 24,
                ),
              ),
              productProvider.cart.isNotEmpty
                  ? Positioned(
                top: 8,
                right: 12,
                child: ClipOval(
                  child: Container(
                    width: 16,
                    height: 16,
                    color: Colors.red,
                    child: Center(
                      child: TextWidget(
                        productProvider.cart.length.toString(),
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
                ),
              )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    ],
    title: const SizedBox(),
  );
}