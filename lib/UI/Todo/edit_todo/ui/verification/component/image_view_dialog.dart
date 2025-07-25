import 'package:card_swiper/card_swiper.dart';
import 'package:fairpytasker/Component/compact_doc_viewer.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/image_preview.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/verification/bloc/verification_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageViewDialog  {
  ImageViewDialog._();

  static void show(BuildContext context, {dynamic model}) async {
    await showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
          value: BlocProvider.of<VerificationBloc>(context),
          child: _ImageViewDialog(model: model,)),
    );
  }
}

class _ImageViewDialog extends StatelessWidget {
  final dynamic model;
  const _ImageViewDialog({
    this.model,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      title: ListTile(
        title: const CompactText(
          "Preview",
          fontWeight: FontWeight.bold,
          styleType: TextStyleType.titleMedium,
        ),
        trailing: GestureDetector(
          onTap: context.popDialog,
          child: const Icon(Icons.close_rounded),
        ),
      ),
      insetPadding: 10.padding,
      titlePadding: EdgeInsets.zero,
      alignment: Alignment.topCenter,
      contentPadding: 15.horizontalPadding,
      content: BlocBuilder<VerificationBloc, VerificationState>(
          builder: (context, state) {
            List<dynamic>paymentAttachments = context.read<VerificationBloc>().paymentAttachments;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: AspectRatio(
                    aspectRatio: 0.7,
                    child: Container(
                      width: double.maxFinite,
                      padding: 10.bottomPadding,
                      child: Swiper(
                        scrollDirection: Axis.horizontal,
                        itemCount: paymentAttachments.length,
                        loop: false,
                        pagination: const SwiperPagination(
                            alignment: Alignment.topCenter,
                            builder: SwiperPagination.dots
                        ),
                        outer: true,
                        indicatorLayout: PageIndicatorLayout.SLIDE,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var attachment = paymentAttachments[index];
                          return ImagePreview(imageInput: attachment);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
      ),
    );
  }
}
