import 'package:fairpytasker/UI/Finance/Expense/other/other_view/bloc/other_view_bloc.dart';
import 'package:fairpytasker/UI/Finance/Expense/other/other_view/ui/other_view_page.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class OtherMainPage extends StatelessWidget {
  const OtherMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => OtherViewBloc()..add(InitialEvent()),
        child: BlocListener<OtherViewBloc, OtherViewState>(
            listener: (context, state) {
              if (state is LoadingState) {
                EasyLoading.show();
              } else {
                EasyLoading.dismiss();
                if (state is SuccessState) Toaster.showSuccess(state.message);
                if (state is ErrorState) Toaster.showError(state.message);
              }
            },
            child: const OtherViewPage(),
        ),
    );
  }
}
