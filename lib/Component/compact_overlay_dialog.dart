import 'package:flutter/material.dart';

class CompactOverlayDialog extends StatefulWidget {
  final Offset anchor;
  final WidgetBuilder builder;
  final VoidCallback? onDismiss;

  const CompactOverlayDialog(
      {super.key,
      this.anchor = Offset.zero,
      required this.builder,
      this.onDismiss});

  static void show({
    required BuildContext context,
    required Offset anchor,
    required WidgetBuilder builder,
    VoidCallback? onDismiss,
  }) {
    final overlay = OverlayEntry(
      builder: (_) => CompactOverlayDialog(
        anchor: anchor,
        builder: builder,
        onDismiss: onDismiss,
      ),
    );

    Overlay.of(context).insert(overlay);
  }

  @override
  State<CompactOverlayDialog> createState() => _CompactOverlayDialogState();
}

class _CompactOverlayDialogState extends State<CompactOverlayDialog> {
  late OverlayEntry _entry;
  late double _keyboardHeight;
  @override
  void initState() {
    super.initState();
    // Initially, set the keyboard height to zero
    _keyboardHeight = 0.0;
    // _entry = Overlay.of(context).context.findAncestorWidgetOfExactType<Overlay>() as OverlayEntry;
    // Listen for the keyboard visibility changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This ensures the state rebuilds when the keyboard comes up
      _adjustPosition();
    });
  }

  void _dismiss() {
    widget.onDismiss?.call();
    // _entry.remove();
  }

  // Adjust the position of the dialog based on the keyboard
  void _adjustPosition() {
    setState(() {
      // Reposition the dialog if the keyboard is showing
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      if (keyboardHeight > 0) {
        _keyboardHeight = keyboardHeight;
      } else {
        _keyboardHeight = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the current keyboard height
    _keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: _keyboardHeight),
      duration: Durations.short4,
      child: Stack(
        children: [
          GestureDetector(
            onTap: _dismiss,
            behavior: HitTestBehavior.translucent,
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            left: widget.anchor.dx,
            top: widget.anchor.dy - _keyboardHeight, // Adjust position based on the keyboard height
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(8),
              child: widget.builder(context),
            ),
          ),
        ],
      ),
    );
  }
}
