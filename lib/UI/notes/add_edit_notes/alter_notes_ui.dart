import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlterNotesUi extends StatelessWidget {
  final dynamic noteId;
  const AlterNotesUi({super.key, this.noteId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( (noteId.toString().isNullOrEmpty) ? "Add Notes" : "Edit Notes"),
        leadingWidth: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: context.pop, icon: Icon(Icons.close_rounded)),
        ],
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        minimum: 16.sp.padding,
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Utils.getTextFormField("Note Title", TextEditingController())
        ],
      )),
    );
  }
}
