import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/product/address_bottom_sheet.dart';
import 'package:nandikrushi_farmer/product/product_card.dart';
import 'package:nandikrushi_farmer/product/product_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/elevated_button.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:provider/provider.dart';

class BasketScreen extends StatelessWidget {
  const BasketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, productProvider, _) {
      var items = productProvider.cart;
      return Scaffold(
        backgroundColor: items.isNotEmpty ? null : Colors.white,
        appBar: AppBar(
          toolbarHeight: kToolbarHeight,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.shopping_basket_rounded,
                color: Colors.grey[900],
              )),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                'Basket',
                size: Theme.of(context).textTheme.titleMedium?.fontSize,
                color: Colors.grey[900],
                weight: FontWeight.w700,
              ),
              items.isNotEmpty
                  ? TextWidget(
                      '${items.length} items',
                      size: Theme.of(context).textTheme.bodySmall?.fontSize,
                      color: Colors.grey[700],
                      weight: FontWeight.w500,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        body: items.isNotEmpty
            ? SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListView.separated(
                      separatorBuilder: ((context, index) {
                        return const Divider();
                      }),
                      primary: false,
                      shrinkWrap: true,
                      itemCount: items.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: ((context, index) {
                        return ProductCard(
                            type: CardType.product,
                            productId: items[index]["product_id"] ?? "",
                            productName: items[index]["name"] ?? "",
                            productDescription: "",
                            imageURL: items[index]["url"] ?? "",
                            price:
                                double.tryParse(items[index]["price"] ?? "") ??
                                    0.0,
                            units: items[index]["unit"] ?? "",
                            location: items[index]["place"] ?? "");
                      }),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 16, left: 24, right: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            'Delivery Charge',
                            weight: FontWeight.w500,
                            size:
                                Theme.of(context).textTheme.bodyLarge?.fontSize,
                          ),
                          TextWidget(
                            (4000 -
                                        (items
                                            .map((e) =>
                                                (double.tryParse(
                                                        e['price'] ?? "0") ??
                                                    0) *
                                                (double.tryParse(
                                                        e['quantity'] ?? "0") ??
                                                    0))
                                            .reduce(
                                              (value, element) =>
                                                  value + element,
                                            ))) <=
                                    0
                                ? 'N/A'
                                : 'Rs. 100.00',
                            weight: FontWeight.w600,
                            size:
                                Theme.of(context).textTheme.bodyLarge?.fontSize,
                          ),
                        ],
                      ),
                    ),
                    (4000 -
                                (items
                                    .map((e) =>
                                        (double.tryParse(e['price'] ?? "0") ??
                                            0) *
                                        (double.tryParse(
                                                e['quantity'] ?? "0") ??
                                            0))
                                    .reduce(
                                      (value, element) => value + element,
                                    ))) <=
                            0
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 16),
                            child: SizedBox(
                              child: TextWidget(
                                '!  Add items for Rs.${(4000 - (items.map((e) => (double.tryParse(e['price'] ?? "0") ?? 0) * (double.tryParse(e['quantity'] ?? "0") ?? 0)).reduce(
                                      (value, element) => value + element,
                                    ) + 100.00)).toStringAsFixed(2)} or more to avoid delivery charges',
                                color: Colors.red,
                                size: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.fontSize,
                                weight: FontWeight.bold,
                                flow: TextOverflow.visible,
                              ),
                            ),
                          ),
                    const Divider(),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 16, left: 24, right: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            'Total'.toUpperCase(),
                            weight: FontWeight.w600,
                            size:
                                Theme.of(context).textTheme.bodyLarge?.fontSize,
                          ),
                          TextWidget(
                            'Rs. ${(items.map((e) => (double.tryParse(e['price'] ?? "0") ?? 0) * (double.tryParse(e['quantity'] ?? "0") ?? 0)).reduce(
                                  (value, element) => value + element,
                                ) + 100.00).toStringAsFixed(2)}',
                            weight: FontWeight.w700,
                            size:
                                Theme.of(context).textTheme.bodyLarge?.fontSize,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 16, left: 24, right: 24),
                        child: Consumer<ProfileProvider>(
                            builder: (context, profileProvider, _) {
                          return ElevatedButtonWidget(
                            borderRadius: 8,
                            onClick: () {
                              showAddressesBottomSheet(
                                  context, profileProvider, Theme.of(context));
                            },
                            height: 54,
                            // borderRadius: 16,
                            bgColor: Colors.grey.shade200,
                            textColor: Colors.grey.shade700,
                            textStyle: FontWeight.bold,
                            buttonName: "Confirm Order".toUpperCase(),
                            trailingIcon: Icons.arrow_forward,
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Image(
                          image: AssetImage('assets/images/empty_basket.png')),
                      const SizedBox(
                        height: 20,
                      ),
                      TextWidget(
                        'Basket Is Empty',
                        weight: FontWeight.w800,
                        size: Theme.of(context).textTheme.titleLarge?.fontSize,
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
                        size: Theme.of(context).textTheme.bodyMedium?.fontSize,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 42),
                        child: ElevatedButtonWidget(
                          bgColor: Theme.of(context).primaryColor,
                          trailingIcon: Icons.add_rounded,
                          buttonName: 'Shop Items'.toUpperCase(),
                          textColor: Colors.white,
                          textStyle: FontWeight.w800,
                          borderRadius: 8,
                          innerPadding: 0.03,
                          onClick: () {
                            productProvider.changeScreen(1);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
      );
    });
  }
}