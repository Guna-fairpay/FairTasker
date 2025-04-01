import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';

class TodoTopSearchBar extends StatelessWidget {
  final VoidCallback? onAdd, onMic;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  const TodoTopSearchBar({super.key, this.onAdd, this.onMic, this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.all(2),
      horizontalTitleGap: 0,
      dense: true,
      minVerticalPadding: 0,
      tileColor: Colors.blue[50],
      leading: IconButton(onPressed: onAdd, icon: const Icon(Icons.add_rounded)),
      title: TextField(
        controller: controller ?? TextEditingController(),
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        onSubmitted: onChanged,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search_rounded),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            isCollapsed: false,
            contentPadding: const EdgeInsets.all(5),
            constraints: const BoxConstraints(maxHeight: 40),
            hintText: "Search...",
            hintStyle: context.textTheme.labelLarge?.copyWith(
                color: context.theme.hintColor, fontWeight: FontWeight.normal)),
      ),
      trailing:
          IconButton(onPressed: onMic, icon: const Icon(Icons.mic_none_rounded)),
    );
  }
}
