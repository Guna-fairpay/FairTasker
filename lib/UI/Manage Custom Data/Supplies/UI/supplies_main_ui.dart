
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/Bloc/supplies_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/Bloc/supplies_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/Bloc/supplies_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/UI/supplies_listing_page.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/UI/supplies_textField_page.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuppliesMainUI extends StatelessWidget {
  const SuppliesMainUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supplies'),
        titleTextStyle:
        context.textTheme.titleMedium?.copyWith(color: AppC.white, fontWeight: FontWeight.bold),
        backgroundColor: AppC.appColor,
        foregroundColor: AppC.white,
        titleSpacing: 0,
      ),
      body: BlocProvider<SuppliesBloc>(
        create: (context) => SuppliesBloc()..add(SuppliesInitialEvent()),
        child: BlocListener<SuppliesBloc, SuppliesState>(
          listener: (context, state) {
            if (state is SuppliesLoadingState) {if (!EasyLoading.isShow) EasyLoading.show();}
            if (state is SuppliesCommonState) {if (EasyLoading.isShow) EasyLoading.dismiss();}
          },
          child: SafeArea(
            minimum: 16.sp.padding,
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children:  [
                const SuppliesTextFieldPage(),
                10.height,
                const SuppliesListingPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

