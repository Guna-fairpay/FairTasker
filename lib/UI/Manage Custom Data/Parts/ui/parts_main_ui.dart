
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/Bloc/parts_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/Bloc/parts_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/Bloc/parts_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/ui/parts_listing_page.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/ui/parts_textField_page.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PartsMainUI extends StatelessWidget {
  final String? title;
  const PartsMainUI({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parts'),
        titleTextStyle:
        context.textTheme.titleMedium?.copyWith(color: AppC.white, fontWeight: FontWeight.bold),

        backgroundColor: AppC.appColor,
        foregroundColor: AppC.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: ()=>context.pop(),
            icon: const Icon(Icons.close_outlined),
          ),
        ],
      ),
      body: BlocProvider<PartsBloc>(
        create: (context) => PartsBloc()..add(PartsInitialEvent(title: title)),
        child: BlocListener<PartsBloc, PartsState>(
          listener: (context, state) {
            if (state is PartsLoadingState) {if (!EasyLoading.isShow) EasyLoading.show();}
            if (state is PartsCommonState) {if (EasyLoading.isShow) EasyLoading.dismiss();}
          },
          child: SafeArea(
            minimum: 16.spMin.padding,
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children:  [
                const PartsTextFieldPage(),
                10.height,
                const PartsListingPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

