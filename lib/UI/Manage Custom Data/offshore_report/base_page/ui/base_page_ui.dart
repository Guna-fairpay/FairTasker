import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/custom_tab_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/offshore_report/base_page/bloc/base_page_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/offshore_report/operations/ui/operation_main_page.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BasePageUI extends StatelessWidget {
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
              minimum: 16.sp.padding,
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
                  if(context.watch<BasePageBloc>().selectedTabValue == 1)
                    const OperationMainPage(),
                  if(context.watch<BasePageBloc>().selectedTabValue == 2)
                      Placeholder(color: Colors.brown,),
                  if(context.watch<BasePageBloc>().selectedTabValue == 3)
                    Placeholder(color: AppC.blue,),
                ],
              ),
            )
          )
    ));
  }
}
