import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';

class CompactScrollWrapper extends StatefulWidget {
  final Widget child;
  final void Function(dynamic value)? onScrollRequested;
  const CompactScrollWrapper({super.key, required this.child, this.onScrollRequested});

  @override
  State<CompactScrollWrapper> createState() => _CompactScrollWrapperState();
}

class _CompactScrollWrapperState extends State<CompactScrollWrapper> {

  final FBroadcast _fBroadcast = FBroadcast.instance();

  @override
  void initState() {
    _fBroadcast.register("scrollToIndex", (value, __) => WidgetsBinding.instance.addPostFrameCallback((_) => widget.onScrollRequested?.call(value)));
    super.initState();
  }

  @override
  void dispose() {
    _fBroadcast.unregister("scrollToIndex");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
