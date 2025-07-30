import 'package:flutter/material.dart';

class ResponsiveHelpers {
  // Screen size breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Get screen type
  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) return ScreenType.mobile;
    if (width < tabletBreakpoint) return ScreenType.tablet;
    return ScreenType.desktop;
  }

  // Responsive font sizes
  static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.mobile:
        return baseFontSize;
      case ScreenType.tablet:
        return baseFontSize * 1.1;
      case ScreenType.desktop:
        return baseFontSize * 1.2;
    }
  }

  // Responsive padding
  static double getResponsivePadding(BuildContext context, double basePadding) {
    final screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.mobile:
        return basePadding;
      case ScreenType.tablet:
        return basePadding * 1.2;
      case ScreenType.desktop:
        return basePadding * 1.5;
    }
  }

  // Safe text widget that prevents overflow
  static Widget safeText(
    String text, {
    TextStyle? style,
    int? maxLines,
    TextOverflow? overflow,
    TextAlign? textAlign,
  }) {
    return Text(
      text,
      style: style,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign,
      softWrap: true,
    );
  }

  // Flexible container that adjusts to content
  static Widget flexibleContainer({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Decoration? decoration,
    double? width,
    double? height,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: padding,
          margin: margin,
          color: color,
          decoration: decoration,
          width: width,
          height: height,
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth,
            maxHeight: constraints.maxHeight,
          ),
          child: child,
        );
      },
    );
  }

  // Responsive card width
  static double getCardWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > desktopBreakpoint) return 400;
    if (screenWidth > tabletBreakpoint) return screenWidth * 0.6;
    return screenWidth - 32; // Account for padding
  }

  // Responsive grid columns
  static int getGridColumns(BuildContext context) {
    final screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.mobile:
        return 1;
      case ScreenType.tablet:
        return 2;
      case ScreenType.desktop:
        return 3;
    }
  }

  // Check if text will overflow
  static bool willTextOverflow(
    String text,
    TextStyle style,
    double maxWidth,
    int? maxLines,
  ) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }
}

enum ScreenType { mobile, tablet, desktop }

// Safe Text Widget that automatically handles overflow
class SafeText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow overflow;
  final TextAlign? textAlign;
  final bool responsive;

  const SafeText(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign,
    this.responsive = true,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle effectiveStyle = style ?? Theme.of(context).textTheme.bodyMedium!;
    
    if (responsive) {
      effectiveStyle = effectiveStyle.copyWith(
        fontSize: ResponsiveHelpers.getResponsiveFontSize(
          context,
          effectiveStyle.fontSize ?? 14,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Check if text will overflow
        if (constraints.maxWidth.isFinite && maxLines != null) {
          final willOverflow = ResponsiveHelpers.willTextOverflow(
            text,
            effectiveStyle,
            constraints.maxWidth,
            maxLines,
          );

          if (willOverflow) {
            // Use smaller font size if text overflows
            effectiveStyle = effectiveStyle.copyWith(
              fontSize: (effectiveStyle.fontSize ?? 14) * 0.9,
            );
          }
        }

        return Text(
          text,
          style: effectiveStyle,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign,
          softWrap: true,
        );
      },
    );
  }
}

// Responsive Container that adjusts to screen size
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Decoration? decoration;
  final double? width;
  final double? height;
  final bool adaptivePadding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.width,
    this.height,
    this.adaptivePadding = true,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry effectivePadding = padding ?? EdgeInsets.zero;
    
    if (adaptivePadding && padding != null) {
      final screenType = ResponsiveHelpers.getScreenType(context);
      final multiplier = screenType == ScreenType.mobile ? 1.0 : 
                        screenType == ScreenType.tablet ? 1.2 : 1.5;
      
      if (padding is EdgeInsets) {
        final edgeInsets = padding as EdgeInsets;
        effectivePadding = EdgeInsets.fromLTRB(
          edgeInsets.left * multiplier,
          edgeInsets.top * multiplier,
          edgeInsets.right * multiplier,
          edgeInsets.bottom * multiplier,
        );
      }
    }

    return Container(
      padding: effectivePadding,
      margin: margin,
      color: color,
      decoration: decoration,
      width: width,
      height: height,
      child: child,
    );
  }
}

// Flexible Row that wraps content when needed
class FlexibleRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;

  const FlexibleRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If we have enough space, use Row
        if (constraints.maxWidth > 400) {
          return Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: _addSpacing(children, spacing),
          );
        } else {
          // If space is limited, use Column
          return Column(
            crossAxisAlignment: crossAxisAlignment == CrossAxisAlignment.center 
                ? CrossAxisAlignment.center 
                : CrossAxisAlignment.start,
            children: _addSpacing(children, spacing),
          );
        }
      },
    );
  }

  List<Widget> _addSpacing(List<Widget> widgets, double spacing) {
    if (widgets.isEmpty) return widgets;
    
    final List<Widget> spacedWidgets = [];
    for (int i = 0; i < widgets.length; i++) {
      spacedWidgets.add(widgets[i]);
      if (i < widgets.length - 1) {
        spacedWidgets.add(SizedBox(width: spacing, height: spacing));
      }
    }
    return spacedWidgets;
  }
}

// Auto-sizing text that fits available space
class AutoSizeText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final double minFontSize;
  final double maxFontSize;
  final TextAlign? textAlign;

  const AutoSizeText(
    this.text, {
    super.key,
    this.style,
    this.maxLines = 1,
    this.minFontSize = 10,
    this.maxFontSize = 100,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final TextStyle baseStyle = style ?? Theme.of(context).textTheme.bodyMedium!;
        double fontSize = baseStyle.fontSize ?? maxFontSize;
        
        // Binary search for optimal font size
        double minSize = minFontSize;
        double maxSize = maxFontSize;
        
        while (maxSize - minSize > 1) {
          fontSize = (minSize + maxSize) / 2;
          
          final TextPainter textPainter = TextPainter(
            text: TextSpan(
              text: text,
              style: baseStyle.copyWith(fontSize: fontSize),
            ),
            maxLines: maxLines,
            textDirection: TextDirection.ltr,
          );
          
          textPainter.layout(maxWidth: constraints.maxWidth);
          
          if (textPainter.didExceedMaxLines || textPainter.width > constraints.maxWidth) {
            maxSize = fontSize;
          } else {
            minSize = fontSize;
          }
        }
        
        return Text(
          text,
          style: baseStyle.copyWith(fontSize: minSize),
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
        );
      },
    );
  }
}