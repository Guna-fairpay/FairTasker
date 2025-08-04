import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
part 'compact_text_style_types.dart';

class CompactText extends StatelessWidget {
  final String text;
  final TextStyleType styleType;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool? softWrap;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final TextDecoration? decoration;
  final TextDirection? textDirection;

  const CompactText(
      this.text, {
        super.key,
        this.styleType = TextStyleType.bodyMedium,
        this.color,
        this.softWrap,
        this.textAlign,
        this.overflow,
        this.maxLines,
        this.fontWeight,
        this.decoration,
        this.textDirection,
        this.fontFamily,
      });

  TextStyle? _resolveStyle(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    switch (styleType) {
      case TextStyleType.bodyLarge: return theme.bodyLarge;
      case TextStyleType.bodyMedium: return theme.bodyMedium;
      case TextStyleType.bodySmall: return theme.bodySmall;
      case TextStyleType.labelLarge: return theme.labelLarge;
      case TextStyleType.labelMedium: return theme.labelMedium;
      case TextStyleType.labelSmall: return theme.labelSmall;
      case TextStyleType.titleLarge: return theme.titleLarge;
      case TextStyleType.titleMedium: return theme.titleMedium;
      case TextStyleType.titleSmall: return theme.titleSmall;
      case TextStyleType.headlineLarge: return theme.headlineLarge;
      case TextStyleType.headlineMedium: return theme.headlineMedium;
      case TextStyleType.headlineSmall: return theme.headlineSmall;
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = _resolveStyle(context);
    final mergedStyle = baseStyle?.copyWith(
      color: color,
      fontWeight: fontWeight,
      decoration: decoration,
      fontFamily: fontFamily ?? GoogleFonts.poppins().fontFamily,
    );

    return Text(
      text,
      style: mergedStyle,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
      textDirection: textDirection,
    );
  }
}
