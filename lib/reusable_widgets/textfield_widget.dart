import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  final String? text;
  final String? hint;
  final bool showCounter;
  final TextInputType? keyboardType;
  final double? borderRadius;
  final Color? borderColor;
  final double? focusBorderRadius;
  final double? enableBorderRadius;
  final Color? focusBorderColor;
  final Color? enableBorderColor;
  final double? errorBorderRadius;
  final double? focusErrorRadius;
  final Icon? postIcon;
  final Color? postIconColor;
  final Icon? prefix;
  final Widget? suffix;
  final Color? prefixColor;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function? onSubmitField;
  final int? maxLength;
  final int maxLines;
  final String? label;
  final bool? focus;
  final bool readOnly;
  final List<TextInputFormatter>? formatter;
  final TextStyle? style;
  final TextInputAction textInputAction;
  final bool shouldShowCurreny;
  final bool obscureText;
  final String? Function(String?)? validator;
  final bool shouldShowBorder;
  final TextStyle? hintStyle;

  const TextFieldWidget(
      {Key? key,
      this.shouldShowBorder = true,
      this.text,
      this.hint,
      this.keyboardType,
      this.borderRadius,
      this.borderColor,
      this.postIcon,
      this.obscureText = false,
      this.postIconColor,
      this.readOnly = false,
      this.focus,
      this.showCounter = false,
      this.focusBorderColor,
      this.focusBorderRadius,
      this.enableBorderColor,
      this.enableBorderRadius,
      this.controller,
      this.onSubmitField,
      this.maxLength,
      this.maxLines = 1,
      this.suffix,
      this.errorBorderRadius,
      this.focusErrorRadius,
      this.prefixColor,
      this.prefix,
      this.label,
      this.formatter,
      this.style,
      this.shouldShowCurreny = false,
      this.textInputAction = TextInputAction.next,
      this.onChanged,
      this.validator,
      this.hintStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: formatter,
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.primary,
      obscureText: obscureText,
      readOnly: readOnly,
      decoration: InputDecoration(
        suffixIcon: suffix,
        prefixIcon: shouldShowCurreny
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text("₹"),
                ],
              )
            : prefix,
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        counterText: showCounter ? null : '',
        isDense: true,
        focusedBorder: shouldShowBorder
            ? UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary))
            : InputBorder.none,
        border: shouldShowBorder
            ? UnderlineInputBorder(
                borderSide: BorderSide(
                  color: borderColor ?? Theme.of(context).colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(borderRadius ?? 0))
            : InputBorder.none,
        hintStyle: hintStyle ?? Theme.of(context).textTheme.bodyMedium,
        hintText: hint ?? '',
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
      ),
      validator: validator,
      style: style,
      autofocus: focus ?? false,
      maxLines: maxLines,
      maxLength: maxLength,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onFieldSubmitted: (value) {
        if (onSubmitField != null) {
          onSubmitField!();
        }
      },
      keyboardType: keyboardType,
    );
  }
}
