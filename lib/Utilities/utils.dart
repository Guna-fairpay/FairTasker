
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:date_time/date_time.dart' as dt;
import 'package:fairpytasker/Component/custom_search_bar.dart';
import 'package:fairpytasker/Component/focus_node_wrapper.dart';
import 'package:fairpytasker/Component/tasker_button.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/helper.dart';
import 'package:fairpytasker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

enum ImageUploadType {
  gallery,
  camera,
}

/*enum ImageSource {
  camera,
  gallery,
}*/

class Utils {
  static final Connectivity _connectivity = Connectivity();
  final viewTransformationController = TransformationController();
  static final ImagePicker _picker = ImagePicker();


  static String get returnBearerToken => Session.of.getString(Str.frBearerToken).toBearer;

  static Future<List<File>> pickImages(ImageSource source) async {
    List<File> images = [];

    if (source == ImageSource.gallery) {
      final List<XFile> selectedImages = await _picker.pickMultiImage();
      if (selectedImages.isNotEmpty) {
        images.addAll(selectedImages.map((image) => File(image.path)));
      }
    } else {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        images.add(File(image.path));
      }
    }
    return images;
  }

  static Future showCustomDeleteDialog(
      BuildContext context,
      String confirmText,
     ){
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppC.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.help_outline_sharp,size: 50,color: Colors.blue,),
              const SizedBox(height: 16),
              Utils.getText(
                  'Are you sure?',
              size: 20,
              weight: FontWeight.w900,
              align: TextAlign.center),
              const SizedBox(height: 8),
              Utils.getText(
                "Do you want to delete this $confirmText",
                size: 12,
                color: Colors.black54,
                align: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Expanded(
                    child: Utils.getFilledButton(
                      'Yes, delete it!',
                          ()=>Navigator.pop(context, true),
                      bgColor: AppC.blue,
                    ),
                  ),
                  Flexible(
                    child: Utils.getFilledButton(
                      'Cancel',
                          ()=>Navigator.pop(context, false),
                      bgColor: AppC.redAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



  static Widget dropdownBox(
      String hintText,
      List<dynamic> listData,
      Function(dynamic selectedValue) onSelected,
      {required String labelKey,
      dynamic initialSelection,
        String? labelKey2,
        dynamic selectedKey,
        double topLRadius = 4,
        double topRRadius = 4,
        double bottomLRadius = 4,
        double bottomRRadius = 4,
        double height = 35,
        Color borderColor = AppC.fieldBase,
        double borderWidth = Num.borderWidthField,
        AutovalidateMode? autovalidateMode,
        FormFieldValidator<dynamic>? validator,
      }) {
    return FormField<dynamic>(
      initialValue: initialSelection,
      autovalidateMode: autovalidateMode,
      validator: validator,
      builder: (field) {
        var border = OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topLRadius),
              topRight: Radius.circular(topRRadius),
              bottomLeft: Radius.circular(bottomLRadius),
              bottomRight: Radius.circular(bottomRRadius),),
            borderSide: BorderSide(color: (field.hasError) ? AppC.errorTextColor : borderColor, width:  (field.hasError) ? Num.borderWidthButton : borderWidth,)
        );
        return Column(
          spacing: 3,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownMenu<dynamic>(
              key: ValueKey(selectedKey),
              initialSelection: initialSelection,
              hintText: hintText,
              menuHeight: 250,
              selectedTrailingIcon: const Icon(Icons.keyboard_arrow_up_sharp,color: AppC.appColor,),
              trailingIcon: const Icon(Icons.keyboard_arrow_down_sharp,color: AppC.appColor,),
              textStyle: TextStyle(
                  color: AppC.text,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 12.sp
              ),
              inputDecorationTheme:  InputDecorationTheme(
                hintStyle: const TextStyle(color: AppC.grey),
                contentPadding: EdgeInsets.symmetric(horizontal: 10.sp),
                border: border,
                enabledBorder: border,
                isCollapsed: true,
                isDense: true,
                suffixIconConstraints: const BoxConstraints.tightFor(width: 30),
                constraints: BoxConstraints(maxHeight: height.sp)
              ),
              menuStyle: MenuStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                visualDensity: const VisualDensity(vertical: VisualDensity.minimumDensity),
              ),
              expandedInsets: 0.padding,
              dropdownMenuEntries:
              listData.map<DropdownMenuEntry<Map<String, dynamic>>>(
                    (dynamic value){
                  return  DropdownMenuEntry<Map<String, dynamic>>(
                    value: value,
                    label: '${value[labelKey]??''} ${value[labelKey2]??''}'.trim(),
                  );
                },
              ).toList(),
              onSelected: (selectedValue) {
                onSelected(selectedValue);
                field.didChange(selectedValue ?? initialSelection);
              },
            ),
              if (field.hasError)
                Row(
                  spacing: 8,
                  children: [
                    const SizedBox.shrink(),
                    Text(field.errorText ?? "", style: CommonHelper.instance.navigatorKey.currentContext?.textTheme.labelMedium?.copyWith(color: AppC.errorTextColor, fontWeight: FontWeight.w100))
                  ],
                )
          ],
        );
      },
    );

  }

  static Widget dropdownSearchBox(
      String hintText,
      List<dynamic> listData,
      Function(dynamic selectedValue) onSelected,
      {required String labelKey,
        dynamic initialSelection,
        bool enableSearch = false,
        bool requestFocusOnTap = false,
        bool enableFilter = false,
        dynamic selectedKey,
        Color? arrowColor=AppC.appColor,
        TextEditingController? controller,
      }) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppC.fieldBase,
          width: Num.borderWidthField,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(Num.subradiusButton),
        ),
      ),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.centerRight,
            child: const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(
                Icons.keyboard_arrow_down_sharp,
                color:AppC.appColor,
                size: 14,
              ),
            ),
          ),
          DropdownMenu<dynamic>(
            key: ValueKey(selectedKey),
            initialSelection: initialSelection,
            controller: controller,
            hintText: hintText,
            menuHeight: 250,
            enableSearch: enableSearch,
             requestFocusOnTap:requestFocusOnTap ,
            enableFilter: enableFilter,
            /*trailingIcon: const Icon(
              Icons.keyboard_arrow_down_sharp,
              size: 12,
              color: AppC.trans,
            ),*/
            /*selectedTrailingIcon: const Icon(
              Icons.keyboard_arrow_down_sharp,
              size: 12,
              color: AppC.trans,
            ),*/
            textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis),
            inputDecorationTheme: const InputDecorationTheme(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              border: InputBorder.none,
              suffixIconColor: AppC.trans,
              isCollapsed: true,
              isDense: true,
            ),
            searchCallback: (entries, query) {
              if (query.isEmpty) return null;
              final int index = entries.indexWhere((entry) => entry.label == query);
              return index != -1 ? index : null;
            },
            menuStyle: MenuStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
              shadowColor: WidgetStateProperty.all<Color>(Colors.grey),
              //surfaceTintColor: WidgetStateProperty.all<Color>(Colors.white),
              visualDensity: const VisualDensity(vertical: VisualDensity.minimumDensity),
            ),
            expandedInsets: const EdgeInsets.only(top: 50),
            dropdownMenuEntries:
            listData.map<DropdownMenuEntry<Map<String, dynamic>>>(
                  (dynamic value){
                return DropdownMenuEntry<Map<String, dynamic>>(
                  value: value,
                  label: '${value[labelKey]??''}',
                );
              },
            ).toList(),
            onSelected: (selectedValue) {
              onSelected(selectedValue); // Adjust this as per the expected key
            },
          ),
        ],
      ),
    );
  }

  // Convert a 12-hour format string (e.g., '10:30 AM') to DateTime
  static DateTime convertTimeStringToDateTime(String time) {
    final format = DateFormat.jm(); // 12-hour format
    return format.parse(time);
  }

  // Convert DateTime to a 12-hour format string (e.g., '11:45 PM')
  static String convertDateTimeToTimeString(DateTime dateTime) {
    final format = DateFormat.jm(); // 12-hour format
    return format.format(dateTime);
  }

  static Widget getElevatedButton(
      VoidCallback onPressedCallback, {
        String text='Save',
        Color? bgColor=AppC.green,
        Color textColor = AppC.white,
        double borderRadius = Num.subradiusButton,
        double textSize= 12,
        IconData? icon,
      }) {
    return ElevatedButton.icon(
        onPressed: onPressedCallback,
      label: Utils.getText(text, color: AppC.white, weight: FontWeight.bold),
      icon: icon != null ? Icon(icon) : const SizedBox(),
      style: ButtonStyle(
          backgroundColor:  WidgetStatePropertyAll(bgColor),
          iconColor: const WidgetStatePropertyAll(AppC.white),
          //padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(16)))),
    );
  }

  static Widget getAddElevatedButton(
      VoidCallback onPressedCallback, {
        Color? bgColor=AppC.appColor,
        Color textColor = AppC.white,
        double borderRadius = Num.subradiusButton,
      }) {
    return ElevatedButton(
      onPressed: onPressedCallback,
      style: ButtonStyle(
          backgroundColor:  WidgetStatePropertyAll(bgColor),
          iconColor: const WidgetStatePropertyAll(AppC.white),
          shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(16)
          )
          )
      ),
      child: Icon(Icons.add,size: 20,color: textColor,),
    );
  }

  static Widget getAddFilledButton(
    String textLabel,
    VoidCallback onPressedCallback, {
    Color? bgColor,
    Color textColor = AppC.white,
    double borderRadius = Num.subradiusButton,
        double textSize= 12
  }) {
    return TaskerButton(
      onPressed: onPressedCallback,
      color: bgColor ?? AppC.appColor,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      // border: Border.all(
      //   color: AppC.orange,
      //   width: 2
      // ),
      // minWidth: 20,
      // height: 20,
      // clipBehavior: Clip.antiAliasWithSaveLayer,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      // ),
      borderRadius: BorderRadius.circular(borderRadius),
      child: Text(
        textLabel,
        style: TextStyle(
          color: textColor,
          fontSize: textSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Text getText(String text,
      {double size = 14,
      TextAlign? align,
      Color color = AppC.text,
      TextStyle? style,
        bool? softWrap,
      FontWeight weight = FontWeight.normal,
      TextDecoration? decoration,
        Color? colorDecoration,
      TextOverflow? overFlow}) {
    return Text(text,
        textAlign: align,
        softWrap: softWrap,
        style: style ?? TextStyle(
          color: color,
          fontSize: size,
          fontWeight: weight,
          decorationColor:colorDecoration,
          overflow: overFlow,
          decoration: decoration,
        ));
  }

  static Text getListText(List<String> text,
      {double size = 12,
        TextAlign? align,
        Color color = AppC.text,
        FontWeight weight = FontWeight.normal,
        TextDecoration? decoration,
        Color? colorDecoration,
        TextOverflow? overFlow}) {
    return Text(text.join(',\n'),
        textAlign: align,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: weight,
          decorationColor:colorDecoration,
          overflow: overFlow,
          decoration: decoration,
        ));
  }

  static TextStyle getTextStyle(
      {double size = 14,
      TextAlign? align,
      Color color = AppC.text,
      FontWeight weight = FontWeight.normal}) {
    return TextStyle(color: color, fontSize: size, fontWeight: weight);
  }

  static Text getAppBarText(String text,
      {double size = 15, TextAlign? align, Color color = AppC.text}) {
    return Text(text,
        textAlign: align, style: TextStyle(color: color, fontSize: size));
  }

  static Widget getTextFormField(
      String? labelText,
      TextEditingController controller,
      {Key? key,
      FocusNode? focusNode,
      Widget? label,
      double textSize = 12,
      Color textColor = AppC.text,
      FontWeight fontWeight = FontWeight.w400,
      bool readOnly = false,
      bool autoFocus = false,
      ValueChanged? onChangeCallback,
      TextInputType textType = TextInputType.text,
      TextInputAction? inputAction,
        TextStyle? style,
      int? maxLength,
      Color borderColor = AppC.fieldBase,
      Color hintTextColor = AppC.text,
      String? hintText,
      Widget? suffixIcon,
        Widget? prefixIcon,
      bool obscure = false,
        bool isDense = true,
      double? height,
      TextStyle? hintTextStyle,
      TextStyle? labelStyle,
      Color fillColor = AppC.trans,
      EdgeInsets contentPadding =
          const EdgeInsets.all(9),
      // VoidCallback? suffixIconCallback,
      VoidCallback? onTapCallback,
      String? Function(String?)? validator,
        bool showErrorSuffix = false,
        int minLines = 1,
        int maxLines = 1,
        bool isCollapsed = false,
      AutovalidateMode? autoValidate,
      List<TextInputFormatter>? textInputFormatter,
      double borderRadius = Num.subradiusButton,
        TextAlign textAlign = TextAlign.start,
      double borderWidth = Num.borderWidthField,
      textCapitalization = TextCapitalization.sentences,
      }) {
    // hintText = hintText ?? labelText;
    return FocusNodeWrapper(
      builder:(f) => ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, value, child) => TextFormField(
          key: key,
          validator: validator,
          spellCheckConfiguration: const SpellCheckConfiguration(),
          autovalidateMode: autoValidate,
          textInputAction: inputAction ?? TextInputAction.next,
          onTap: onTapCallback,
          focusNode: f,
          autofocus: autoFocus,
          controller: controller,
          keyboardType: textType,
          readOnly: readOnly,
          maxLength: maxLength,
          obscureText: obscure,
          //onTapUpOutside: (event) => controller.value.copyWith(selection: const TextSelection.collapsed(offset: 0)),
          //onTapOutside: (event) => controller.value.copyWith(selection: const TextSelection.collapsed(offset: 0)),
          onTapOutside: (event) {
            f.unfocus();
            dismissKeyboard(context);
          },
          textCapitalization: textCapitalization,
          inputFormatters: textInputFormatter,
          textAlign: textAlign,
          minLines: minLines,
          maxLines: maxLines,
          decoration: InputDecoration(
              contentPadding: contentPadding,
              constraints: const BoxConstraints(),
              isDense: isDense,
              // label: label,
              labelText: labelText,
              hintText: hintText,
              counterText: '',
              hintStyle: hintTextStyle ??  TextStyle(color: AppC.grey,fontSize: 12.sp,fontWeight: FontWeight.w300),
              labelStyle: labelStyle ??  TextStyle(color: AppC.grey,fontSize: 12.sp,fontWeight: FontWeight.w300),
              filled: true,
              isCollapsed: isCollapsed,
              fillColor: fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: borderColor,
                  width: borderWidth,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: borderColor,
                  width: borderWidth,
                ),
              ),
              // focusedBorder: OutlineInputBorder(
              //     borderSide: BorderSide(
              //       color: borderColor,
              //       width: borderWidth,
              //     ),
              //     borderRadius: BorderRadius.circular(borderRadius)),
              suffixIconConstraints: BoxConstraints(),
              suffixIcon: suffixIcon,
            prefixIconConstraints: BoxConstraints(),
            prefixIcon: prefixIcon,
          ),
          style: style ?? TextStyle(
            // fontSize: textSize,
            color: textColor,
            fontWeight: fontWeight,
            fontSize: 12.sp,
          ),
          onChanged: onChangeCallback,
        )
      ),
    );
  }

  static Widget getNumberFormField(
      String? labelText,
      TextEditingController controller,
      {Key? key,
        FocusNode? focusNode,
        Widget? label,
        double textSize = 12,
        Color textColor = AppC.text,
        FontWeight fontWeight = FontWeight.w400,
        bool readOnly = false,
        bool autoFocus = false,
        ValueChanged? onChangeCallback,
        TextInputType textType = TextInputType.text,
        TextInputAction? inputAction,
        TextStyle? style,
        int? maxLength,
        Color borderColor = AppC.fieldBase,
        Color hintTextColor = AppC.text,
        String? hintText,
        Widget? suffixIcon,
        Widget? prefixIcon,
        bool obscure = false,
        bool isDense = true,
        double? height,
        TextStyle? hintTextStyle,
        TextStyle? labelStyle,
        Color fillColor = AppC.trans,
        EdgeInsets contentPadding =
        const EdgeInsets.all(9),
        // VoidCallback? suffixIconCallback,
        VoidCallback? onTapCallback,
        String? Function(String?)? validator,
        bool showErrorSuffix = false,
        int minLines = 1,
        int maxLines = 1,
        bool isCollapsed = false,
        AutovalidateMode autoValidate = AutovalidateMode.disabled,
        List<TextInputFormatter>? textInputFormatter,
        double borderRadius = Num.subradiusButton,
        TextAlign textAlign = TextAlign.start,
        double borderWidth = Num.borderWidthField}) {
    // hintText = hintText ?? labelText;
    return FocusNodeWrapper(
      builder:(f) => ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, child) => TextFormField(
            key: key,
            validator: validator,
            spellCheckConfiguration: const SpellCheckConfiguration(),
            autovalidateMode: autoValidate,
            textInputAction: inputAction ?? TextInputAction.next,
            onTap: onTapCallback,
            focusNode: focusNode,
            autofocus: autoFocus,
            controller: controller,
            keyboardType: TextInputType.number,
            readOnly: readOnly,
            maxLength: maxLength,
            obscureText: obscure,
            //onTapUpOutside: (event) => controller.value.copyWith(selection: const TextSelection.collapsed(offset: 0)),
            //onTapOutside: (event) => controller.value.copyWith(selection: const TextSelection.collapsed(offset: 0)),
            onTapOutside: (event){
              f.unfocus();
              dismissKeyboard(context);
            },
            textCapitalization: TextCapitalization.sentences,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: textAlign,
            minLines: minLines,
            maxLines: maxLines,
            decoration: InputDecoration(
              contentPadding: contentPadding,
              constraints: const BoxConstraints(),
              isDense: isDense,
              // label: label,
              labelText: labelText,
              hintText: hintText,
              counterText: '',
              hintStyle: hintTextStyle ??  TextStyle(color: AppC.grey,fontSize: 12.sp,fontWeight: FontWeight.w300),
              labelStyle: labelStyle ??  TextStyle(color: AppC.grey,fontSize: 12.sp,fontWeight: FontWeight.w300),
              filled: true,
              isCollapsed: isCollapsed,
              fillColor: fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: borderColor,
                  width: borderWidth,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: borderColor,
                  width: borderWidth,
                ),
              ),
              // focusedBorder: OutlineInputBorder(
              //     borderSide: BorderSide(
              //       color: borderColor,
              //       width: borderWidth,
              //     ),
              //     borderRadius: BorderRadius.circular(borderRadius)),
              suffixIconConstraints: BoxConstraints(),
              suffixIcon: suffixIcon,
              prefixIconConstraints: BoxConstraints(),
              prefixIcon: prefixIcon,
            ),
            style: style ?? TextStyle(
              // fontSize: textSize,
              color: textColor,
              fontWeight: fontWeight,
              fontSize: 12.sp,
            ),
            onChanged: onChangeCallback,
          )
      ),
    );
  }

  static Widget getTextFormFieldWithMultipleIcon(
      String? labelText,
      TextEditingController controller, {
        Key? key,
        FocusNode? focusNode,
        Widget? label,
        double textSize = 12,
        Color textColor = AppC.text,
        FontWeight fontWeight = FontWeight.w400,
        bool readOnly = false,
        bool autoFocus = false,
        ValueChanged? onChangeCallback,
        TextInputType textType = TextInputType.text,
        TextInputAction? inputAction,
        TextStyle? style,
        int? maxLength,
        Color borderColor = AppC.fieldBase,
        Color hintTextColor = AppC.text,
        String? hintText,
        Widget? prefixIcon,
        bool obscure = false,
        bool isDense = true,
        double? height,
        TextStyle? hintTextStyle,
        TextStyle? labelStyle,
        TextStyle? counterTextStyle,
        Color fillColor = AppC.trans,
        EdgeInsets contentPadding = const EdgeInsets.symmetric(horizontal: 9),
        VoidCallback? onTapCallback,
        String? Function(String?)? validator,
        bool showErrorSuffix = false,
        int minLines = 1,
        int maxLines = 1,
        bool isCollapsed = false,
        AutovalidateMode autoValidate = AutovalidateMode.disabled,
        List<TextInputFormatter>? textInputFormatter,
        double borderRadius = Num.subradiusButton,
        TextAlign textAlign = TextAlign.start,
        double borderWidth = Num.borderWidthField,
        VoidCallback? onSuffixTap,
        VoidCallback? onSuffixTap1,
        VoidCallback? onSuffixTap2,
        IconData suffixIconData = Icons.add,
        IconData? suffixIconData1,
        IconData? suffixIconData2,
        Color? iconColor = AppC.appColor,
        Color? iconColor1,
        Color? iconColor2,
        String?  bottomTrailingText,
      }) {
    return FocusNodeWrapper(
      builder:(f) => ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, value, child) => TextFormField(
          key: key,
          validator: validator,
          spellCheckConfiguration: const SpellCheckConfiguration(),
          autovalidateMode: autoValidate,
          textInputAction: inputAction ?? TextInputAction.next,
          onTap: onTapCallback,
          focusNode: focusNode,
          autofocus: autoFocus,
          controller: controller,
          keyboardType: textType,
          readOnly: readOnly,
          maxLength: maxLength,
          obscureText: obscure,
          onTapOutside: (event){
            f.unfocus();
            dismissKeyboard(context);
          },
          textCapitalization: TextCapitalization.sentences,
          inputFormatters: textInputFormatter,
          textAlign: textAlign,
          minLines: minLines,
          maxLines: maxLines,
          decoration: InputDecoration(
            contentPadding: contentPadding,
            constraints: const BoxConstraints(),
            isDense: isDense,
            labelText: labelText,
            hintText: hintText,
            counterText: bottomTrailingText,
            counterStyle: counterTextStyle ?? const TextStyle(color: AppC.red),
            hintStyle: hintTextStyle ?? const TextStyle(color: AppC.grey),
            labelStyle: labelStyle ?? const TextStyle(color: AppC.grey, fontSize: 13),
            filled: true,
            isCollapsed: isCollapsed,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: borderColor,
                width: borderWidth,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: borderColor,
                width: borderWidth,
              ),
            ),
            suffixIconConstraints: const BoxConstraints(),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(top: 1.5,bottom: 1.5,right: 1.5),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: suffixIconData1 != null ? 150 : 50,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: onSuffixTap,
                      child:
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor,width: 0.2),
                          color: AppC.blue50,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                          child: Icon(suffixIconData, color: iconColor),
                        ),
                      ),
                    ),
                    if(suffixIconData1 != null)
                    InkWell(
                      onTap: onSuffixTap1,
                      child:
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor,width: 0.2),
                          color: AppC.blue50,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationZ(50 * math.pi / 180),
                            child: Icon(suffixIconData1, color: iconColor1),
                          ),
                        ),
                      ),
                    ),
                    if(suffixIconData2 != null)
                    InkWell(
                      onTap: onSuffixTap2,
                      child:
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor,width: 0.2),
                          color: AppC.blue50,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                          child: Icon(suffixIconData2, color: iconColor2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(),
            prefixIcon: prefixIcon,
          ),
          style: style ??
              TextStyle(
                color: textColor,
                fontWeight: fontWeight,
              ),
          onChanged: onChangeCallback,
        ),
      ),
    );
  }

  static Widget getTextFormFieldWithIcon(
      String? labelText,
      TextEditingController controller, {
        Key? key,
        FocusNode? focusNode,
        Widget? label,
        double textSize = 12,
        Color textColor = AppC.text,
        FontWeight fontWeight = FontWeight.w400,
        bool readOnly = false,
        bool autoFocus = false,
        ValueChanged? onChangeCallback,
        TextInputType textType = TextInputType.text,
        TextInputAction? inputAction,
        TextStyle? style,
        int? maxLength,
        Color borderColor = AppC.fieldBase,
        Color hintTextColor = AppC.text,
        String? hintText,
        Widget? prefixIcon,
        bool obscure = false,
        bool isDense = true,
        double? height,
        TextStyle? hintTextStyle,
        TextStyle? labelStyle,
        Color fillColor = AppC.trans,
        EdgeInsets contentPadding = const EdgeInsets.symmetric(horizontal: 9),
        VoidCallback? onTapCallback,
        String? Function(String?)? validator,
        bool showErrorSuffix = false,
        int minLines = 1,
        int maxLines = 1,
        bool isCollapsed = false,
        AutovalidateMode autoValidate = AutovalidateMode.disabled,
        List<TextInputFormatter>? textInputFormatter,
        double borderRadius = Num.subradiusButton,
        TextAlign textAlign = TextAlign.start,
        double borderWidth = Num.borderWidthField,
        VoidCallback? onSuffixTap,
        IconData suffixIconData = Icons.add,
      }) {
    return FocusNodeWrapper(
      builder:(f) => ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, value, child) => TextFormField(
          key: key,
          validator: validator,
          spellCheckConfiguration: const SpellCheckConfiguration(),
          autovalidateMode: autoValidate,
          textInputAction: inputAction ?? TextInputAction.next,
          onTap: onTapCallback,
          focusNode: focusNode,
          autofocus: autoFocus,
          controller: controller,
          keyboardType: textType,
          readOnly: readOnly,
          maxLength: maxLength,
          obscureText: obscure,
          onTapOutside: (event){
            f.unfocus();
            dismissKeyboard(context);
          },
          textCapitalization: TextCapitalization.sentences,
          inputFormatters: textInputFormatter,
          textAlign: textAlign,
          minLines: minLines,
          maxLines: maxLines,
          decoration: InputDecoration(
            contentPadding: contentPadding,
            constraints: const BoxConstraints(),
            isDense: isDense,
            labelText: labelText,
            hintText: hintText,
            counterText: '',
            hintStyle: hintTextStyle ?? const TextStyle(color: AppC.grey),
            labelStyle: labelStyle ?? const TextStyle(color: AppC.grey, fontSize: 13),
            filled: true,
            isCollapsed: isCollapsed,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: borderColor,
                width: borderWidth,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: borderColor,
                width: borderWidth,
              ),
            ),
            suffixIconConstraints: const BoxConstraints(),
            suffixIcon: InkWell(
              onTap: onSuffixTap,
              child:
              Padding(
                padding: const EdgeInsets.only(top: 1.5,bottom: 1.5,right: 1.5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                    color: AppC.blue50,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    child: Icon(suffixIconData, color: AppC.appColor),
                  ),
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(),
            prefixIcon: prefixIcon,
          ),
          style: style ??
              TextStyle(
                color: textColor,
                fontWeight: fontWeight,
              ),
          onChanged: onChangeCallback,
        ),
      ),
    );
  }


  static Widget buildDropdownButton(String hintText, List<String> items,
      String? selectedItem, ValueChanged<String?> onChanged) {
    return SizedBox(
      height: 40,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppC.fieldBase,
            width: Num.borderWidthField,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(Num.subradiusButton),
          ),
        ),
        child: DropdownButton<String>(
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Utils.getText(hintText, color: AppC.grey),
          ),
          value: selectedItem,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: AppC.appColor),
          elevation: 3,
          dropdownColor: AppC.white,
          underline: Container(
            height: 0,
            color: Colors.transparent,
          ),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Utils.getText(value),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  static Widget getBorderedMultilineTextField(
      String labelText, TextEditingController controller,
      {FocusNode? focusNode,
      bool readOnly = false,
      double textSize = 14,
      Color textColor = AppC.text,
      FontWeight fontWeight = FontWeight.normal,
      ValueChanged? onChangeCallback,
      Color borderColor = AppC.fieldBase,
      Color hintTextColor = AppC.grey,
      AutovalidateMode autoValidate = AutovalidateMode.disabled,
      String? Function(String?)? validator,
      String? hintText,
      Color? fillColor=AppC.white,
      TextInputAction? inputAction,
      int minLines = 5,
      int? maxLines,
        double borderRadius = Num.subradiusButton,
        double borderWidth = Num.borderWidthField,
     // Widget? label,
      bool autofocus = false}) {
    return ValueListenableBuilder(
        valueListenable: controller,
      builder: (context, value, child) {
        return TextFormField(
          autofocus: autofocus,
          focusNode: focusNode,
          readOnly: readOnly,
          controller: controller,
          spellCheckConfiguration: const SpellCheckConfiguration(),
          keyboardType: TextInputType.text,
          validator: validator,
          autovalidateMode: autoValidate,
          maxLength: null,
          maxLines: maxLines,
          minLines: minLines,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: inputAction ?? TextInputAction.next,
          decoration: InputDecoration(
            constraints: BoxConstraints(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            //label: Utils.getText(labelText,color: AppC.grey),
            hintText: labelText,
            hintStyle: TextStyle(color: hintTextColor),
            filled: true,
            fillColor: fillColor,
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: borderColor, width: Num.borderWidthField),
              borderRadius: BorderRadius.circular(Num.radiusButton),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: borderColor,
                width: borderWidth,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: borderColor,
                width: borderWidth,
              ),
            ),
          ),
          style: TextStyle(
            fontSize: textSize,
            color: textColor,
            fontWeight: fontWeight,
          ),
          onChanged: onChangeCallback,
        );
      }
    );
  }

  static Widget getFilledButton(
      String textLabel, VoidCallback onPressedCallback,
      {double verticalPadding = 0.0,
      Color? bgColor,
      Color textColor = AppC.white,
      double borderRadius = Num.radiusButton,
      Alignment textAlign = Alignment.center}) {
    return SizedBox(
      child: TextButton(
          onPressed: onPressedCallback,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: bgColor ?? AppC().base,
            shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(Num.subradiusButton)),
            ),
          ),

          child: Align(
            alignment: textAlign,
            child: Text(
              textLabel,
              style: TextStyle(
                  color: textColor, fontWeight: FontWeight.w800, fontSize: 12),
            ),
          )),
    );
  }

  static Widget getOutlinedButton(
      String textLabel, VoidCallback onPressedCallback,
      {double verticalPadding = 4.0,
      Color bgColor = AppC.white,
      Color? textColor,
      Color? borderColor,
      Widget? iconData,
      BorderRadius radius =
          const BorderRadius.all(Radius.circular(Num.radiusButton))}) {
    return TextButton(
        onPressed: onPressedCallback,
        style: TextButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: borderColor ?? AppC().base,
                width: Num.borderWidthButton),
            borderRadius: radius,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding,horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                  visible: iconData != null, child: iconData ?? Container()),
              Visibility(
                  visible: iconData != null,
                  child: const SizedBox(
                    width: 5,
                  )),
              Text(
                textLabel,
                style: TextStyle(
                    color: textColor ?? AppC().base,
                    fontWeight: FontWeight.normal,
                    fontSize: 12),
              ),
            ],
          ),
        ),
    );
  }

  static ScrollbarProps getDropdownScrollbarProps() {
    return ScrollbarProps(
        interactive: true,
        trackColor: Colors.white,
        thumbVisibility: true,
        thumbColor: Colors.grey.shade500,
        thickness: 8.0,
        minThumbLength: 75,
        radius: const Radius.circular(5.0),
        trackVisibility: false);
  }

  static Widget popupDropDownBuilder(
      {String label = "", Color color = AppC.text, double fontSize = 14.0}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: getText(label, size: fontSize, color: color),
    );
  }

  static DropdownSearch getDropDownSearch(
      dynamic label,
      List<dynamic> dropdownList,
      ValueChanged onChangeValue,
      dynamic selectedItem,
      dynamic labelText,
      Widget Function(BuildContext, dynamic, bool) menuItemBuilder,
      Widget Function(BuildContext, dynamic) dropdownItemBuilder,
      {bool showSearch = true}) {
    return DropdownSearch<dynamic>(
        popupProps: PopupProps.menu(
            showSearchBox: showSearch,
            searchFieldProps: const TextFieldProps(
                autofocus: false,
                cursorColor: AppC.fieldBase,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(Num.subradiusButton)),
                        borderSide: BorderSide(
                            color: AppC.fieldBase,
                            width: Num.borderWidthField)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(Num.subradiusButton)),
                        borderSide: BorderSide(
                            color: AppC.fieldBase,
                            width: Num.borderWidthField)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(Num.subradiusButton)),
                        borderSide: BorderSide(
                            color: AppC.fieldBase,
                            width: Num.borderWidthField)))),
            scrollbarProps: getDropdownScrollbarProps(),
            itemBuilder: menuItemBuilder),
        dropdownButtonProps: const DropdownButtonProps(
            icon: Icon(Icons.arrow_drop_down, size: 22, color: AppC.fieldBase)),
        dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
          label: getText(labelText ?? ''),
          border: const OutlineInputBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(Num.subradiusButton)),
              borderSide: BorderSide(
                  width: Num.borderWidthField, color: AppC.fieldBase)),
          enabledBorder: const OutlineInputBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(Num.subradiusButton)),
              borderSide: BorderSide(
                  width: Num.borderWidthField, color: AppC.fieldBase)),
          focusedBorder: const OutlineInputBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(Num.subradiusButton)),
              borderSide: BorderSide(
                  width: Num.borderWidthField, color: AppC.fieldBase)),
          labelStyle: const TextStyle(color: AppC.text),
        )),
        items: dropdownList,
        onChanged: onChangeValue,
        selectedItem: selectedItem,
        dropdownBuilder: dropdownItemBuilder);
  }

  static DateTime convertStringToDateTime(String? value) {
    if (value != null && value.isNotEmpty) {
      DateTime dateTime = DateFormat("dd-MM-yyyy").parse(value);
      return dateTime;
    } else {
      return DateTime.now();
    }
  }

  // static DateTime convertStringToDate(String? dateStr) {
  //   try {
  //     return DateFormat("MMM-dd").parse(dateStr!); // Adjust format as needed
  //   } catch (e) {
  //     print("Error parsing date: $e");
  //     return DateTime.now(); // Return current date on error, or handle accordingly
  //   }
  // }

  static String convertString24HTo12H(String? value) {
    if (value != null && value.isNotEmpty) {
      DateTime parsedTime = DateFormat.Hms().parse(value);
      String time12hr = DateFormat('hh:mm a').format(parsedTime);
      return time12hr;
    } else {
      return '';
    }
  }

