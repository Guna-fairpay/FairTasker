import 'package:fairpytasker/UI/Manage%20Custom%20Data/Sub%20Category/subcategory_page/subcategory_alter_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Sub%20Category/subcategory_page/subcategory_listing_ui.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubcategoryBodyUi extends StatelessWidget {
  const SubcategoryBodyUi({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        minimum: 16.sp.padding,
        child: ListView(
          children: [
            const SubcategoryAlterUi(),
            10.height,
            const SubcategoryListingUi(),
          ],
        ));
  }
}
