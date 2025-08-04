import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';

class CompactAppBar extends AppBar {
  final Widget? titleWidget;
  final String? titleText;
  final bool? automaticallyImplyleading;
  final Color? backgroundColour;
  final Color? foregroundColour;
  final List<Widget>? actionWidgets;
  final double? leadingwidth;
  final VoidCallback? onClose;
  CompactAppBar({super.key, this.leadingwidth = 0, this.titleWidget, this.titleText, this.automaticallyImplyleading = false, this.backgroundColour = AppC.appColor, this.foregroundColour = AppC.white, this.actionWidgets, this.onClose});

  @override
  Widget? get title => titleWidget ?? Text(titleText ?? "");

  @override
  Color? get backgroundColor => backgroundColour;

  @override
  Color? get foregroundColor => foregroundColour;

  @override
  List<Widget>? get actions => actionWidgets ?? [IconButton(onPressed: onClose, icon: const Icon(Icons.close_rounded))];

  @override
  bool get automaticallyImplyLeading => automaticallyImplyleading ?? false;

  @override
  double? get leadingWidth => leadingwidth ?? 0;

}