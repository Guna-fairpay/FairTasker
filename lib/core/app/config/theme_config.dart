import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/color_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeConfig {
  ThemeConfig._();
  static ThemeData get themeData => ThemeData(
    cardColor: Colors.white,
    dialogBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white, elevation: 5, scrolledUnderElevation: 0),
    dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
    searchBarTheme: SearchBarThemeData(
      backgroundColor: WidgetStatePropertyAll(Colors.grey.shade100),
      textStyle: const WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.normal, fontFamily: "Lato", color: Colors.grey)),
      padding: const WidgetStatePropertyAll(EdgeInsets.all(5)),
      shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(16))),
      elevation: const WidgetStatePropertyAll(0),
      side: const WidgetStatePropertyAll(BorderSide.none),
    ),
    chipTheme: ChipThemeData(
      color: WidgetStateColor.resolveWith((states) => states.contains(WidgetState.selected) ? AppC.appColor : AppC.lightGrey),
      checkmarkColor: AppC.white,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      side: const BorderSide(color: AppC.chipBackgroundUnselectedBorder),
      padding: 5.spMin.horizontalPadding,
    ),
    switchTheme: SwitchThemeData(
      // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      trackColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? AppC.green : AppC.grey),
      thumbColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? AppC.white : AppC.lightGrey),
    ),
    dividerTheme: const DividerThemeData(
        color: AppC.grey,
        thickness: Num.borderWidthThinField
    ),
    primarySwatch: AppC.appColor.toMaterialColor,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: AppC.appColor.toMaterialColor),
    textTheme: GoogleFonts.poppinsTextTheme(Typography.blackCupertino.copyWith()),
  );
}