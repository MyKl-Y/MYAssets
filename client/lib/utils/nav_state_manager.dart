// client/lib/utils/nav_state_manager.dart

/*
Utility: Navigation State Manager
*/

import 'package:flutter/foundation.dart';

class NavigationState extends ChangeNotifier {
  int _currentPageIndex = 0;

  int get currentPageIndex => _currentPageIndex;

  void setPageIndex(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }
}
