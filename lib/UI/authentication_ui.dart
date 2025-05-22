import 'package:fairpytasker/Component/compact_text_field_with_label_title.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/Component/bottom_nav_for_task.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fairpytasker/Event/authentication_event.dart';
import 'package:fairpytasker/State/authentication_state.dart';
import 'package:fairpytasker/Bloc/authentication_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class AuthenticationUI extends StatelessWidget {
  const AuthenticationUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => AuthenticationBloc(),
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) async {
          if (state is AuthenticationLoading) {
            EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            switch (state) {
              case AuthenticationError():
                Toaster.showError(state.message, context: context);
                break;
              case AuthenticationNavigateState():
                context.pushReplacement(
                    const BottomNavigationForTaskView(selectedIndex: 0));
                break;
            }
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: AppC.white,
                image: DecorationImage(
                    opacity: 0.18,
                    image: AssetImage(Assets.splashBg),
                    repeat: ImageRepeat.repeat,
                    fit: BoxFit.contain)),
            child: Form(
              key: context.read<AuthenticationBloc>().formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10.sp,
                children: [
                  AnimatedContainer(
                      duration: Durations.long1,
                      curve: Curves.bounceIn,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 5),
                        child: Image.asset(Assets.taskManagerLogo),
                      )),
                  Column(
                    children: [
                      Text("Welcome Back !",
                          style: context.textTheme.titleLarge
                              ?.copyWith(color: AppC.appColor)),
                      Text("Sign in to continue.",
                          style: context.textTheme.labelLarge
                              ?.copyWith(color: AppC.grey)),
                    ],
                  ),
                  CompactTextFieldWithLabelTitle(
                    controller:
                        context.read<AuthenticationBloc>().emailController,
                    label: "Email",
                    hintText: "Enter email",
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => (value.isNullOrEmpty)
                        ? "Please enter email"
                        : (value?.isValidEmail() == false)
                            ? "Please enter valid email"
                            : null,
                  ),
                  CompactTextFieldWithLabelTitle(
                    controller:
                        context.read<AuthenticationBloc>().passwordController,
                    label: "Password",
                    hintText: "Enter password",
                    isPasswordField: true,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) => (value.isNullOrEmpty)
                        ? "Please enter password"
                        : (value?.isValidPassword() == false)
                            ? "Please enter valid password"
                            : null,
                  ),
                  Utils.getFilledButton(
                      'Sign In',
                      () => context
                          .read<AuthenticationBloc>()
                          .add(DoLoginEvent()),
                      verticalPadding: 5),
                ],
              ),
            ),
          );
        }),
      ),
    ));
  }
}
