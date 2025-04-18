import 'package:fairpytasker/Component/header.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/reports/reports_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/reports/reports_view_body.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        leadingWidth: 0,
        title: const Text("Reports"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: context.pop, icon: const Icon(Icons.close_rounded))
        ],
        foregroundColor: Colors.white,
        backgroundColor: AppC.appColor,
      ),
      body: BlocProvider<ReportsBloc>(
        create: (context) => ReportsBloc(),
        child: const ReportsViewBody(),
      ),
    );
  }
}
