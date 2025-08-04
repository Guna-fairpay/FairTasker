import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/custom_tab_button.dart';
import 'package:fairpytasker/UI/archive_task/archive_task_main/bloc/archive_task_main_bloc.dart';
import 'package:fairpytasker/UI/archive_task/archived_task/ui/archived_task_main_ui.dart';
import 'package:fairpytasker/UI/archive_task/unarchived_task/ui/unarchive_task_main_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArchiveTaskMainUI extends StatelessWidget {
  const ArchiveTaskMainUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompactAppBar(
        titleWidget: const Text("Archive Task",style: TextStyle(fontWeight: FontWeight.bold),),
        onClose: context.pop,
      ),
      body: BlocProvider(
        create: (context) => ArchiveTaskMainBloc()..add(InitialEvent()),
        child: BlocBuilder<ArchiveTaskMainBloc,ArchiveTaskMainState>(
          builder: (context, state) {
            return SafeArea(
              minimum: 15.padding,
                child: Column(
                  spacing: 10,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(width: Num.borderWidthButton,color: AppC.borderColor))
                      ),
                      child: Row(
                        children: [
                          CustomTabButton(
                            buttonText: 'Archived Task',
                            value: 1,
                            selectedValue: context.watch<ArchiveTaskMainBloc>().selectedTabValue,
                            onPressed: (v)=> context.read<ArchiveTaskMainBloc>().add(TabEvent(v)),
                            decoration:  BoxDecoration(
                                border: Border.all(color: AppC.grey, width: Num.borderWidthButton),
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(Num.borderRadius), topRight: Radius.circular(Num.borderRadius)),
                            ),
                          ),
                          CustomTabButton(
                            buttonText: 'Unarchived Task',
                            value: 2,
                            selectedValue: context.watch<ArchiveTaskMainBloc>().selectedTabValue,
                            onPressed: (v)=> context.read<ArchiveTaskMainBloc>().add(TabEvent(v)),
                            decoration:  BoxDecoration(
                              border: Border.all(color: AppC.grey, width: Num.borderWidthButton),
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(Num.borderRadius), topRight: Radius.circular(Num.borderRadius)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: switch(context.watch<ArchiveTaskMainBloc>().selectedTabValue)
                      {
                        1 => const ArchivedTaskMainUI(),
                        2 => const UnarchiveTaskMainUI(),
                        _ => const Placeholder(color: Colors.brown,)
                      },
                    )
                  ],
                ),
            );
          }
        ),
      ),
    );
  }
}
