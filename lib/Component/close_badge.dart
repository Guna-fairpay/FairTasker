import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';

class CloseBadge extends StatelessWidget {
  final Widget child;
  final bool showClose;
  final VoidCallback? onTapView, onTapDelete;
  const CloseBadge({super.key, required this.child, this.onTapView, this.onTapDelete, this.showClose = true});

  @override
  Widget build(BuildContext context) {
    if (!showClose) {
      return GestureDetector(
        onTap: onTapView,
        child: child,
      );
    }
    return Stack(
      children: [
        GestureDetector(
          onTap: onTapView,
          child: child,
        ),
        Positioned(
          top: -0,
          right: -0,
          child: GestureDetector(
            onTap: onTapDelete,
            child: Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent
              ),
              padding: 5.padding,
              child: const Icon(Icons.close_rounded, color: Colors.white, size: 14,),
            ),
          ),
        ),
      ],
    );
  }
}
