import 'package:flutter/material.dart';

class CompactBottomBarItem extends BottomNavigationBarItem {
  String? labelText;
  IconData? selectedIcon, inActiveIcon;
  CompactBottomBarItem({this.selectedIcon, this.inActiveIcon, this.labelText}) : super(icon: const SizedBox.shrink());

  @override
  Widget get activeIcon => (selectedIcon == null) ? const SizedBox.shrink() : Icon(selectedIcon);

  @override
  Widget get icon => (inActiveIcon == null) ? const SizedBox.shrink() : Icon(inActiveIcon);

  @override
  String? get label => labelText;

}
