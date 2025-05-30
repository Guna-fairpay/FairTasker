import 'package:fairpytasker/Component/custom_quill_editor.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/utilities/appC.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LimitedHtmlView extends StatefulWidget {
  final String? data;
  final bool showEdit;
  final double? slidingValue;
  final void Function()? onSave;
  final void Function(int value)? onSliding;
  const LimitedHtmlView({super.key, this.data, this.showEdit = true, this.onSave, this.slidingValue, this.onSliding});

  @override
  State<LimitedHtmlView> createState() => _LimitedHtmlViewState();
}

class _LimitedHtmlViewState extends State<LimitedHtmlView> {
  bool isExpanded = false;
  bool isEditing = false;
  bool showEdit = false;
  double? slidingValue;

  @override
  void initState() {
    showEdit = widget.showEdit;
    slidingValue = widget.slidingValue;
    super.initState();
  }


  void _handleOnTap() {
    isExpanded = !isExpanded;
    _setState;
  }

  void _handleEdit() {
    isEditing = !isEditing;
    _setState;
  }

  void _handleSlider(double value) {
    slidingValue = value;
    _setState;
    widget.onSliding?.call(value.ceil());
  }

  void get _setState {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: AppC.lightsGrey,
                  borderRadius: BorderRadius.circular(5.spMin)),
              padding: 10.spMin.padding,
              child: AnimatedSize(
                duration: Durations.medium4,
                child: ConstrainedBox(
                  constraints: isExpanded
                      ? const BoxConstraints()
                      : BoxConstraints(maxHeight: context.width * 0.185),
                  child: Html(
                    data: widget.data ?? "",
                  ),
                ),
              ),
            ),
            // if (isExpanded)
              AnimatedOpacity(
               opacity: (showEdit) ? 1 : 0,
               duration: Durations.long2,
               child: GestureDetector(
                 onTap: _handleEdit,
                 child: AnimatedSwitcher(duration: Durations.medium4, child: Padding(padding: 8.spMin.padding, child: SizedBox.fromSize(size: Size.fromRadius(10.spMin), child: SvgPicture.asset((isEditing ? Assets.cancelIcon : Assets.editIcon), theme: const SvgTheme(currentColor: AppC.appColor))))),
               ),
              )
          ],
        ),
        if ((widget.data?.length ?? 0) > 120)
        GestureDetector(
          onTap: _handleOnTap,
          child: CompactText("Read ${(isExpanded) ? "Less" : "More"}...", color: AppC.appColor),
        ),
        if (isEditing)
          ...[Container(
            padding: 10.spMin.padding,
            child: CustomQuillEditor(
              controller: QuillController.basic(),
            ),
          ),
            if (widget.onSave != null)
            Row(
              spacing: 10.spMin,
              children: [
                SuccessButton(
                  onPressed: (){},
                  text: "Save",
                ),
                SuccessButton(
                  onPressed: (){},
                  backgroundColor: AppC.redAccent,
                  text: "Cancel",
                ),
              ],
            )
          ],
        if (slidingValue != null)
        Row(
          spacing: 5.spMin,
          children: [
            Expanded(
              child: Slider(value: slidingValue ?? 0, onChanged: (widget.slidingValue == null) ? null : _handleSlider, max: 100, min: 0,
                activeColor: AppC.appColor,
                inactiveColor: AppC.lightGray,
                allowedInteraction: SliderInteraction.slideThumb,
                padding: 10.spMin.padding,
              ),
            ),
            CompactText("${slidingValue?.ceil() ?? 0}%", color: AppC.appColor)
          ],
        )
      ],
    );
  }
}
