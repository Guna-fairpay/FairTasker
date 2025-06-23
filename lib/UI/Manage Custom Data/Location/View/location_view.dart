import 'dart:developer';

import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/compact_text_field.dart';
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/table_header_row.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/utilities/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import '../Bloc/location_data_bloc.dart';
import '../../../../Component/custom_compact_pagination.dart';
import '../../../../Component/success_button.dart';
import '../../../../Utilities/appC.dart';
import '../Components/location_list_item.dart';

part 'location_listing.dart';
part 'location_alter.dart';

class LocationView extends StatelessWidget {
  final String? title;
  const LocationView({super.key, this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: CompactAppBar(
        titleText: "Location",
        onClose: context.pop,
      ),
      body: BlocProvider(
        create: (context) => LocationBloc()
          ..add(LocationInitialEvent(title: title)),
          // ..add(const GetAddedLocationListData()),
        child: BlocListener<LocationBloc, LocationState>(
          listener: (context, state) async {
            if (state is LoadingState) {
              if (!EasyLoading.isShow) EasyLoading.show();
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
            }
          },
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 20.sp),
              children: [
                const LocationAlter(),
                10.height,
                const LocationListing(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
