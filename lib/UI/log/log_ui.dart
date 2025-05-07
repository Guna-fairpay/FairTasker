import 'package:fairpytasker/UI/log/bloc/log_bloc.dart';
import 'package:fairpytasker/UI/log/bloc/log_event.dart';
import 'package:fairpytasker/UI/log/bloc/log_state.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/UI/log/log_bottom_controllers.dart';
import 'package:fairpytasker/UI/log/logs_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogUi extends StatelessWidget {
  const LogUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogBloc()..add(LogInitialEvent()),
      child: BlocListener<LogBloc, LogState>(
        listener: (context, state) {},
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Logs"),
            actions: [
              IconButton(
                  onPressed: context.pop, icon: const Icon(Icons.close_rounded))
            ],
            leadingWidth: 0,
          ),
          body: const LogsTable(),
          bottomNavigationBar: const LogBottomControllers(),
        ),
      ),
    );
  }
}
