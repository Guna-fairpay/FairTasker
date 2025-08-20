import 'package:fairpytasker/Component/custom_compact_icon_button.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/private_rental_checkin/bloc/check_in_bloc.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/private_rental_checkin/component/text_with_attachment_icon.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/private_rental_checkin/dialog/additional_picture_dialog/ui/additional_picture_dialog_ui.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/verification/component/image_view_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remixicon/remixicon.dart';

part 'check_in_listing_page.dart';
part 'check_in_pictures_list_ui.dart';

class CheckInMainPage extends StatelessWidget {
  final dynamic model;
  const CheckInMainPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CheckInBloc()..add(InitialEvent(model)),
        child: BlocListener<CheckInBloc, CheckInState>(
          listener: (context, state) {
            if(state is LoadingState){
             if(!EasyLoading.isShow) EasyLoading.show();
            }else{
              if(EasyLoading.isShow) EasyLoading.dismiss();
              switch(state){
                case ErrorState(): Toaster.showError(state.message); break;
                case SuccessState(): Toaster.showSuccess(state.message); break;
                case ViewImageState(): ImageViewDialog.show(context, attachments: state.data); break;
                case AddOnPictureDialogState(): AdditionalPictureDialogUi.show(context, title: state.title, model: state.data); break;
              }
            }
          },
            child: const CheckInListingPage(),
        ),
    );
  }
}
