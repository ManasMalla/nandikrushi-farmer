// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the Add Product Screen

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nandikrushi_farmer/nav_host.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_provider.dart';
import 'package:nandikrushi_farmer/product/product_controller.dart';
import 'package:nandikrushi_farmer/product/product_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/elevated_button.dart';
import 'package:nandikrushi_farmer/reusable_widgets/snackbar.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/reusable_widgets/textfield_widget.dart';
import 'package:nandikrushi_farmer/utils/custom_color_util.dart';
import 'package:nandikrushi_farmer/utils/firebase_storage_utils.dart';
import 'package:nandikrushi_farmer/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../reusable_widgets/loader_screen.dart';
import '../utils/login_utils.dart';
import 'no_ingredients_dialog.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  ProductController addProductController = ProductController();
  Map<String, bool> selectedIngredients = {};
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(builder: (context, loginProvider, __) {
      return Consumer<ProductProvider>(builder: (context, productProvider, _) {
        return LayoutBuilder(builder: (context, constraints) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: Consumer<ProfileProvider>(
                builder: (context, profileProvider, _) {
              print(productProvider.subcategories);
              print(productProvider.storeCategories);
              print(productProvider.storeSubCategories);
              print(productProvider.storeUnits);
              print(productProvider.products
                  .map((element) => element.categoryId));
              return WillPopScope(
                onWillPop: () {
                  productProvider.getAllProducts(
                      showMessage: (_) {
                        snackbar(context, _);
                      },
                      profileProvider: profileProvider);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NandikrushiNavHost(
                        userId: profileProvider.userIdForAddress,
                        shouldUpdateField: false,
                      ),
                    ),
                  );

                  return Future.value(true);
                },
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Stack(children: [
                        const Positioned(
                          top: -30,
                          left: 200,
                          child: Image(
                            image: AssetImage("assets/images/ic_farmer.png"),
                          ),
                        ),
                        SizedBox(
                          height: 140,
                          child: Container(
                            margin: const EdgeInsets.only(top: 72),
                            padding: const EdgeInsets.symmetric(horizontal: 42),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nandikrushi",
                                  style: TextStyle(
                                      color: calculateContrast(
                                                  const Color(0xFF769F77),
                                                  createMaterialColor(
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .primary)
                                                      .shade700) >
                                              3
                                          ? createMaterialColor(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary)
                                              .shade700
                                          : createMaterialColor(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary)
                                              .shade100,
                                      fontFamily: 'Samarkan',
                                      fontSize: getProportionateHeight(
                                          32, constraints)),
                                ),
                                TextWidget(
                                  "Add Product".toUpperCase(),
                                  color: Theme.of(context).colorScheme.primary,
                                  weight: FontWeight.bold,
                                  size: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.fontSize,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 140,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 54,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 32),
                                        padding: const EdgeInsets.only(
                                            top: 8, bottom: 12),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(18)),
                                        child:
                                            addProductController
                                                    .productImage.isEmpty
                                                ? Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        iconSize: 64,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        onPressed: () {
                                                          showModalBottomSheet(
                                                              context: context,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12)),
                                                              builder:
                                                                  (context) {
                                                                return Container(
                                                                  height: 180,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(16),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      const TextWidget(
                                                                        "Product Image",
                                                                        size:
                                                                            27,
                                                                        weight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      const TextWidget(
                                                                        "Choose an image of the product from one of the following sources",
                                                                        flow: TextOverflow
                                                                            .visible,
                                                                        size:
                                                                            16,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                      const Spacer(),
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            flex:
                                                                                3,
                                                                            child:
                                                                                ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Theme.of(context).colorScheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                                                              onPressed: () async {
                                                                                var image = await ImagePicker().pickImage(source: ImageSource.gallery);
                                                                                if (image != null) {
                                                                                  addProductController.productImage.add(image);
                                                                                  Navigator.maybeOf(context)?.maybePop();
                                                                                } else {
                                                                                  Navigator.maybeOf(context)?.maybePop();
                                                                                }
                                                                                setState(() {});
                                                                              },
                                                                              child: const TextWidget(
                                                                                "Gallery",
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const Spacer(),
                                                                          Expanded(
                                                                            flex:
                                                                                3,
                                                                            child:
                                                                                ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Theme.of(context).colorScheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                                                              onPressed: () async {
                                                                                var image = await ImagePicker().pickImage(source: ImageSource.camera);
                                                                                if (image != null) {
                                                                                  addProductController.productImage.add(image);
                                                                                  Navigator.maybeOf(context)?.maybePop();
                                                                                } else {
                                                                                  Navigator.maybeOf(context)?.maybePop();
                                                                                }
                                                                                setState(() {});
                                                                              },
                                                                              child: const TextWidget("Camera", color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              });
                                                        },
                                                        splashRadius: 36,
                                                        icon: const Icon(Icons
                                                            .add_a_photo_rounded),
                                                      ),
                                                      TextWidget(
                                                        "Add Product Image",
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                            .withOpacity(0.7),
                                                        weight: FontWeight.w500,
                                                        size: 18,
                                                      )
                                                    ],
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          SizedBox(
                                                            height: 128,
                                                            child: ListView
                                                                .builder(
                                                                    itemCount: addProductController
                                                                        .productImage
                                                                        .length,
                                                                    shrinkWrap:
                                                                        true,
                                                                    primary:
                                                                        false,
                                                                    scrollDirection:
                                                                        Axis
                                                                            .horizontal,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      var image =
                                                                          addProductController
                                                                              .productImage[index];
                                                                      return SizedBox(
                                                                        height:
                                                                            128,
                                                                        width:
                                                                            128,
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Stack(
                                                                            children: [
                                                                              Center(
                                                                                child: SizedBox(
                                                                                  height: 120,
                                                                                  width: 120,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Center(
                                                                                      child: ClipOval(
                                                                                          child: Image.file(
                                                                                        File(image?.path ?? ""),
                                                                                        height: 120,
                                                                                        width: 120,
                                                                                        fit: BoxFit.cover,
                                                                                      )),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Positioned(
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
                                                                                  child: IconButton(
                                                                                    onPressed: () {
                                                                                      showModalBottomSheet(
                                                                                          context: context,
                                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                                                          builder: (context) {
                                                                                            return Container(
                                                                                              height: 180,
                                                                                              padding: const EdgeInsets.all(16),
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  const TextWidget(
                                                                                                    "Product Image",
                                                                                                    size: 27,
                                                                                                    weight: FontWeight.w500,
                                                                                                  ),
                                                                                                  const SizedBox(
                                                                                                    height: 10,
                                                                                                  ),
                                                                                                  const TextWidget(
                                                                                                    "Choose an image of the product from one of the following sources",
                                                                                                    flow: TextOverflow.visible,
                                                                                                    size: 16,
                                                                                                    color: Colors.grey,
                                                                                                  ),
                                                                                                  const Spacer(),
                                                                                                  Row(
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                        flex: 3,
                                                                                                        child: ElevatedButton(
                                                                                                          style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Theme.of(context).colorScheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                                                                                          onPressed: () async {
                                                                                                            var image = await ImagePicker().pickImage(source: ImageSource.gallery);
                                                                                                            if (image != null) {
                                                                                                              addProductController.productImage[index] = (image);
                                                                                                              Navigator.maybeOf(context)?.maybePop();
                                                                                                            } else {
                                                                                                              Navigator.maybeOf(context)?.maybePop();
                                                                                                            }
                                                                                                            setState(() {});
                                                                                                          },
                                                                                                          child: const TextWidget(
                                                                                                            "Gallery",
                                                                                                            color: Colors.white,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                      const Spacer(),
                                                                                                      Expanded(
                                                                                                        flex: 3,
                                                                                                        child: ElevatedButton(
                                                                                                          style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Theme.of(context).colorScheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                                                                                          onPressed: () async {
                                                                                                            var image = await ImagePicker().pickImage(source: ImageSource.camera);
                                                                                                            if (image != null) {
                                                                                                              addProductController.productImage[index] = (image);
                                                                                                              Navigator.maybeOf(context)?.maybePop();
                                                                                                            } else {
                                                                                                              Navigator.maybeOf(context)?.maybePop();
                                                                                                            }
                                                                                                            setState(() {});
                                                                                                          },
                                                                                                          child: const TextWidget("Camera", color: Colors.white),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            );
                                                                                          });
                                                                                    },
                                                                                    icon: const Icon(
                                                                                      Icons.edit_rounded,
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }),
                                                          ),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                                shape: BoxShape
                                                                    .circle),
                                                            child: IconButton(
                                                              onPressed: () {
                                                                showModalBottomSheet(
                                                                    context:
                                                                        context,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                12)),
                                                                    builder:
                                                                        (context) {
                                                                      return Container(
                                                                        height:
                                                                            180,
                                                                        padding:
                                                                            const EdgeInsets.all(16),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            const TextWidget(
                                                                              "Product Image",
                                                                              size: 27,
                                                                              weight: FontWeight.w500,
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            const TextWidget(
                                                                              "Choose an image of the product from one of the following sources",
                                                                              flow: TextOverflow.visible,
                                                                              size: 18,
                                                                              color: Colors.grey,
                                                                            ),
                                                                            const Spacer(),
                                                                            Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  flex: 3,
                                                                                  child: ElevatedButton(
                                                                                    style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Theme.of(context).colorScheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                                                                    onPressed: () async {
                                                                                      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
                                                                                      if (image != null) {
                                                                                        addProductController.productImage.add(image);
                                                                                      } else {
                                                                                        Navigator.maybeOf(context)?.maybePop();
                                                                                      }

                                                                                      setState(() {});
                                                                                    },
                                                                                    child: const TextWidget(
                                                                                      "Gallery",
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                const Spacer(),
                                                                                Expanded(
                                                                                  flex: 3,
                                                                                  child: ElevatedButton(
                                                                                    style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Theme.of(context).colorScheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                                                                    onPressed: () async {
                                                                                      var image = await ImagePicker().pickImage(source: ImageSource.camera);
                                                                                      if (image != null) {
                                                                                        addProductController.productImage.add(image);
                                                                                      } else {
                                                                                        Navigator.maybeOf(context)?.maybePop();
                                                                                      }
                                                                                      setState(() {});
                                                                                    },
                                                                                    child: const TextWidget("Camera", color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    });
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .add_a_photo_rounded,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.all(32),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const TextWidget(
                                                  "Product Information",
                                                  weight: FontWeight.bold,
                                                  size: 18,
                                                ),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                TextFieldWidget(
                                                  controller:
                                                      addProductController
                                                              .formControllers[
                                                          'product-name'],
                                                  label: 'Product Name',
                                                ),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: DropdownButtonFormField<
                                                              String>(
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        16),
                                                            focusedBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary)),
                                                          ),
                                                          isExpanded: true,
                                                          hint: Text(
                                                            'Category',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium,
                                                          ),
                                                          dropdownColor: ElevationOverlay.colorWithOverlay(
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .surface,
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                              2.0),
                                                          value: loginProvider.isFarmer ||
                                                                  selectedIngredients
                                                                      .isEmpty ||
                                                                  selectedIngredients.length >
                                                                      1
                                                              ? addProductController
                                                                  .selectedCategory
                                                              : productProvider
                                                                  .products
                                                                  .where((element) => element.productId.toString() == selectedIngredients.keys.first)
                                                                  .first
                                                                  .category,
                                                          items: selectedIngredients.isEmpty || selectedIngredients.length > 1
                                                              ? (selectedIngredients.isEmpty ? productProvider.categories : productProvider.storeCategories)
                                                                  .keys
                                                                  .map((e) => DropdownMenuItem(
                                                                        value:
                                                                            e,
                                                                        child:
                                                                            Text(
                                                                          e,
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyMedium,
                                                                        ),
                                                                      ))
                                                                  .toList()
                                                              : [
                                                                  DropdownMenuItem(
                                                                    value: productProvider
                                                                        .products
                                                                        .where((element) =>
                                                                            element.productId.toString() ==
                                                                            selectedIngredients.keys.first)
                                                                        .first
                                                                        .category,
                                                                    child: Text(
                                                                      productProvider
                                                                              .products
                                                                              .where((element) => element.productId.toString() == selectedIngredients.keys.first)
                                                                              .first
                                                                              .category ??
                                                                          "Basket",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyMedium,
                                                                    ),
                                                                  )
                                                                ],
                                                          onChanged: (_) {
                                                            setState(() {
                                                              addProductController
                                                                  .selectedCategory = _;
                                                            });
                                                          }),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Expanded(
                                                      child: DropdownButtonFormField<
                                                              String>(
                                                          decoration:
                                                              const InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            16),
                                                            focusedBorder:
                                                                UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Color(0xFF006838))),
                                                          ),
                                                          isExpanded: true,
                                                          hint: Text(
                                                            'Sub-Category',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium,
                                                          ),
                                                          dropdownColor:
                                                              ElevationOverlay.colorWithOverlay(
                                                                  Theme.of(context)
                                                                      .colorScheme
                                                                      .surface,
                                                                  Theme.of(context)
                                                                      .colorScheme
                                                                      .primary,
                                                                  2.0),
                                                          value: loginProvider.isFarmer || selectedIngredients.isEmpty || selectedIngredients.length > 1
                                                              ? addProductController
                                                                  .selectedSubCategory
                                                              : productProvider
                                                                  .products
                                                                  .where((element) => element.productId.toString() == selectedIngredients.keys.first)
                                                                  .first
                                                                  .subcategory,
                                                          items: selectedIngredients.isEmpty || selectedIngredients.length > 1
                                                              ? (selectedIngredients.isEmpty ? (productProvider.subcategories[productProvider.categories[addProductController.selectedCategory]]?.map((e) => e.keys.first) ?? []) : (productProvider.storeSubCategories[productProvider.storeCategories[addProductController.selectedCategory]]?.keys.toList() ?? []))
                                                                  .map((e) => DropdownMenuItem(
                                                                        value:
                                                                            e,
                                                                        child:
                                                                            Text(
                                                                          e,
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyMedium,
                                                                        ),
                                                                      ))
                                                                  .toList()
                                                              : [
                                                                  DropdownMenuItem(
                                                                    value: productProvider
                                                                        .products
                                                                        .where((element) =>
                                                                            element.productId.toString() ==
                                                                            selectedIngredients.keys.first)
                                                                        .first
                                                                        .subcategory,
                                                                    child: Text(
                                                                      productProvider
                                                                              .products
                                                                              .where((element) => element.productId.toString() == selectedIngredients.keys.first)
                                                                              .first
                                                                              .subcategory ??
                                                                          "Basket",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyMedium,
                                                                    ),
                                                                  )
                                                                ],
                                                          onChanged: (_) {
                                                            setState(() {
                                                              addProductController
                                                                  .selectedSubCategory = _;
                                                            });
                                                          }),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                loginProvider.isRestaurant ||
                                                        loginProvider.isStore
                                                    ? productProvider
                                                            .myPurchases.isEmpty
                                                        ? NoIngredientsDialog()
                                                        : SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: DataTable(
                                                                border: TableBorder
                                                                    .all(
                                                                  width: 2.0,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .background,
                                                                ),
                                                                headingRowColor: MaterialStateColor.resolveWith((states) =>
                                                                    Theme.of(context)
                                                                        .colorScheme
                                                                        .primary),
                                                                headingTextStyle:
                                                                    MaterialStateTextStyle.resolveWith(
                                                                        (states) =>
                                                                            Theme.of(context).textTheme.titleMedium ?? TextStyle()),
                                                                columns: const [
                                                                  DataColumn(
                                                                      label: Text(
                                                                          "Select")),
                                                                  DataColumn(
                                                                      label: Text(
                                                                          "Ingredient")),
                                                                  DataColumn(
                                                                      label: Text(
                                                                          "Farmer")),
                                                                  DataColumn(
                                                                      label: Text(
                                                                          "Date of Purchase")),
                                                                  DataColumn(
                                                                      label: Text(
                                                                          "Qty")),
                                                                ],
                                                                rows: productProvider.myPurchases
                                                                    .where((element) => (int.tryParse(element["products"][0]["order_status_id"]) ?? 0) >= 4)
                                                                    .fold<List<dynamic>>([], (previousValue, element) {
                                                                      var tempList =
                                                                          previousValue;
                                                                      (element.values.toList()[1] as List<
                                                                              dynamic>)
                                                                          .forEach(
                                                                              (element1) {
                                                                        var tempElement =
                                                                            element1;
                                                                        tempElement["farmerName"] = element
                                                                            .values
                                                                            .toList()[2];
                                                                        tempElement["dateOfPurchase"] = element
                                                                            .values
                                                                            .toList()[3];
                                                                        if (tempList
                                                                            .map((e) =>
                                                                                e["product_name"])
                                                                            .contains(tempElement["product_name"])) {
                                                                        } else {
                                                                          tempList
                                                                              .add(tempElement);
                                                                        }
                                                                      });
                                                                      return tempList;
                                                                    })
                                                                    .toList()
                                                                    .asMap()
                                                                    .map((index, e) => MapEntry(
                                                                        index,
                                                                        DataRow(color: MaterialStateColor.resolveWith((states) => Theme.of(context).colorScheme.primaryContainer.withOpacity(index % 2 == 0 ? 1.0 : 0.6)), cells: [
                                                                          DataCell(
                                                                              Checkbox(
                                                                            value: selectedIngredients.entries.where((element) => element.key == e["product_id"]).isNotEmpty
                                                                                ? selectedIngredients.entries.where((element) => element.key == e["product_id"]).first.value
                                                                                : false,
                                                                            onChanged:
                                                                                (_) {
                                                                              setState(() {
                                                                                addProductController.selectedCategory = null;
                                                                                addProductController.selectedSubCategory = null;
                                                                                if (selectedIngredients.entries.where((element) => element.key == e["product_id"]).isNotEmpty) {
                                                                                  selectedIngredients.remove(e["product_id"]);
                                                                                } else {
                                                                                  selectedIngredients[e["product_id"]] = _ ?? !selectedIngredients.entries.where((element) => element.key == e["product_id"]).first.value;
                                                                                }
                                                                              });
                                                                            },
                                                                          )),
                                                                          DataCell(
                                                                              Text(e["product_name"])),
                                                                          DataCell(
                                                                              Text(capitalize(e["farmerName"]))),
                                                                          DataCell(Text(DateFormat("hh:mm a, dd MMM yyyy").format(DateTime.fromMillisecondsSinceEpoch((int.tryParse(e["dateOfPurchase"]) ?? DateTime.now().millisecondsSinceEpoch) *
                                                                              1000)))),
                                                                          DataCell(
                                                                              Text(e["quantity"])),
                                                                        ])))
                                                                    .values
                                                                    .toList()),
                                                          )
                                                    : const SizedBox(),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: DropdownButtonFormField<
                                                              String>(
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        18),
                                                            focusedBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary)),
                                                          ),
                                                          dropdownColor:
                                                              ElevationOverlay.colorWithOverlay(
                                                                  Theme.of(context)
                                                                      .colorScheme
                                                                      .surface,
                                                                  Theme.of(context)
                                                                      .colorScheme
                                                                      .primary,
                                                                  2.0),
                                                          isExpanded: true,
                                                          hint: Text(
                                                            'Units',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium,
                                                          ),
                                                          value: loginProvider.isFarmer ||
                                                                  selectedIngredients
                                                                      .isEmpty ||
                                                                  selectedIngredients.length >
                                                                      1
                                                              ? addProductController
                                                                  .selectedUnits
                                                              : productProvider.products.where((element) => element.productId.toString() == selectedIngredients.keys.first).first.units,
                                                          items: selectedIngredients.isEmpty || selectedIngredients.length > 1
                                                              ? (selectedIngredients.isEmpty ? (productProvider.units[productProvider.categories[addProductController.selectedCategory]])?.values : (productProvider.storeUnits[productProvider.storeCategories[addProductController.selectedCategory]])?.values)
                                                                  ?.map((e) => DropdownMenuItem(
                                                                        value:
                                                                            e,
                                                                        child:
                                                                            Text(
                                                                          e,
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyMedium,
                                                                        ),
                                                                      ))
                                                                  .toList()
                                                              : [
                                                                  DropdownMenuItem(
                                                                    value: productProvider
                                                                        .products
                                                                        .where((element) =>
                                                                            element.productId.toString() ==
                                                                            selectedIngredients.keys.first)
                                                                        .first
                                                                        .units,
                                                                    child: Text(
                                                                      productProvider
                                                                              .products
                                                                              .where((element) => element.productId.toString() == selectedIngredients.keys.first)
                                                                              .first
                                                                              .units ??
                                                                          "BOX",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyMedium,
                                                                    ),
                                                                  )
                                                                ],
                                                          onChanged: (_) {
                                                            setState(() {
                                                              addProductController
                                                                  .selectedUnits = _;
                                                            });
                                                          }),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Expanded(
                                                      child: TextFieldWidget(
                                                        controller:
                                                            addProductController
                                                                    .formControllers[
                                                                'quantity'],
                                                        label: 'Quantity',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            TextFieldWidget(
                                              shouldShowCurreny: true,
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: addProductController
                                                  .formControllers['price'],
                                              label: 'Price',
                                            ),
                                            const SizedBox(
                                              height: 27,
                                            ),
                                            const TextWidget(
                                              "Product Description",
                                              weight: FontWeight.bold,
                                              size: 18,
                                            ),
                                            const SizedBox(
                                              height: 32,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              height: 150,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              child: TextFieldWidget(
                                                hint:
                                                    "Please share about your product",
                                                shouldShowBorder: false,
                                                keyboardType:
                                                    TextInputType.text,
                                                controller: addProductController
                                                        .formControllers[
                                                    'description'],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    margin: const EdgeInsets.only(bottom: 16),
                                    child: ElevatedButtonWidget(
                                      onClick: () async {
                                        profileProvider.fetchingDataType =
                                            "add your product";
                                        profileProvider.showLoader();
                                        List<String> urls = [];
                                        await Future.forEach(
                                            addProductController.productImage,
                                            (element) async {
                                          String urlData =
                                              await uploadFilesToCloud(element,
                                                  cloudLocation:
                                                      "product_images",
                                                  fileType: ".png");
                                          urls.add(urlData);
                                        });
                                        if (urls.isNotEmpty) {
                                          addProductController.addProduct(
                                            (loginProvider.isFarmer ||
                                                        selectedIngredients
                                                            .isEmpty ||
                                                        selectedIngredients
                                                                .length >
                                                            1
                                                    ? addProductController
                                                        .selectedCategory
                                                    : productProvider.products
                                                        .where((element) =>
                                                            element.productId
                                                                .toString() ==
                                                            selectedIngredients
                                                                .keys.first)
                                                        .first
                                                        .category) ??
                                                "",
                                            (loginProvider.isFarmer ||
                                                        selectedIngredients
                                                            .isEmpty ||
                                                        selectedIngredients
                                                                .length >
                                                            1
                                                    ? addProductController
                                                        .selectedSubCategory
                                                    : productProvider.products
                                                        .where((element) =>
                                                            element.productId
                                                                .toString() ==
                                                            selectedIngredients
                                                                .keys.first)
                                                        .first
                                                        .subcategory) ??
                                                "",
                                                (loginProvider.isFarmer ||
                                                                  selectedIngredients
                                                                      .isEmpty ||
                                                                  selectedIngredients.length >
                                                                      1
                                                              ? addProductController
                                                                  .selectedUnits
                                                              : productProvider.products.where((element) => element.productId.toString() == selectedIngredients.keys.first).first.units) ?? "",
                                            context,
                                            urls,
                                            productProvider
                                                    .units[addProductController
                                                        .selectedCategory]
                                                    ?.values
                                                    .toList() ??
                                                [],
                                            selectedIngredients,
                                            (_) {
                                              snackbar(context, _);
                                            },
                                            productProvider,
                                            profileProvider,
                                          );
                                        } else {
                                          snackbar(context,
                                              "Please upload a picture of the product!");
                                          profileProvider.hideLoader();
                                        }
                                      },

                                      height: 54,
                                      borderRadius: 8,
                                      buttonName: "Submit".toUpperCase(),
                                      innerPadding: 0.02,
                                      // textStyle: FontWeight.bold,
                                      trailingIcon: Icons.check_rounded,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ]),
                    ),
                    profileProvider.shouldShowLoader
                        ? LoaderScreen(profileProvider)
                        : const SizedBox(),
                  ],
                ),
              );
            }),
          );
        });
      });
    });
  }
}
