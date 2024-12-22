// client/lib/widgets/web_container.dart

/*
Container Widget for placement of navigation bar and content for web
*/

import 'package:flutter/material.dart';

import './desktop_container.dart';
import './mobile_container.dart';

class WebContainer extends StatelessWidget {
  const WebContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 769) {
          // Small screens (Mobile)
          return MobileContainer();
        } else {
          // Large screens (Desktop)
          return DesktopContainer();
        }
      },
    );
  }
}