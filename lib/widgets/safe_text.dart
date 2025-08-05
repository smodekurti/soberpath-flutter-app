import 'package:flutter/material.dart';

/// A widget that safely displays text, preventing layout issues with null or empty strings.
/// 
/// This widget is a drop-in replacement for Text that handles null or empty text gracefully.
/// It automatically converts null to an empty string and provides additional safety features.
class SafeText extends StatelessWidget {
  final String? text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool softWrap;

  const SafeText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
    );
  }
}
