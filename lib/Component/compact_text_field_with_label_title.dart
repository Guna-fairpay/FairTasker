import 'package:fairpytasker/Component/compact_text_field.dart';
import 'package:fairpytasker/Component/focus_node_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CompactTextFieldWithLabelTitle extends StatefulWidget {
  final TextEditingController? controller;
  final String? label, hintText;
  final bool isPasswordField;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  const CompactTextFieldWithLabelTitle({super.key, this.controller, this.isPasswordField = false, this.label, this.hintText, this.validator, this.textInputAction, this.keyboardType});

  @override
  State<CompactTextFieldWithLabelTitle> createState() => _CompactTextFieldWithLabelTitleState();
}

class _CompactTextFieldWithLabelTitleState extends State<CompactTextFieldWithLabelTitle> {
  bool _showPassword = false;
  @override
  void initState() {
    _showPassword = widget.isPasswordField;
    super.initState();
  }

  Widget get _passwordIcon {
    return (widget.isPasswordField) ? InkWell(
      onTap: () => setState(() => _showPassword = !_showPassword),
      child: Icon((_showPassword) ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: Colors.grey),
    ) : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 7.sp,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label ?? '', style: GoogleFonts.poppinsTextTheme().labelMedium),
        FocusNodeWrapper(builder: (focusNode) => CompactTextField(
          focusNode: focusNode,
          controller: widget.controller,
          hintText: widget.hintText,
          validator: widget.validator,
          obscureText: _showPassword,
          suffixIcon: _passwordIcon,
          textInputAction: widget.textInputAction,
          keyboardType: widget.keyboardType,
        )),
      ],
    );
  }
}
