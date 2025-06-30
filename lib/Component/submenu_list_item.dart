import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/row_tile.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class SubmenuListItem extends StatelessWidget {
  final IconData? icon;
  final String title;
  final VoidCallback? onTap;
  const SubmenuListItem({super.key, this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shadowColor: Colors.white, // Subtle shadow
        surfaceTintColor: Colors.white,
        color: Colors.white, // White card background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.spMin), // Slightly rounded corners
        ),
        elevation: 2, // Slight elevation
        child: Padding(
          padding: 10.spMin.padding,
          child: RowTile(
            onTap: onTap,
            spacing: 10.spMin,
            expandTitle: true,
            leading: Icon(
              icon,
              color: AppC.appColor,
              size: 18.spMin,
            ),
            title: CompactText(
              title, color: Colors.black87,
            ),
            trailing: Icon(
              Iconsax.arrow_right_3,
              size: 13.spMin,
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}
