import 'package:flutter/material.dart';

@protected
final class SearchMultiselectField extends StatelessWidget {
  final TextEditingController textController;
  final bool isMobile;
  final FocusNode focusNodeTextField;
  final void Function() onTap;
  final void Function(String value) onChange;
  const SearchMultiselectField({super.key, required this.textController, required this.isMobile, required this.onTap, required this.focusNodeTextField, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 0,
        maxWidth: 100,
      ),
      child: SearchBar(
        controller: textController,
        padding: const WidgetStatePropertyAll<
            EdgeInsetsGeometry>(EdgeInsets.zero),
        elevation:
        const WidgetStatePropertyAll<double>(0),
        backgroundColor:
        const WidgetStatePropertyAll<Color>(
            Colors.transparent),
        shape: const WidgetStatePropertyAll<
            RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(3)),
          ),
        ),
        textStyle:
        const WidgetStatePropertyAll<TextStyle>(
          TextStyle(
            decoration: TextDecoration.none,
            decorationStyle: TextDecorationStyle.solid,
            overflow: TextOverflow.ellipsis,
            leadingDistribution:
            TextLeadingDistribution.even,
            //fontSize: 17,
          ),
        ),
        constraints: BoxConstraints(
            minHeight: isMobile ? 40 : 30),
        surfaceTintColor:
        const WidgetStatePropertyAll<Color>(
            Colors.transparent),
        shadowColor:
        const WidgetStatePropertyAll<Color>(
            Colors.transparent),
        overlayColor:
        const WidgetStatePropertyAll<Color>(
            Colors.transparent),
        hintStyle:
        const WidgetStatePropertyAll<TextStyle>(
            TextStyle(
                color: Colors.transparent,
                decoration: TextDecoration.none)),
        onTap: onTap,
        onChanged: onChange,
        focusNode: focusNodeTextField,
      ),
    );
  }
}