/*  static Future<DateTime?> datePickerDialog(
      BuildContext context, String existingDate,
      {DateTime? initial, DateTime? last}) {
    var initialDate = initial ?? DateTime.now();
    var currentDate = DateTime.now();
    if (existingDate.isNotEmpty) {
      currentDate = convertStringToDateTime(existingDate);
    }
    var lastDate = last ??
        DateTime(currentDate.year + 1, currentDate.month, currentDate.day);

    Widget dialog = DatePickerDialog(
      initialDate: currentDate,
      firstDate: initialDate,
      lastDate: lastDate,
      currentDate: currentDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      confirmText: 'Ok',
      cancelText: 'Cancel',
    );

    return showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppC().base,
            colorScheme: ColorScheme.light(primary: AppC().base),
            dialogBackgroundColor: Colors.white,
          ),
          child: dialog,
        );
      },
    );
  }*/

  static Future<DateTime?> datePicker(BuildContext context, String existingDate,
      {DateTime? initial, DateTime? last}) {
    var initialDate = initial;
    var currentDate = DateTime.now();
    if (existingDate.isNotEmpty) {
      currentDate = convertStringToDateTime(existingDate);
    }
    var lastDate = last ??
        DateTime(currentDate.year + 10, currentDate.month, currentDate.day);

    Widget dialog = DatePickerDialog(
      initialDate: initialDate,
      firstDate:DateTime(1900, 1, 1),
      lastDate: lastDate,
      currentDate: currentDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      confirmText: 'Ok',
      cancelText: 'Cancel',
    );

    return showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppC().base,
            colorScheme: ColorScheme.light(primary: AppC().base),
            dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
          ),
          child: dialog,
        );
      },
    );
  }

  static Future<DateTime?> todoDatePickerDialog(
      BuildContext context, String existingDate,
      {DateTime? initial, DateTime? last, int lastYear = 1}) {
    var initialDate = initial;
    var currentDate = DateTime.now();
    if (existingDate.isNotEmpty) {
      currentDate = convertStringToDateTime(existingDate);
    }
    var lastDate = last ??
        DateTime(currentDate.year + lastYear, currentDate.month, currentDate.day);

    Widget dialog = DatePickerDialog(
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1999, 9, 7, 17, 30),
      lastDate: lastDate,
      currentDate: currentDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      confirmText: 'Ok',
      cancelText: 'Cancel',
    );

    return showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppC().base,
            colorScheme: ColorScheme.light(primary: AppC().base),
            dialogBackgroundColor: Colors.white,
          ),
          child: dialog,
        );
      },
    );
  }

  static Future<DateTimeRange?> dateRangePickerDialog(
    BuildContext context,
    String existingDate, {
    DateTime? initial,
    DateTime? last,
    DateTime? startRange,
    DateTime? endRange,
  }) {
    DateTime initialDate = initial ?? DateTime.now();
    DateTime currentDate = DateTime.now();

    if (existingDate.isNotEmpty) {
      try {
        currentDate = convertStringToDateTime(existingDate);
      } catch (e) {
        currentDate = DateTime.now();
      }
    }
    DateTime lastDate = last ??
        DateTime(currentDate.year + 1, currentDate.month, currentDate.day);
    DateTime effectiveStart =
        startRange != null && startRange.isAfter(initialDate)
            ? startRange
            : initialDate;
    DateTime effectiveEnd =
        endRange != null && endRange.isBefore(lastDate) ? endRange : lastDate;
    Widget dialog = DateRangePickerDialog(
      initialDateRange: DateTimeRange(
        start: effectiveStart,
        end: effectiveEnd,
      ),
      firstDate: effectiveStart,
      lastDate: effectiveEnd,
      currentDate: effectiveStart,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    return showDialog<DateTimeRange>(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  static Text getRichText(String firstText, Color firstTextColor,
      String secondText, Color secondTextColor,
      {double firstFontSize = 14,
      double secondFontSize = 14,
      FontWeight? firstTextFontWeight,
      FontWeight? secondTextFontWeight,
      TextDecoration? firstTextDecoration,
      TextDecoration? secondTextDecoration}) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: firstText,
            style: TextStyle(
                fontWeight: firstTextFontWeight,
                color: firstTextColor,
                decoration: firstTextDecoration),
          ),
          TextSpan(
            text: secondText,
            style: TextStyle(
                fontWeight: secondTextFontWeight,
                color: secondTextColor,
                decoration: secondTextDecoration),
          ),
        ],
      ),
    );
  }

  static String convertDateTimeToTheFormat(String? value,
      {String formatToConvert = 'dd-MM-yyyy'}) {
    if (value != null && value.isNotEmpty) {
      DateTime dateValue = DateTime.parse(value);
      return DateFormat(formatToConvert).format(dateValue);
    } else {
      return DateFormat(formatToConvert).format(DateTime.now());
    }
  }

  static String convertDateToYearMonthDateFormat(String? value,
      {String formatToConvert = 'yyyy-MM-dd'}) {
    if (value != null && value.isNotEmpty) {
      DateTime dateValue = DateTime.parse(value);
      return DateFormat(formatToConvert).format(dateValue);
    } else {
      return DateFormat(formatToConvert).format(DateTime.now());
    }
  }

  static String convertDateToMonthDateYearFormat(String? value,
      {String formatToConvert = 'MM-dd-yy'}) {
    if (value != null && value.isNotEmpty) {
      DateTime dateValue = DateTime.parse(value);
      return DateFormat(formatToConvert).format(dateValue);
    } else {
      return DateFormat(formatToConvert).format(DateTime.now());
    }
  }

  static String convertCurrentDateToDateMonthYearFormat(String? value,
      {String formatToConvert = 'dd-MM-yyyy'}) {
    if (value != null && value.isNotEmpty) {
      DateTime dateValue = DateTime.parse(value);
      return DateFormat(formatToConvert).format(dateValue);
    } else {
      return DateFormat(formatToConvert).format(DateTime.now());
    }
  }

  static String convertCurrentDateToStringFormat(DateTime? value,
      {String formatToConvert = 'yyyy-MM-dd'}) {
    if (value != null) {
      return DateFormat(formatToConvert).format(value);
    } else {
      return DateFormat(formatToConvert).format(DateTime.now());
    }
  }

  static String amountInputFormatter(String nValue) {
    if (nValue.split('.').length > 2) {
      List<String> split = nValue.split('.');
      nValue = '${split[0]}.${split[1]}';
      return nValue;
    }
    return nValue;
  }

  static Uri getUri(String apiUrl) {
    if (apiUrl.isNotEmpty) {
      return Uri.parse(apiUrl);
    }
    return Uri.parse("");
  }

  static Map<String, String> getHeaders() {
    return {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  static Map<String, String> getHeadersWithToken({required String url}) {
    debugPrint('accessTokenGlobal: $accessTokenGlobal');
    return {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': (url.isFairReturns) ? returnBearerToken : 'Bearer $accessTokenGlobal'
    };
  }

  static Future<bool> connection() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    debugPrint('result.name: ${result.name}');
    if (result.name == 'none') {
      return false;
    } else {
      return true;
    }
  }

  static void showMobileToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 4,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 15.0,
      webShowClose: true,
    );
  }

  static void successMobileToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 4,
      backgroundColor: AppC.green,
      textColor: Colors.white,
      fontSize: 15.0,
      webShowClose: true,
    );
  }

  static void scrollDown(ScrollController scrollController) {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100), curve: Curves.linear);
  }

  static void scrollUp(ScrollController scrollController) {
    scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 100), curve: Curves.linear);
  }

  static void showSomethingWentWrong() {
    Utils.showMobileToast(Str.somethingWentWrong);
  }

  static void showNoResultFound() {
    Utils.showMobileToast(Str.noResultFoundText);
  }

  static void showInvalidInputs() {
    Utils.showMobileToast(Str.invalidInputs);
  }

