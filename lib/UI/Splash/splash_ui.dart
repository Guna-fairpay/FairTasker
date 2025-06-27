import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/UI/Splash/bloc/splash_bloc.dart';
import 'package:fairpytasker/UI/authentication/local_authentication_ui.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
    return Scaffold(
        backgroundColor: AppC.white,
        body: BlocProvider(
            create: (context) => SplashBloc()..add(InitialEvent()),
            child: BlocListener<SplashBloc, SplashState>(
                listener: (context, state) {
                  if (state is LoadingState) {
                    if (!EasyLoading.isShow)EasyLoading.show();
                  } else {
                    if (EasyLoading.isShow) EasyLoading.dismiss();
                    switch(state) {
                      case NavigateLoginState(): context.pushReplacement(const AuthenticationUI()); break;
                      case NavigateHomeState(): context.pushReplacement(const LocalAuthenticationUI()); break;
                    }
                  }
                },
                child: SafeArea(
                  child: Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    padding: EdgeInsets.only(
                        left: (MediaQuery.of(context).size.width / 6).ceilToDouble().spMin,
                        right: (MediaQuery.of(context).size.width / 6).ceilToDouble().spMin),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            repeat: ImageRepeat.repeat,
                            opacity: 0.35,
                            image: AssetImage(Assets.splashBg),
                            fit: BoxFit.contain)),
                    child: Image.asset(
                      Assets.taskManagerLogo,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ))));
  }
}
