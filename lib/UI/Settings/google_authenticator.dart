import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

class GoogleAuthenticatorUI extends StatefulWidget {
  const GoogleAuthenticatorUI({super.key});

  @override
  State<GoogleAuthenticatorUI> createState() => _GoogleAuthenticatorUIState();
}

class _GoogleAuthenticatorUIState extends State<GoogleAuthenticatorUI> {
  final String qrCodeData = "SY6ZRN5756QCX8KL"; // The QR code content
  final TextEditingController otpController = TextEditingController();

  void _verifyOTP() {
    String enteredCode = otpController.text;
    final isValid =
        enteredCode == "expectedCode"; // Replace with your verification logic

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isValid ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Utils.getText(isValid
                ? 'Verification successful!'
                : 'Invalid code. Please try again.'),
          ],
        ),
        backgroundColor: isValid ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        title: const Text("Settings"),
        automaticallyImplyLeading: false,
        leadingWidth: 0,
        actions: [
          IconButton(onPressed: context.pop, icon: const Icon(Icons.close_rounded))
        ],
        backgroundColor: AppC.appColor,
        foregroundColor: AppC.white,
      ),
      body: Padding(
        padding: 16.spMin.padding,
        child: Column(
          spacing: 16.spMin,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox.shrink(),
            Utils.getText(
              'Set up your two factor authentication by scanning the barcode below with Google Authenticator app.',
            ),
            Text.rich(TextSpan(
              text: "Alternatively, you can use the code\t",
              children: [
                TextSpan(text: qrCodeData, style: context.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold))
              ]
            )),
            Center(
              child: QrImageView(
                data: qrCodeData,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            Utils.getText(
              'Enter the code from the Google Authenticator app:',
              weight: FontWeight.bold,
            ),
            Row(
              spacing: 10.spMin,
              children: [
                Expanded(
                  child: Utils.getTextFormField(
                    'One time password',
                    otpController,
                    textType: TextInputType.number,
                  ),
                ),
                SuccessButton(
                  text: "Verify",
                  backgroundColor: AppC.appColor,
                  onPressed: _verifyOTP,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
