// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the Videos Screen

import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/utils/youtube_util.dart';
import 'package:provider/provider.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({Key? key}) : super(key: key);

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  var videoID = [
    "qOVebetilXY",
    "NGvwKanKdL8",
    "lwnO0yfHmNA",
    "EPP4G4B3Dkc",
    "5ONx1qQgIM4",
    "XUZ1CLIigN4",
    "HztmSwvBu2U",
    "fXEkPeSBr-Q",
    "Hp-lGxwPUnI",
    "gKqSayojRkg",
    "6CiQEfiZv9s",
    "h7rUI6NWtgk",
    "8FHgrv68cwY",
    "ItyAEbCIjCU",
    "oB70suAIF6A",
    "A_OAyYiya40",
    "6aZ3sV7a1Lo",
    "40hITd7mvXY",
    "jxfrZV1kkhM",
    "0RFumQ8Q8f8",
    "3RyjUwzXWTs",
    "-TfASLwVlUs",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        toolbarHeight: kToolbarHeight,
        elevation: 0,
        title: TextWidget(
          'Videos',
          size: Theme.of(context).textTheme.titleMedium?.fontSize,
          weight: FontWeight.w700,
        ),
      ),
      body: Consumer<ProfileProvider>(builder: (context, productProvider, _) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 16, right: 54),
              child: Text(
                "Get yourself updates with the latest trends and technologies to help you make a better bussiness and produce",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () {
                        var url =
                            "https://www.youtube.com/watch?v=${videoID[index]}";

                        YoutubeUtil().launchYoutubeVideo(url);
                      },
                      child: Stack(children: [
                        Image.network(
                          "https://img.youtube.com/vi/${videoID[index]}/hqdefault.jpg",
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        ),
                        Container(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.2),
                        ),
                        Center(
                          child: Icon(
                            Icons.play_circle_outline_rounded,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.3),
                            size: 36,
                          ),
                        ),
                        const Center(
                          child: Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ]),
                    ),
                  );
                },
                itemCount: videoID.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16),
              ),
            ),
          ],
        );
        // return Column(children: [
        //   Expanded(
        //     child: Center(
        //       child: Padding(
        //         padding: const EdgeInsets.all(24.0),
        //         child: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             const Image(
        //                 image: AssetImage('assets/images/empty_basket.png')),
        //             const SizedBox(
        //               height: 20,
        //             ),
        //             TextWidget(
        //               'Oops!',
        //               weight: FontWeight.w800,
        //               size: Theme.of(context).textTheme.titleLarge?.fontSize,
        //             ),
        //             const SizedBox(
        //               height: 12,
        //             ),
        //             Opacity(
        //               opacity: 0.7,
        //               child: TextWidget(
        //                 'We don\'t have any recommended videos for you at this moment',
        //                 flow: TextOverflow.visible,
        //                 align: TextAlign.center,
        //                 size: Theme.of(context).textTheme.bodyMedium?.fontSize,
        //               ),
        //             ),
        //             const SizedBox(
        //               height: 40,
        //             ),
        //             Padding(
        //               padding: const EdgeInsets.symmetric(horizontal: 32),
        //               child: ElevatedButtonWidget(
        //                 trailingIcon: Icons.ios_share_rounded,
        //                 buttonName: 'Recommend your Farm'.toUpperCase(),
        //                 textStyle: FontWeight.w800,
        //                 borderRadius: 8,
        //                 innerPadding: 0.03,
        //                 onClick: () {
        //                   // productProvider.changeScreen(1);
        //                 },
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ]);
      }),
    );
  }
}