/*
  static Widget getProgressIndicator(
      {Color progressColor = AppC().base}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(progressColor),
          strokeWidth: 2,
          backgroundColor: AppC.trans,
        ),
      ),
    );
  }
*/

  static Widget getProgressIndicator(BuildContext context,
      {Color? progressColor, double width = 80, double height = 80}) {
    return Image.asset(
      Assets.loaderGif,
      width: width,
      height: height,
      fit: BoxFit.fitHeight,
    );
  }

  static Widget getEmptyTextWidget(
      {String text = Str.noResultFoundText,
      Color textColor = AppC.text,
      TextAlign textAlign = TextAlign.center,
      double topPadding = 0.0,
      double bottomPadding = 0.0}) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: getText(text, size: 18, color: textColor, align: textAlign),
    );
  }

  static void getAlertDialog(
    BuildContext context,
    VoidCallback yesCallback, {
    String leftText = Str.yesText,
    String rightText = Str.cancelText,
    String content = 'Are you sure, do you want to logout?',
    String title = Str.alertText,
    bool isThirdButtonNeeds = false,
    String? thirdButtonText,
    VoidCallback? thirdButtonCallback,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Removing border radius
        ),
        title: Utils.getText(title, size: 16),
        content: Utils.getText(content),
        actions: [
          Utils.getOutlinedButton(leftText, yesCallback,
              verticalPadding: 5, borderColor: AppC.white),
          Visibility(
              visible: isThirdButtonNeeds,
              child: Utils.getOutlinedButton(
                  thirdButtonText ?? '', thirdButtonCallback ?? () {},
                  verticalPadding: 5, borderColor: AppC.white)),
          Utils.getOutlinedButton(rightText, () {
            Navigator.of(context).pop();
          }, verticalPadding: 5, borderColor: AppC.white),
        ],
      ),
    );
  }

  static void getAlertDialogWithTextField(BuildContext context,
      VoidCallback yesCallback, TextEditingController? controller,
      {String leftText = Str.yesText,
      String rightText = Str.cancelText,
      String content = 'Are you sure, do you want to logout?',
      String title = Str.alertText}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Removing border radius
        ),
        surfaceTintColor: AppC.white,
        shadowColor: AppC.white,
        backgroundColor: AppC.white,
        title: Utils.getText(title, size: 16),
        content: Utils.getBorderedMultilineTextField('', controller!,
            fillColor: AppC.white),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Utils.getOutlinedButton(rightText, () {
                Navigator.of(context).pop();
              }, verticalPadding: 5, borderColor: AppC.white),
              const SizedBox(
                width: 8,
              ),
              Utils.getOutlinedButton(leftText, yesCallback,
                  verticalPadding: 5, borderColor: AppC.white),
            ],
          ),
        ],
      ),
    );
  }

  static void getListOfImageTitleDialog(
      BuildContext context, String title, List<String> imageUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Removing border radius
        ),
        title: Utils.getText(title, size: 16),
        content: SizedBox(
            height: MediaQuery.of(context).size.height / 3.2,
            width: MediaQuery.of(context).size.width / 1.5,
            child: SizedBox(
              height: 80,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: imageUrl.length, // Number of items in the list
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageBuilder: (context, imageProvider) {
                          return Container(
                              decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ));
                        },
                        imageUrl: Str.STORAGE_BASE_URL + imageUrl[index],
                        placeholder: (context, url) =>
                            Utils.getProgressIndicator(context),
                        errorWidget: (context, url, error) {
                          return Container(
                              margin: const EdgeInsets.symmetric(vertical: 0),
                              padding: const EdgeInsets.all(0),
                              alignment: Alignment.center,
                              child: Utils.getText("CT",
                                  size: 22,
                                  color: AppC.red,
                                  weight: FontWeight.bold));
                        },
                      ),
                    ),
                  );
                },
              ),
            )),
        actions: [
          Utils.getOutlinedButton('Close', () {
            Navigator.of(context).pop();
          }, verticalPadding: 5, borderColor: AppC().base),
        ],
      ),
    );
  }

  static void getVerticalListOfImageTitleDialog(
      BuildContext context, String title, List<String> imageUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Removing border radius
        ),
        title: Utils.getText(title, size: 16),
        content: SizedBox(
            height: MediaQuery.of(context).size.height / 1.6,
            width: MediaQuery.of(context).size.width / 1.2,
            child: ListView.builder(
              shrinkWrap: true,
              // scrollDirection: Axis.horizontal,
              itemCount: imageUrl.length, // Number of items in the list
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: CachedNetworkImage(
                    /*imageBuilder: (context, imageProvider) {
                      return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ));
                    },*/
                    imageUrl: Str.STORAGE_BASE_URL + imageUrl[index],
                    placeholder: (context, url) =>
                        Utils.getProgressIndicator(context),
                    errorWidget: (context, url, error) {
                      return Container(
                          height: 100,
                          margin: const EdgeInsets.symmetric(vertical: 0),
                          padding: const EdgeInsets.all(0),
                          alignment: Alignment.center,
                          child: Utils.getText("CT",
                              size: 22,
                              color: AppC.red,
                              weight: FontWeight.bold));
                    },
                  ),
                );
              },
            )),
        actions: [
          Utils.getOutlinedButton('Close', () {
            Navigator.of(context).pop();
          }, verticalPadding: 5, borderColor: AppC().base),
        ],
      ),
    );
  }

  static void getImageTitleDialog(
    BuildContext context,
    String title,
    String status,
    String imageUrl,
    Color color,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        scrollable: true,
        shadowColor: AppC.white,
        surfaceTintColor: AppC.white,
        backgroundColor: AppC.white,
        actionsPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        content: Builder(builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 1.2,
            width: MediaQuery.of(context).size.width * 0.8,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.red,
                          weight: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Utils.getText(title, size: 16),
                      Utils.getText(status, size: 16, color: color)
                    ],
                  ),
                  InteractiveViewer(
                    maxScale: 8.0,
                    minScale: 0.01,
                    child: CachedNetworkImage(
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          height: 238,
                          width: 317,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      imageUrl: Str.STORAGE_BASE_URL + imageUrl,
                      placeholder: (context, url) =>
                          Utils.getProgressIndicator(context),
                      errorWidget: (context, url, error) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 0),
                          padding: const EdgeInsets.all(0),
                          alignment: Alignment.center,
                          child: Utils.getText("CT",
                              size: 22,
                              color: AppC.red,
                              weight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  static Widget getHeadCachedImageNetworkDisplay(
      BuildContext context, String imageUrl) {
    return SizedBox(
      width: 250.0, // Set the width as needed
      height: 130.0, // Set the width as needed
      child: ClipRRect(
        child: CachedNetworkImage(
          imageBuilder: (context, imageProvider) {
            return Container(
                decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fill,
              ),
            ));
          },
          imageUrl: Str.STORAGE_BASE_URL + imageUrl,
          placeholder: (context, url) => Utils.getProgressIndicator(context),
          errorWidget: (context, url, error) {
            return Container(
                color: AppC.grey,
                margin: const EdgeInsets.symmetric(vertical: 0),
                padding: const EdgeInsets.all(0),
                alignment: Alignment.center,
                child: Utils.getText("CT",
                    size: 22, color: AppC.red, weight: FontWeight.bold));
          },
        ),
      ),
    );
  }

  static Widget getOvalCachedImageNetworkDisplay(
      BuildContext context, String imageUrl) {
    return SizedBox(
      width: 60.0,
      height: 60.0,
      child: ClipRRect(
        child: CachedNetworkImage(
          imageBuilder: (context, imageProvider) {
            return Container(
                decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ));
          },
          imageUrl: Str.STORAGE_BASE_URL + imageUrl,
          placeholder: (context, url) => Utils.getProgressIndicator(context),
          errorWidget: (context, url, error) {
            return Container(
                decoration: BoxDecoration(
                  color: AppC.grey,
                  borderRadius: BorderRadius.circular(6),
                ),
                margin: const EdgeInsets.symmetric(vertical: 0),
                padding: const EdgeInsets.all(0),
                alignment: Alignment.center,
                child: Utils.getText("CT",
                    size: 22, color: AppC.red, weight: FontWeight.bold));
          },
        ),
      ),
    );
  }

  String getAutocompleteField() {
    return '/task-expenses-data - task name'
        '/vendors and /locations - vendor/location'
        '/getresources and /getCohortsData - vehicle/person'
        'oprionsbuilder, displaystringforoption, optionsviewbuilder, onselected, fieldviewbuilder, ';
  }

  static Future saveUserData(
    int userId,
    String name,
    List<String>? role,
    String token,
    String password,
    String email,
    List<String> userPermissionList,
    int branchId,
    int hrmId,
  ) async {
    // accessTokenGlobal = token; Str.userPermissionPrefText
    userPermissionsGlobal = [];
    userPermissionsGlobal!.addAll(userPermissionList);
    // userRole=[];
    // userRole!.addAll(roleList);
    accessTokenGlobal = token;
    userIdGlobal = userId.toString();
    Session.of
    ..set(Str.loginPrefText, token.isNotEmpty)
    ..set("name", name)
    ..set(Str.rolePrefText, role ?? [])
    ..set(Str.userPermissionPrefText, (userPermissionsGlobal ?? []))
    ..set(Str.passwordPrefText, password.toString())
    ..set(Str.userIdPrefText, userId.toString())
    ..set(Str.branchIdPrefText, branchId)
    ..set(Str.hrmIdPrefText, hrmId)
    ..set(Str.accessTokenPrefText, token)
    ..set(Str.emailPrefText, email);

    Utils.setStringPreference("name", name.toString());
    Utils.setStringListPreference(Str.rolePrefText, role ?? []);
    Utils.setStringListPreference(
        Str.userPermissionPrefText, (userPermissionsGlobal ?? []));
    Utils.setStringPreference(Str.passwordPrefText, password.toString());
    Utils.setStringPreference(Str.userIdPrefText, userId.toString());
    Utils.setIntPreference(Str.branchIdPrefText, branchId);
    Utils.setIntPreference(Str.hrmIdPrefText, hrmId);
    Utils.setStringPreference(Str.accessTokenPrefText, token);
    Utils.setStringPreference(Str.emailPrefText, email);
  }

  /*---------------------------------------------------Shared preference---------------------------------------------------*/
  static void setStringPreference(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String> getStringPreference(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  static void setStringListPreference(String key, List<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

  static Future<List<String>> getStringListPreference(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  static void setIntPreference(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static Future<int> getIntPreference(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }

  static void setBoolPreference(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static Future<bool> getBoolPreference(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static void setDoublePreference(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  static Future<double> getDoublePreference(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key) ?? 0.0;
  }

  static Future<void> deletePreferences({String? key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (key != null) {
      prefs.remove(key);
    } else {
      prefs.clear();
    }
  }

/*---------------------------------------------------------------------------------------*/

  static void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static Widget customAutoCompleteList(
      List<dynamic> suggestionList, Function(int) onSelected) {
    return Container(
      decoration: BoxDecoration(
          color: AppC.white,
          borderRadius: BorderRadius.circular(Num.radiusButton),
          border: Border.all(
            color: AppC.fieldBase,
            width: Num.borderWidthThinField,
          )),
      height: (30.0 * (suggestionList.length) > 350
          ? 350
          : (30.0 * (suggestionList.length))),
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
          itemCount: suggestionList.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  onSelected(index);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Utils.getText(suggestionList[index]),
                ));
          }),
    );
  }

  static Widget customAutoCompleteListParts(
      List<Map<String, dynamic>> suggestionList, Function(int) onSelected) {
    return Container(
      decoration: BoxDecoration(
          color: AppC.white,
          borderRadius: BorderRadius.circular(Num.radiusButton),
          border: Border.all(
            color: AppC.fieldBase,
            width: Num.borderWidthThinField,
          )),
      height: (30.0 * (suggestionList.length) > 350
          ? 350
          : (30.0 * (suggestionList.length))),
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
          itemCount: suggestionList.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  onSelected(index);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child:
                      Utils.getText(suggestionList[index]['name'].toString()),
                ));
          }),
    );
  }

  static Widget customAutoCompleteWithUnSelectedOption(
      List<dynamic> suggestionList, Function(int) onSelected,
      {bool isVehicleData = false, bool isAddress = false}) {
    return Container(
      decoration: BoxDecoration(
          color: AppC.white,
          borderRadius: BorderRadius.circular(Num.radiusButton),
          border: Border.all(
            color: AppC.fieldBase,
            width: Num.borderWidthThinField,
          )),
      height: (30.0 * (suggestionList.length) > 350
          ? 350
          : (30.0 * (suggestionList.length))),
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
          itemCount: suggestionList.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  onSelected(index);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: !isVehicleData && !isAddress
                      ? Utils.getText(suggestionList[index]['name'] ?? '')
                      : isVehicleData
                          ? Utils.getText(
                              "${suggestionList[index]['vehicle_name'] ?? ''}"
                              "${suggestionList[index]['vehicle_number'] != null ? ' - '
                                  '${suggestionList[index]['vehicle_number']}' : ''}")
                          : Utils.getText(suggestionList[index].address ?? ''),
                ));
          }),
    );
  }

  static searchList(List<dynamic> searchable, String searchableString) {
    List<String> searchLocal = [];
    for (var e in searchable) {
      if (e.isNotEmpty &&
          (e.toLowerCase())
              .contains(searchableString.toString().toLowerCase())) {
        searchLocal.add((e).trim());
      }
    }
    return searchLocal;
  }

  static List<dynamic> searchObjectList(
      List<dynamic> searchable, String searchableString,
      {bool isVehicleData = false, bool isAddress = false}) {
    List<dynamic> searchLocal = [];
    bool isSelected = false;
    if (!isVehicleData && isAddress) {
      for (var e in searchable) {
        if ((e['address'] ?? '').isNotEmpty &&
            ((e['address'] ?? '').toLowerCase())
                .contains(searchableString.toString().toLowerCase()) &&
            !e.isSelected) {
          searchLocal.add(e);
        }
      }
    } else if (!isVehicleData && !isAddress) {
      for (var e in searchable) {
        if ((e['name'] ?? '').isNotEmpty &&
            ((e['name'] ?? '').toLowerCase())
                .contains(searchableString.toString().toLowerCase()) &&
            !isSelected) {
          searchLocal.add(e);
        }
      }
    } else {
      for (var e in searchable) {
        if ((e['vehicle_name'] ?? '').isNotEmpty &&
            ((e['vehicle_name'] ?? '').toLowerCase())
                .contains(searchableString.toString().toLowerCase()) &&
            !isSelected) {
          searchLocal.add(e);
        } else if ((e['vehicle_number'] ?? '').isNotEmpty &&
            ((e['vehicle_number'] ?? '').toLowerCase())
                .contains(searchableString.toString().toLowerCase()) &&
            !isSelected) {
          searchLocal.add(e);
        }
      }
    }
    return searchLocal;
  }

  static String? getStringFromObjectList(List<dynamic> list) {
    // Filter the list to include only the resources with non-null 'id'
    return list
        .where(
            (resource) => resource['id'] != null) // Check if 'id' is not null
        .map((resource) =>
            resource['id'].toString()) // Convert the 'id' to string
        .join(','); // Join the 'id's into a comma-separated string
  }

  static List<String>? getStringListFromObjectList(
      List<Map<String, dynamic>> list) {
    return null; //list
    // .where((resource) =>
    //     isSelected ==
    //     true /* && resource.id != null && resource.id.isNotEmpty*/)
    // .map((resource) => resource['vin']!)
    // .toList();
    // return list.map((resource) => resource.isSelected?resource.id:'').join(',');
  }

  static void showObjectPopupMenuWithCheckBox(
      BuildContext context,
      List<Map<String, dynamic>> resourceListForCombination,
      details,
      Function(Map<String, dynamic>?) onSelect,
      bool isChecked,
      Function(bool?) onChanged) async {
    final Map<String, dynamic>? selectedValue =
        await showMenu<Map<String, dynamic>>(
            context: context,
            position: RelativeRect.fromLTRB(
              details.globalPosition.dx,
              details.globalPosition.dy,
              details.globalPosition.dx,
              details.globalPosition.dy,
            ),
            color: AppC.white,
            items: <PopupMenuEntry<Map<String, dynamic>>>[
          for (Map<String, dynamic> resource in resourceListForCombination)
            PopupMenuItem<Map<String, dynamic>>(
              value: resource,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                      value: resource['isSelected'] ?? false,
                      onChanged: onChanged),
                  Utils.getText(
                      '${resource['first_name'] ?? ''} ${resource['last_name'] ?? ''}'),
                ],
              ),
            )
        ]);
    if (selectedValue != null) {
      onSelect(selectedValue);
    }
  }

  static void showStringPopupMenu(
      BuildContext context,
      List<String> resourceListForCombination,
      details,
      Function(String?) onSelect) async {
    final String? selectedValue = await showMenu<String>(
        context: context,
        position: RelativeRect.fromLTRB(
          details.globalPosition.dx,
          details.globalPosition.dy,
          details.globalPosition.dx,
          details.globalPosition.dy,
        ),
        color: AppC.white,
        items: <PopupMenuEntry<String>>[
          for (int i = 0; i < resourceListForCombination.length; i++)
            PopupMenuItem<String>(
              value: resourceListForCombination[i],
              child: Utils.getText(resourceListForCombination[i],
                  color: i == 0 ? AppC.blue : AppC.red),
            )
        ]);
    if (selectedValue != null) {
      onSelect(selectedValue);
    }
  }

  static Future<void> showListAsSheet<T>(
      BuildContext outerContext,
      AnimationController? animationController,
      Widget childWidget,
      VoidCallback listItemTapCallback) {
    bool extentChanged(DraggableScrollableNotification notification) {
      // consume notification before it hits BottomSheet or Scaffold
      // This prevents dismissing the sheet when scrolled to its minChildSize
      return true;
    }

    return Scaffold.of(outerContext).showBottomSheet(
        backgroundColor: Colors.transparent, enableDrag: false, (_) {
      return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadiusDirectional.only(
              topStart: Radius.circular(55),
              topEnd: Radius.circular(55),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(20,
                    25), // Adjust the offset for the side you want the shadow
              ),
            ],
            color: AppC.white,
          ),
          child: NotificationListener<DraggableScrollableNotification>(
              onNotification: extentChanged,
              child: DraggableScrollableSheet(
                // shouldCloseOnMinExtent: false,
                initialChildSize: 0.8,
                maxChildSize: 1,
                minChildSize: 0.2,
                expand: false,
                builder: (_, scrollController) => SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(outerContext).size.width * 0.42),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          height: 5,
                          width: 60,
                          decoration: BoxDecoration(
                            color: AppC.grey.shade400,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(22)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      childWidget,
                      const SizedBox(
                        height: 35,
                      ),
                    ],
                  ),
                ),
              )));
    }).closed;
  }

  static String formatDateTime({dynamic input, required String? format}) {
    if (input is DateTime) {
      return DateFormat(format).format(input);
    } else if (input is TimeOfDay) {
      var val = input;
      return DateFormat(format).format(dt.Time.fromMinutes(val.hour * 60 + val.minute).asDateTime);
    } else {
      return "";
    }
  }

  /* ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: list.length,
                            itemBuilder: (_, index) {
                              return InkWell(
                                onTap: listItemTapCallback,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 12),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: const BorderSide(
                                          color: AppC.white, width: 1),
                                      left: const BorderSide(
                                          color: AppC.white, width: 1),
                                      right: const BorderSide(
                                          color: AppC.white, width: 1),
                                      bottom: BorderSide(
                                          color: Colors.grey.withOpacity(0.1),
                                          width: 1),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: const Offset(0,
                                            5), // Adjust the offset for the side you want the shadow
                                      ),
                                    ],
                                    color: AppC.white,
                                  ),
                                  child: Row(
                                    children: [
                                      getText('${index + 1}.   '),
                                      Expanded(child: getText('Test Vehicle')),
                                      const Icon(
                                        Icons.edit_outlined, color: AppC.redOpac,)
                                    ],
                                  ),
                                ),
                              );
                            }
                        ),*/
