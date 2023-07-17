import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/utils/size_config.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final Color? bgColor;
  final Color? textColor;
  final String? buttonName;
  final double? borderRadius;
  final double? minWidth;
  final double? height;
  final TextStyle? style;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final VoidCallback? onClick;
  final FontWeight? textStyle;
  final double? elevation;
  final double? innerPadding;
  final bool? center;
  final Color? borderSideColor;
  final Color? iconColor;

  const ElevatedButtonWidget(
      {Key? key,
      this.buttonName,
      this.iconColor,
      this.bgColor,
      this.textColor,
      this.borderSideColor,
      this.borderRadius,
      this.minWidth,
      this.height,
      this.style,
      this.leadingIcon,
      this.trailingIcon,
      this.textStyle,
      this.onClick,
      this.elevation,
      this.innerPadding,
      this.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
        child: SizedBox(
          width: minWidth ?? double.infinity,
          height: height ?? 50.0,
          child: ElevatedButton(
              onPressed: () {
                return onClick!();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(bgColor == Colors.white ? 0.3 : 0.8);
                    }
                    return (bgColor ??
                        Theme.of(context)
                            .colorScheme
                            .primary); // Use the component's default.
                  },
                ),
                elevation: MaterialStateProperty.all(elevation ?? 0),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius ?? 0),
                    side: borderSideColor != null
                        ? BorderSide(
                            color: borderSideColor!,
                          )
                        : BorderSide.none,
                  ),
                ),
              ),
              child: LayoutBuilder(builder: (context, constraints) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateWidth(428, constraints) *
                          (innerPadding ?? 0.01)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (leadingIcon != null)
                        buildLeadingIcon(Icon(
                          leadingIcon,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: Theme.of(context).textTheme.button?.fontSize,
                        )),
                      if (center == true)
                        buildLeadingIcon(Icon(leadingIcon,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size:
                                Theme.of(context).textTheme.button?.fontSize)),
                      TextWidget(
                        buttonName ?? 'Button',
                        size: Theme.of(context).textTheme.button?.fontSize,
                        weight: textStyle ??
                            Theme.of(context).textTheme.button?.fontWeight,
                        color: textColor ??
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      if (trailingIcon != null)
                        buildTrailingIcon(Icon(
                          trailingIcon,
                          color: iconColor ??
                              Theme.of(context).colorScheme.onPrimary,
                          size: Theme.of(context).textTheme.button?.fontSize,
                        )),
                      if (center == true)
                        buildLeadingIcon(Icon(
                          leadingIcon,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: Theme.of(context).textTheme.button?.fontSize,
                        )),
                    ],
                  ),
                );
              })),
        ),
      ),
    );
  }
}

Widget buildLeadingIcon(Widget? leadingIcon) {
  if (leadingIcon != null) {
    return Row(
      children: <Widget>[
        leadingIcon,
        const SizedBox(width: 10),
      ],
    );
  }
  return Container();
}

Widget buildTrailingIcon(Widget? trailingIcon) {
  if (trailingIcon != null) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 10),
        trailingIcon,
      ],
    );
  }
  return Container();
}
