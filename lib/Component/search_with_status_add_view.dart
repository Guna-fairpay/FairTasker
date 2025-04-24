import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchWithStatusAddView extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onAddPressed;
  final TextEditingController? controller;
  final ValueChanged<String>? onSearchChanged;

  const SearchWithStatusAddView(
      {super.key,
      this.value = false,
      this.onChanged,
      this.onAddPressed,
      this.controller,
      this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFFf3f6f9)),
      padding: 5.sp.padding,
      child: Row(
        children: [
          Transform.scale(
              scale: 0.8,
              child: Switch(
                value: value,
                onChanged: onChanged,
              )),
          Flexible(
              child: CompactSearchView(
                filled: true,
                  fillColor: Colors.white,
                  controller: (controller ?? TextEditingController()),
                  onChanged: onSearchChanged)),
          IconButton(
              onPressed: onAddPressed, icon: const Icon(Icons.add_rounded)),
        ],
      ),
    );
  }
}