/*
 static void showAttachmentSheet(
      BuildContext outerContext, AnimationController? animationController) {
    showModalBottomSheet<void>(
        context: outerContext,
        transitionAnimationController: animationController,
        backgroundColor: AppC.trans,
        // enableDrag: true,
        isDismissible: false,
        isScrollControlled: true,
        // showDragHandle: true,
        // useSafeArea: true,
        // constraints: const BoxConstraints(minHeight: 100),
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            maxChildSize: 1.0,
            minChildSize: 0.2,

            expand: true, // Set to true if you want it to be expanded initially
              builder: (BuildContext context, ScrollController scrollController) {
                return Container(
                  // height: MediaQuery.of(context).size.height * 0.5, // Set your minimum height
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadiusDirectional.only(
                      topStart: Radius.circular(25),
                      topEnd: Radius.circular(25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0,
                            5), // Adjust the offset for the side you want the shadow
                      ),
                    ],
                    color: AppC.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery
                            .of(context)
                            .size
                            .width * 0.42),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          height: 5,
                          width: 60,
                          decoration: BoxDecoration(
                            color: AppC.grey.shade400,
                            borderRadius: const BorderRadius.all(Radius
                                .circular(22)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: const BorderSide(
                                      color: AppC.white, width: 1),
                                  left: const BorderSide(
                                      color: AppC.white, width: 1),
                                  right: const BorderSide(
                                      color: AppC.white, width: 1),
                                  bottom: BorderSide(
                                      color: Colors.grey.withOpacity(0.1),
                                      width: 1),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: const Offset(0,
                                        5), // Adjust the offset for the side you want the shadow
                                  ),
                                ],
                                color: AppC.white,
                              ),
                              child: Row(
                                children: [
                                  getText('${index + 1}.   '),
                                  Expanded(child: getText('Test Vehicle')),
                                  const Icon(
                                    Icons.edit_outlined, color: AppC.redOpac,)
                                ],
                              ),
                            );
                          }
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                    ],
                  ),
                );
              }
          );
        }).whenComplete(() {});
  }
*/
// Function to hide the keyboard
  static void hideKeyboard(BuildContext context) {
    // Unfocus the current focus node
    FocusScope.of(context).unfocus();
  }

  static Widget commonListItem(
      int index,
      String name,
      VoidCallback itemTapCallback,
      VoidCallback editTapCallback,
      VoidCallback deleteTapCallback,
      {double? horizontalMargin}) {
    return InkWell(
      onTap: itemTapCallback,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin ?? 15),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          border: Border(
            top: const BorderSide(color: AppC.white, width: 1),
            left: const BorderSide(color: AppC.white, width: 1),
            right: const BorderSide(color: AppC.white, width: 1),
            bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(
                  0, 5), // Adjust the offset for the side you want the shadow
            ),
          ],
          color: AppC.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Utils.getText('${index + 1}.   '),
              ],
            ),
            Expanded(
              child: Utils.getText(name),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: editTapCallback,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
                    decoration: const BoxDecoration(
                      color: AppC.violet,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                      // border: Border.all(color: AppC.fieldBase/*, width: 0.2*/)
                    ),
                    child: const Icon(Icons.edit_outlined,
                        color: AppC.white, size: 20),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: deleteTapCallback,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
                    decoration: BoxDecoration(
                      color: AppC.inProgress,
                      borderRadius: const BorderRadius.all(Radius.circular(2)),
                      // border: Border.all(color: AppC.fieldBase/*, width: 0.2*/)
                    ),
                    child: const Icon(Icons.delete_outline_rounded,
                        color: AppC.white, size: 20),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  static Widget commonListItemWithTwoColumns(
      int index,
      String name,
      String secondColumnValue,
      VoidCallback itemTapCallback,
      VoidCallback editTapCallback,
      VoidCallback deleteTapCallback,
      {double? horizontalMargin}) {
    return InkWell(
      onTap: itemTapCallback,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin ?? 15),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          border: Border(
            top: const BorderSide(color: AppC.white, width: 1),
            left: const BorderSide(color: AppC.white, width: 1),
            right: const BorderSide(color: AppC.white, width: 1),
            bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(
                  0, 5), // Adjust the offset for the side you want the shadow
            ),
          ],
          color: AppC.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Utils.getText('${index + 1}.   '),
              ],
            ),
            Expanded(
              child: Utils.getText(name),
            ),
            Expanded(
              child: Utils.getText(secondColumnValue),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: editTapCallback,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
                    decoration: const BoxDecoration(
                      color: AppC.violet,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                      // border: Border.all(color: AppC.fieldBase/*, width: 0.2*/)
                    ),
                    child: const Icon(Icons.edit_outlined,
                        color: AppC.white, size: 20),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: deleteTapCallback,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
                    decoration: BoxDecoration(
                      color: AppC.inProgress,
                      borderRadius: const BorderRadius.all(Radius.circular(2)),
                      // border: Border.all(color: AppC.fieldBase/*, width: 0.2*/)
                    ),
                    child: const Icon(Icons.delete_outline_rounded,
                        color: AppC.white, size: 20),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  static Widget commonListItemWithCheckbox(
      int index,
      String name,
      bool checkValue,
      ValueChanged onCheckChanged,
      VoidCallback itemTapCallback,
      VoidCallback editTapCallback,
      VoidCallback deleteTapCallback) {
    return InkWell(
      onTap: itemTapCallback,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          border: Border(
            top: const BorderSide(color: AppC.white, width: 1),
            left: const BorderSide(color: AppC.white, width: 1),
            right: const BorderSide(color: AppC.white, width: 1),
            bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(
                  0, 5), // Adjust the offset for the side you want the shadow
            ),
          ],
          color: AppC.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                    value: checkValue,
                    onChanged: onCheckChanged,
                    activeColor: AppC().base),
              ],
            ),
            Expanded(
              child: Utils.getText(name),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: editTapCallback,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
                    decoration: const BoxDecoration(
                      color: AppC.violet,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                      // border: Border.all(color: AppC.fieldBase/*, width: 0.2*/)
                    ),
                    child: const Icon(Icons.edit_outlined,
                        color: AppC.white, size: 20),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: deleteTapCallback,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
                    decoration: BoxDecoration(
                      color: AppC.inProgress,
                      borderRadius: const BorderRadius.all(Radius.circular(2)),
                      // border: Border.all(color: AppC.fieldBase/*, width: 0.2*/)
                    ),
                    child: const Icon(Icons.delete_outline_rounded,
                        color: AppC.white, size: 20),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  static Widget expenseListItem(
      int index,
      String name,
      String category,
      String subCategory,
      VoidCallback itemTapCallback,
      VoidCallback editTapCallback,
      VoidCallback deleteTapCallback,
      bool isNoCategory,
      Widget categoryDropdown,
      Widget subCategoryDropdown,
      VoidCallback cancelCallback,
      VoidCallback updateCallback,
      BuildContext context) {
    return isNoCategory
        ? InkWell(
            onTap: itemTapCallback,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              decoration: BoxDecoration(
                border: Border(
                  top: const BorderSide(color: AppC.white, width: 1),
                  left: const BorderSide(color: AppC.white, width: 1),
                  right: const BorderSide(color: AppC.white, width: 1),
                  bottom:
                      BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0,
                        5), // Adjust the offset for the side you want the shadow
                  ),
                ],
                color: AppC.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Utils.getText(name.trim().toString()),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(child: categoryDropdown),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(child: subCategoryDropdown)
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: cancelCallback,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(0)),
                                  border: Border.all(
                                      color: AppC.fieldBase /*, width: 0.2*/)),
                              child: const Icon(
                                Icons.check_rounded,
                                color: AppC.green,
                                size: 18,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: updateCallback,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(0)),
                                  border: Border.all(
                                      color: AppC.fieldBase /*, width: 0.2*/)),
                              child: const Icon(
                                Icons.clear_rounded,
                                color: AppC.red,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          )
        : InkWell(
            onTap: itemTapCallback,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                border: Border(
                  top: const BorderSide(color: AppC.white, width: 1),
                  left: const BorderSide(color: AppC.white, width: 1),
                  right: const BorderSide(color: AppC.white, width: 1),
                  bottom:
                      BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0,
                        5), // Adjust the offset for the side you want the shadow
                  ),
                ],
                color: AppC.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Utils.getText(name),
                  ),
                  Expanded(
                    child: Utils.getText(category),
                  ),
                  Expanded(
                    child: Utils.getText(subCategory),
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: editTapCallback,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 2),
                          decoration: const BoxDecoration(
                            color: AppC.violet,
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                            // border: Border.all(color: AppC.fieldBase/*, width: 0.2*/)
                          ),
                          child: const Icon(Icons.edit_outlined,
                              color: AppC.white, size: 20),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: deleteTapCallback,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 2),
                          decoration: BoxDecoration(
                            color: AppC.inProgress,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(2)),
                            // border: Border.all(color: AppC.fieldBase/*, width: 0.2*/)
                          ),
                          child: const Icon(Icons.delete_outline_rounded,
                              color: AppC.white, size: 20),
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            ),
          );
  }

  static Widget getCircleCheckWidget(
      VoidCallback voidCallback, bool isChecked, String label) {
    return GestureDetector(

      onTap: voidCallback,
      child: Row(
        children: [
          Container(
            height: 18,
            width: 18,
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isChecked ? AppC.blue : AppC.grey,
                width: 1.0,
              ),
              color: isChecked ? AppC.blue : AppC.trans,
            ),
            child: isChecked
                ? const Center(
                  child: Icon(
                      Icons.check,
                      size: 15.0,
                      color: AppC.white, // Check icon color when checked
                    ),
                )
                : Container(
                    padding: const EdgeInsets.all(8.0),
                  ),
          ),
          getText(label,weight: FontWeight.bold)
        ],
      ),
    );
  }

  static Widget getSearchBarUI({void Function(String)? onChange,
    void Function(String value)? onSearch,
    required TextEditingController searchController,
  bool readOnly = false}) {
    return CustomSearchBar(
      controller: searchController,
      onChanged: onChange,
      onSearch: onSearch,
      readOnly: readOnly,
    );
  }

