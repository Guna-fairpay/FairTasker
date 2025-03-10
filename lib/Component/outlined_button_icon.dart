import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';

class OutlinedButtonIcon extends StatelessWidget {
  final IconData? iconData;
  final VoidCallback? onPressed;
  const OutlinedButtonIcon({super.key, this.iconData, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      onPressed: () => onPressed?.call(),
      icon: Icon(iconData, color: AppC.appColor,),
      style: ButtonStyle(
          side: const WidgetStatePropertyAll(BorderSide(width: Num.borderWidthButton, color: AppC.borderColor)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: const WidgetStatePropertyAll(Size.fromRadius(16)),
          maximumSize: const WidgetStatePropertyAll(Size.fromRadius(18)),
          padding: WidgetStatePropertyAll(5.padding),
          iconAlignment: IconAlignment.start,
          alignment: Alignment.center,
          shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
              borderRadius:
              BorderRadius.circular(Num.borderRadiusLarge)))),
    );
  }
}
