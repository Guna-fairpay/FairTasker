import 'package:flutter/material.dart';

class PageKeepAliver extends StatefulWidget {
  final Widget child;
  const PageKeepAliver({super.key, required this.child});

  @override
  State<PageKeepAliver> createState() => _PageKeepAliverState();
}

class _PageKeepAliverState extends State<PageKeepAliver> with AutomaticKeepAliveClientMixin {


  @override
  Widget build(BuildContext context) {
    super.build(context); // Important to call this!
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
