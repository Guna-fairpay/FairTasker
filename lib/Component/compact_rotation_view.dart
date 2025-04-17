import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompactRotationView extends StatefulWidget {
  final Widget child;
  final Widget? prefixChild, suffixChild;
  const CompactRotationView({super.key, required this.child, this.prefixChild, this.suffixChild});

  @override
  State<CompactRotationView> createState() => _CompactRotationViewState();
}

class _CompactRotationViewState extends State<CompactRotationView> {
  int quarterTurns = 0;

  void _rotate() {
    setState(() {
      quarterTurns = (quarterTurns + 1) % 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 10.sp,
      children: [
        RotatedBox(quarterTurns: quarterTurns, child: widget.child),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.prefixChild ?? const SizedBox.shrink(),
            IconButton(onPressed: _rotate, icon: const Icon(Icons.sync)),
            widget.suffixChild ?? const SizedBox.shrink(),
          ],
        )
      ],
    );
  }
}
