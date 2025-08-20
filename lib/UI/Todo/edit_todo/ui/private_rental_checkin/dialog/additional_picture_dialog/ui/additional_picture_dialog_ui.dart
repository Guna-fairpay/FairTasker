import 'package:fairpytasker/Component/close_badge.dart';
import 'package:fairpytasker/Component/compact_alert_dialog.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/image_viewer.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/private_rental_checkin/dialog/additional_picture_dialog/bloc/additional_picture_dialog_bloc.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AdditionalPictureDialogUi{
  AdditionalPictureDialogUi._();

  static void show(BuildContext context, {List<dynamic>? model, required String title}) async {
    await showDialog(context: context, builder: (context) => _AdditionalPictureDialogUi(model: model, title: title,), barrierDismissible: false);
  }
}

class _AdditionalPictureDialogUi extends StatelessWidget {
  final List<dynamic>? model;
  final String? title;
  const _AdditionalPictureDialogUi({this.model, this.title});

  @override
  Widget build(BuildContext context) {
    return CompactAlertDialog(
      titleText: title,
      titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      content: BlocProvider(
        create: (context) => AdditionalPictureDialogBloc()..add(InitialEvent(model)),
        child: BlocListener<AdditionalPictureDialogBloc, AdditionalPictureDialogState>(listener: (context, state) {
          if (state is ErrorState) Toaster.showError(state.error, context: context);
          if (state is SuccessState) Navigator.pop(context);
        },
            child: BlocBuilder<AdditionalPictureDialogBloc, AdditionalPictureDialogState>(builder: (context, state) => ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                10.spMin.height,
                Row(
                  children: [
                    Expanded(child: CompactText('${context.watch<AdditionalPictureDialogBloc>().selectedAdditionalPictures.length} file(s) selected')),
                    SuccessButton(
                      text: 'Upload',
                      onPressed: () => context.read<AdditionalPictureDialogBloc>().add(UploadEvent()),
                      backgroundColor: AppC.appColor,
                    ),
                  ],
                ),
                10.spMin.height,
                GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: context.read<AdditionalPictureDialogBloc>().additionalPictures.length,
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisSpacing: 10,crossAxisSpacing: 10),
                  itemBuilder: (context, index){
                    var data = context.read<AdditionalPictureDialogBloc>().additionalPictures[index];
                    List<dynamic> images = context.read<AdditionalPictureDialogBloc>().additionalPictures.map((e) => e['path'].toString().toTaskerStorageURL,).toList();
                    String apiDate = data['created_at'];
                    DateTime dateTime = DateTime.parse(apiDate);
                    DateTime localTime = dateTime.toLocal();
                    String formatted = DateFormat('dd-MM-yy hh:mm a').format(localTime);
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        border: Border.all(color: AppC.trans),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: CloseBadge(
                              showClose: false,
                              onTapView: () {
                                ShowAttachmentsDialog.of.show(context,
                                    attachments: images, title: "",
                                    currentAttachment: images[index],
                                );
                              },
                              child: Container(
                                constraints: BoxConstraints(
                                  minHeight: MediaQuery.sizeOf(context).height,
                                  minWidth: MediaQuery.sizeOf(context).width,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: AppC.grey.withValues(alpha: 0.2)),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: ImageViewer(
                                  fit: BoxFit.contain,
                                  imageInput: images[index],
                                  isNotImage: !(images[index] as Object).isImage,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CompactText(
                                      data['uploaded_by']?['first_name'] ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    CompactText(
                                      formatted,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              FittedBox(
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(14.spMin),
                                  child: Checkbox(
                                    activeColor: AppC.appColor,
                                    value: data['isCheck'],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    side: const BorderSide(width: 0.8, color: AppC.appColor),
                                    onChanged: (v)=> context.read<AdditionalPictureDialogBloc>().add(CheckEvent(data)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                ),
              ],
            ))),
      ),
    );
  }
}
