import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/UI/Splash/bloc/splash_bloc.dart';
import 'package:fairpytasker/UI/authentication/local_authentication_ui.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/services.dart';
import 'package:fairpytasker/UI/authentication/authentication_ui.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top, // Shows Status bar and hides Navigation bar
      ],
    );
    return Scaffold(
        backgroundColor: AppC.white,
        body: BlocProvider(
            create: (context) => SplashBloc()..add(InitialEvent()),
            child: BlocConsumer<SplashBloc, SplashState>(
              listener: (context, state) {
                if (state is LoadingState) {
                  // if (!EasyLoading.isShow) EasyLoading.show();
                } else {
                  // if (EasyLoading.isShow) EasyLoading.dismiss();
                  switch (state) {
                    case NavigateLoginState():
                      context.pushReplacement(const AuthenticationUI());
                      break;
                    case NavigateHomeState():
                      context.pushReplacement(const LocalAuthenticationUI());
                      break;
                  }
                }
              },
              builder: (context, state) => Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        repeat: ImageRepeat.repeat,
                        opacity: 0.35,
                        image: AssetImage(Assets.splashBg),
                        fit: BoxFit.contain)),
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.passthrough,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: (MediaQuery.of(context).size.width / 6)
                                .ceilToDouble()
                                .spMin,
                            right: (MediaQuery.of(context).size.width / 6)
                                .ceilToDouble()
                                .spMin),
                        child: Image.asset(
                          Assets.taskManagerLogo,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                    if (Session.of.getBool(Str.loginPrefText) ?? false)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsetsGeometry.only(bottom: 150.spMin),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 5.spMin,
                            children: [
                              CompactText(
                                  (state is LoadingState)
                                      ? 'Fetching user information...'
                                      : "✅ Fetched user information...",
                                  color: AppC.lightDark,
                                  fontWeight: FontWeight.w200),
                              Padding(
                                  padding: 30.spMin.horizontalPadding,
                                  child: LinearProgressIndicator(
                                    borderRadius:
                                        BorderRadius.circular(5.spMin),
                                    backgroundColor: AppC.lightGray,
                                    color: AppC.appColor,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 30.spMin),
                        child: AnimatedCrossFade(
                            firstChild: const CompactText('Fetching version'),
                            secondChild: const CompactText('Version: 1.0.5'),
                            crossFadeState: (getIt<CommonService>().packageInfo?.version.isNotNullOrEmpty ?? false) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                            duration: Durations.extralong4),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
