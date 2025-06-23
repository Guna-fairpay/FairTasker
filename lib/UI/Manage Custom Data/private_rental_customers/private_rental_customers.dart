import 'package:fairpytasker/Component/close_badge.dart';
import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/compact_file_picker.dart';
import 'package:fairpytasker/Component/compact_text_field.dart';
import 'package:fairpytasker/Component/custom_compact_pagination.dart';
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/image_viewer.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Component/table_header_row.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/private_rental_customers/bloc/private_rental_customers_bloc.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart' hide State;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

part 'add_edit_form.dart';
part 'user_listing_table.dart';
part 'component/attachment_lister.dart';
part 'component/listing_table_child_row.dart';

class PrivateRentalCustomers extends StatelessWidget {
  const PrivateRentalCustomers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompactAppBar(
        titleText: "Private Rental Customers",
        onClose: context.pop,
      ),
      body: BlocProvider(create: (context) => RentalCustomerBloc()..add(InitEvent()),
      child: BlocListener<RentalCustomerBloc, State>(listener: (context, state) {
        if (state is LoadingState){
          if (!EasyLoading.isShow) EasyLoading.show();
        } else {
          if (EasyLoading.isShow) EasyLoading.dismiss();
          switch(state) {
            case ErrorState(): Toaster.showError(state.message); break;
            case SuccessState(): Toaster.showSuccess(state.message); break;
            case DeleteState(): AskPermissionDialog.show(context, title: "Are you sure?", description: "Do you want to delete this item?", onPositivePressed: () => context.read<RentalCustomerBloc>().add(DeleteEvent(state.model, proceed: true))); break;
            case DeleteLicenseState(): AskPermissionDialog.show(context, title: "Are you sure?", description: "Do you want to delete this item?", onPositivePressed: () => context.read<RentalCustomerBloc>().add(DeleteLicenseEvent(state.model, proceed: true))); break;
            case DeleteInsuranceState(): AskPermissionDialog.show(context, title: "Are you sure?", description: "Do you want to delete this item?", onPositivePressed: () => context.read<RentalCustomerBloc>().add(DeleteInsuranceEvent(state.model, proceed: true))); break;
          }
        }
      },
      child: ListView(
        shrinkWrap: true,
        padding: 16.spMin.padding,
        children: const [
          AddEditForm(),
          UserListingTable()
        ],
      ))),
    );
  }
}
