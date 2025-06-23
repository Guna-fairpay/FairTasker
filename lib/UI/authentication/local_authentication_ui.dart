import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/Event/local_authentication_event.dart';
import 'package:fairpytasker/State/local_authentication_state.dart';
import 'package:fairpytasker/Bloc/local_authentication_bloc.dart';
import 'package:fairpytasker/Component/bottom_nav_for_task.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class LocalAuthenticationUI extends StatelessWidget {
  const LocalAuthenticationUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => LocalAuthenticationBloc()..add(LocalAuthenticationInitialEvent()),
      child: BlocListener<LocalAuthenticationBloc, LocalAuthenticationState>(
          listener: (context, state) {
            switch(state) {
              case LocalAuthenticationSuccessState(): context.pushReplacement(const BottomNavigationForTaskView(selectedIndex: 0)); break;
              case LocalAuthenticationFailureState(): if (state.message.toString().isNotNullOrEmpty) { Toaster.showError(state.message); } break;
            }
          },
          child: BlocBuilder<LocalAuthenticationBloc, LocalAuthenticationState>(builder: (context, state) => SafeArea(child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      repeat: ImageRepeat.repeat,
                      opacity: 0.35,
                      image: AssetImage(Assets.splashBg),
                      fit: BoxFit.contain)),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Image.asset(Assets.taskManagerLogo, fit: BoxFit.contain, width: (context.width * 0.5)),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(50),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 10,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor:
                              AppC.appColor.withValues(alpha: 0.5),
                              child: Padding(
                                padding: const EdgeInsets.all(1),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: AppC.lightGrey,
                                  child: Utils.getText(
                                      (Session.of.getString("name") ?? "")[0],
                                      color: AppC.appColor,
                                      size: 28,
                                      weight: FontWeight.w600),
                                ),
                              ),
                            ),
                            Utils.getText((Session.of.getString("name") ?? ""),
                                align: TextAlign.center,
                                weight: FontWeight.normal,
                                size: 16),
                            if (context.watch<LocalAuthenticationBloc>().showButton)
                            ElevatedButton.icon(
                              style: ButtonStyle(
                                backgroundColor:
                                WidgetStatePropertyAll(AppC().base),
                                iconColor:
                                const WidgetStatePropertyAll(Colors.white),
                                textStyle: const WidgetStatePropertyAll(
                                    TextStyle(
                                        fontFamily: "Lato",
                                        color: Colors.white)),
                                shape: WidgetStatePropertyAll(
                                    ContinuousRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            Num.borderRadiusLarge))),
                              ),
                              onPressed: () => context.read<LocalAuthenticationBloc>().add(LocalAuthenticationCheckEvent()),
                              label: Utils.getText("Login with biometric",
                                  color: Colors.white,
                                  size: 14,
                                  weight: FontWeight.w500),
                              icon: const Icon(
                                Icons.fingerprint_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )))),
    ));
  }
}
