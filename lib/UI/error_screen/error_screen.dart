import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Splash/splash_ui.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final FlutterErrorDetails errorDetails;
  const ErrorScreen(this.errorDetails, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_amber_rounded),
            Text(
              kDebugMode
                  ? errorDetails.summary.toString()
                  : 'Oops! Something went wrong!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: kDebugMode ? Colors.red : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 21),
            ),
            const SizedBox(height: 12),
            Text(
              kDebugMode
                  ? errorDetails.exceptionAsString()
                  : "We encountered an error and we've notified our engineering team about it. Sorry for the inconvenience caused.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
            SuccessButton(
              icon: Icons.refresh_rounded,
              text: 'Refresh',
              onPressed: () => context.pushReplacement(const SplashScreen()),
            )
          ],
        ),
      ),
    );
  }
}
