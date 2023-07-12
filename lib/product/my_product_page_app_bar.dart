import 'package:flutter/material.dart';

import '../reusable_widgets/text_widget.dart';
import '../utils/sort_filter.dart';

myProductsPageAppBar(context) {
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.background,
    toolbarHeight: kToolbarHeight,
    elevation: 0,
    // actions: [
    //   PopupMenuButton(
    //       offset: const Offset(-5, 0),
    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    //       icon: const Icon(
    //         Icons.sort_rounded,
    //       ),
    //       itemBuilder: (context) {
    //         Sort sort = Sort.name;
    //         Filter filter = Filter.inStock;
    //         return [
    //           PopupMenuItem(child: StatefulBuilder(
    //             builder: (context, setMenuState) {
    //               return Column(
    //                 children: [
    //                   const PopupMenuItem(child: Text("Sort by")),
    //                   PopupMenuItem(
    //                       child: Column(
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: [
    //                       Row(
    //                         children: [
    //                           Radio<Sort>(
    //                               activeColor:
    //                                   Theme.of(context).colorScheme.primary,
    //                               value: Sort.name,
    //                               groupValue: sort,
    //                               onChanged: (_) {
    //                                 setMenuState(() {
    //                                   sort = _ ?? sort;
    //                                 });
    //                               }),
    //                           const SizedBox(width: 16),
    //                           const Icon(Icons.abc_rounded),
    //                           const SizedBox(width: 8),
    //                           const Text("Name")
    //                         ],
    //                       ),
    //                       Row(
    //                         children: [
    //                           Radio<Sort>(
    //                               activeColor:
    //                                   Theme.of(context).colorScheme.primary,
    //                               value: Sort.date,
    //                               groupValue: sort,
    //                               onChanged: (_) {
    //                                 setMenuState(() {
    //                                   sort = _ ?? sort;
    //                                 });
    //                               }),
    //                           const SizedBox(width: 16),
    //                           const Icon(Icons.calendar_month_rounded),
    //                           const SizedBox(width: 8),
    //                           const Text("Date")
    //                         ],
    //                       ),
    //                     ],
    //                   )),
    //                   const PopupMenuItem(child: Text("Filter by")),
    //                   PopupMenuItem(
    //                       child: Column(
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: [
    //                       Row(
    //                         children: [
    //                           Radio<Filter>(
    //                               activeColor:
    //                                   Theme.of(context).colorScheme.primary,
    //                               value: Filter.inStock,
    //                               groupValue: filter,
    //                               onChanged: (_) {
    //                                 setMenuState(() {
    //                                   filter = _ ?? filter;
    //                                 });
    //                               }),
    //                           const SizedBox(width: 16),
    //                           const Icon(Icons.inventory_2_rounded),
    //                           const SizedBox(width: 8),
    //                           const Text("In Stock")
    //                         ],
    //                       ),
    //                       Row(
    //                         children: [
    //                           Radio<Filter>(
    //                               activeColor:
    //                                   Theme.of(context).colorScheme.primary,
    //                               value: Filter.outOfStock,
    //                               groupValue: filter,
    //                               onChanged: (_) {
    //                                 setMenuState(() {
    //                                   filter = _ ?? filter;
    //                                 });
    //                               }),
    //                           const SizedBox(width: 16),
    //                           const Icon(Icons.cancel_outlined),
    //                           const SizedBox(width: 8),
    //                           const Text("Out Of Stock")
    //                         ],
    //                       ),
    //                     ],
    //                   )),
    //                 ],
    //               );
    //             },
    //           ))
    //         ];
    //       },
    //       onSelected: (value) {
    //         //
    //       }),
    // ],
    title: TextWidget(
      'My Products',
      size: Theme.of(context).textTheme.titleMedium?.fontSize,
      weight: FontWeight.w700,
    ),
  );
}
