import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../Component/header.dart';
import '../../Utilities/Utils.dart';
import '../../Utilities/appC.dart';

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
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0), // Change the height here
        child: HeaderView(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back)),
                      const SizedBox(
                        width: 10,
                      ),
                      Utils.getText(
                        'Google Authenticator',
                        size: 18,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Utils.getText(
                    'Set up your two factor authentication by scanning the barcode below with Google Authenticator app.',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Utils.getText(
                        'Alternatively, you can use the code',
                      ),
                      Expanded(
                        child: Utils.getText(' $qrCodeData',
                            weight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: QrImageView(
                      data: qrCodeData,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Utils.getText(
                    'Enter the code from the Google Authenticator app:',
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child:
                              Utils.getTextFormField(
                            'One time password',
                            otpController,
                            textType: TextInputType.number,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        height: 40,
                        child: Utils.getAddFilledButton('Verify', _verifyOTP),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
