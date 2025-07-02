import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/custom_tab_button.dart';
import 'package:fairpytasker/UI/offshore_report/operations/ui/operation_main_page.dart';
import 'package:fairpytasker/UI/offshore_report/project_status/project_status_ui.dart';
import 'package:fairpytasker/UI/offshore_report/tech/ui/tech_main_page.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part '../bloc/base_page_bloc.dart';
part '../bloc/base_page_state.dart';
part '../bloc/base_page_event.dart';

abstract class BasePageUI extends StatelessWidget {
  const BasePageUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BasePageBloc()..add(BasePageInitialEvent()),
        child: BlocBuilder<BasePageBloc, BasePageState>(
          builder: (context, state) => Scaffold(
            appBar: CompactAppBar(
              titleWidget: const Text("Offshore Report",style: TextStyle(fontWeight: FontWeight.bold),),
              onClose: context.pop,
            ),
            body: SafeArea(
              minimum: 16.spMin.padding,
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(width: Num.borderWidthButton,color: AppC.borderColor))
                    ),
                    child:  Row(
                      children: [
                        CustomTabButton(
                          buttonText: 'Operations',
                          value: 1,
                          selectedValue: context.watch<BasePageBloc>().selectedTabValue,
                          onPressed: (v)=> context.read<BasePageBloc>().add(BasePageTabEvent(v)),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(width: Num.borderWidthButton,color: AppC.black,))
                        ),),
                        CustomTabButton(

                          buttonText: 'Tech',
                          value: 2,
                          selectedValue: context.watch<BasePageBloc>().selectedTabValue,
                          onPressed: (v)=> context.read<BasePageBloc>().add(BasePageTabEvent(v)),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(width: Num.borderWidthButton,color: AppC.black))
                        ),),
                        CustomTabButton(
                          buttonText: 'Project Status',
                          value: 3,
                          selectedValue: context.watch<BasePageBloc>().selectedTabValue,
                          onPressed: (v)=> context.read<BasePageBloc>().add(BasePageTabEvent(v)),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(width: Num.borderWidthButton,color: AppC.black))
                        ),),
                      ],
                    ),
                  ),
                  Expanded(
                    child: switch(context.watch<BasePageBloc>().selectedTabValue)
                        {
                          1 => const OperationMainPage(),
                          2 => const TechMainPage(),
                          3 => const OffShoreProjectStatus(),
                          _ => const Placeholder(color: Colors.brown,)
                    },
                  )
                ],
              ),
            )
          )
    ));
  }
}
