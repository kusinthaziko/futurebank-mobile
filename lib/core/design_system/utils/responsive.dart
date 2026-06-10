import 'package:flutter/material.dart';

enum ScreenSize { phone, tablet, desktop }

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  static ScreenSize screenSize(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1024) return ScreenSize.desktop;
    if (w >= 600) return ScreenSize.tablet;
    return ScreenSize.phone;
  }

  static EdgeInsets padding(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    return EdgeInsets.all(isTablet ? 32.0 : 16.0);
  }

  static double cardWidth(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1024) return w * 0.33;
    if (w >= 600) return w * 0.48;
    return w;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1024 && desktop != null) return desktop!;
        if (constraints.maxWidth >= 600 && tablet != null) return tablet!;
        return mobile;
      },
    );
  }
}
