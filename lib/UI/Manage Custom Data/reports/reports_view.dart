import 'package:fairpytasker/Component/header.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/reports/reports_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/reports/reports_view_body.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: HeaderView(),
      ),
      body: BlocProvider<ReportsBloc>(
        create: (context) => ReportsBloc(),
        child: const ReportsViewBody(),
      ),
    );
  }
}