/*  static Widget getSearchBarUI(
      VoidCallback? onTap, Function(String) onChange,
      TextEditingController searchController,
      {FocusNode? searchFocusNode, VoidCallback? onSubmitted, TextInputAction? inputAction} )
  {
    return SizedBox(
      height: 30,
      child: TextField(
        controller: searchController,
        // focusNode: FocusNode(),
        onChanged: onChange,
        cursorColor: AppC.black, // Set the cursor color
        style: const TextStyle(
          fontSize: 16, // Text size for entered text
          color: Colors.black, // Text color for entered text
        ),
        onEditingComplete: onSubmitted,
        textInputAction: inputAction,
        onSubmitted: (val) => onSubmitted?.call(),
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search_sharp,
            color: AppC.grey,
            size: 18,
          ),
          hintText: 'Search....',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14, // Hint text size
          ),
          filled: true,
          fillColor: AppC.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppC.fieldBase,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppC.fieldBase,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }*/


  static Widget getBorderedIcon(IconData? icon,
      {Color iconColor = AppC.green,
      Color borderColor = AppC.fieldBase,
      double iconSize = 18}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(0)),
          border: Border.all(color: borderColor /*, width: 0.2*/)),
      child: Icon(
        icon,
        color: iconColor,
        size: iconSize,
      ),
    );
  }

  static BoxDecoration getBoxDecoration({
    Color bgColor = AppC.trans,
    Color borderColor = AppC.fieldBase,
    double radius = Num.radiusButton,
  }) {
    return BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        border: Border.all(color: borderColor));
  }

  static String convert12to24Hour(String time12) {
    final format = DateFormat("hh:mm a");
    final DateTime time12Hour = format.parse(time12);
    final String time24Hour = DateFormat("HH:mm:ss").format(time12Hour);
    return time24Hour;
  }

  static String convertToHourMinutes(String time) {
    DateTime dateTime = DateFormat("HH:mm:ss").parse(time);
    return DateFormat("HH:mm").format(dateTime);
  }

  static List<String> parseVinList(String vinList) {
    vinList = vinList.replaceAll('"', '');
    vinList = vinList.replaceAll(' ', '');

    vinList = vinList.substring(1, vinList.length - 1);
    return vinList.split(',');
  }

  static String getStartOfMonth({DateTime? val}) {
    DateTime date = DateTime.now();
    if (val == null) {
      DateTime startOfMonth = DateTime(date.year, date.month, 1);
      return DateFormat('yyyy-MM-dd').format(startOfMonth);
    } else {
      return DateFormat('yyyy-MM-dd').format(val);
    }
  }

  static String getEndOfMonth({DateTime? val}) {
    DateTime date = DateTime.now();
    if (val == null) {
      DateTime startOfMonth = DateTime(date.year, date.month + 1, 0);
      return DateFormat('yyyy-MM-dd').format(startOfMonth);
    } else {
      return DateFormat('yyyy-MM-dd').format(val);
    }
  }

  static void openURL(String url, {bool isFile = false}) async {
    // if ((!url.isNetworkURL) && (isFile)) return;
    if (isFile) {
      OpenFile.open(url);
      return;
    }
    final Uri uri = isFile ? Uri.file(url) : Uri.parse(url);
    try {
      Console.of.error(uri);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        showMobileToast("Could not launch $uri");
      }
    } catch (e) {
      log('Error launching URL: $e');
      showMobileToast(e.toString());
    }
  }

  static void showPickerDate(BuildContext context, {DateTime? value, void Function(DateTime)? onChanged}) async {
    var result = await Future.microtask(() => showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(const Duration(days: 180)),
        currentDate: DateTime.now(),
        initialDate: value,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        lastDate: DateTime.now().add(const Duration(days: 1825000))));
    if (result != null) onChanged?.call(result);
    dismissKeyboard(context);
  }

  static void showPickerTime(BuildContext context, {TimeOfDay? value, void Function(TimeOfDay)? onChanged}) async {
    var result = await showTimePicker(
      context: context,
      initialTime: value ?? TimeOfDay.fromDateTime(DateTime.now()),
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );
    if (result != null) onChanged?.call(result);
    dismissKeyboard(context);
  }
}

extension Unique<E, Id> on List<E>? {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <dynamic>{};
    var list = inplace ? this : List<E>.from(this ?? []);
    list?.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list ?? [];
  }

  List<E> toUnique() {
    return this?.toSet().toList() ?? [];
  }
}

extension Validator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  bool isValidPassword() {
    return length >= 5;
  }

  bool isValidMobile() {
    return length >= 10;
  }
}
