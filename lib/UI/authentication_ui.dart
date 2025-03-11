import 'package:fairpytasker/Bloc/authentication_bloc.dart';
import 'package:fairpytasker/Event/authentication_event.dart';
import 'package:fairpytasker/State/authentication_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Component/bottom_nav_for_task.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/authenticator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationUI extends StatefulWidget {
  const AuthenticationUI({super.key});

  @override
  State<AuthenticationUI> createState() => _AuthenticationUIState();
}

class _AuthenticationUIState extends State<AuthenticationUI> {
  AuthenticationBloc? authenticationBloc;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPassword = true;
  bool showConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    authenticationBloc = AuthenticationBloc();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: BlocProvider(
            create: (context) =>
                authenticationBloc!..add(AuthenticationInitialEvent()),
            child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) async {
                if (state is AuthenticationLoaded) {
                  if (state.authenticationData != null) {
                    if (state.authenticationData?.token != null) {
                      Utils.saveUserData(
                          state.authenticationData!.id!,
                          state.authenticationData!.name!,
                          state.authenticationData!.role!,
                          state.authenticationData!.token!,
                          state.authenticationData!.password!,
                          state.authenticationData!.email!,
                          (state.userPermissions ?? []),
                          state.authenticationData!.branchId ?? 0,
                          state.authenticationData!.hrmId ?? 0);


                      Utils.setBoolPreference(Str.loginPrefText, true);
                      await Authenticator.instance.getBearerToken();
                      await Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(
                        builder: (context) => const BottomNavigationForTaskView(
                          selectedIndex: 0,
                          message: '',
                        ),
                      ));
                    }
                  }
                }
              },
              builder: (context, state) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 30),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              opacity: 0.35,
                              image: AssetImage(Assets.splashBg),
                              repeat: ImageRepeat.repeat,
                              fit: BoxFit.contain)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 10,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            child: Image.asset(
                                Assets.taskManagerLogo),
                          ),
                          Utils.getText('Welcome Back!',size: 18,color: AppC.appColor, weight: FontWeight.w600),
                          Utils.getText('Sign in to Continue',color:Colors.indigo.shade300, weight: FontWeight.normal),
                          Utils.getTextFormField(
                              'Email', emailController,
                              readOnly: false,
                              hintText: 'Enter Email ID',
                              hintTextColor: AppC.fieldBase,
                              inputAction: TextInputAction.next,
                              hintTextStyle: context.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.normal, color: context.theme.hintColor),
                              textType:
                              TextInputType.emailAddress,
                              onTapCallback: () {},
                              label: Utils.getText('Email')),
                          Utils
                              .getTextFormField(
                            'Password',
                            passwordController,
                            hintText: 'Enter Password',
                            hintTextColor: AppC.fieldBase,
                            hintTextStyle: context.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.normal, color: context.theme.hintColor),
                            inputAction: TextInputAction.done,
                            obscure: showPassword,
                            label: Utils.getText('Password'),
                            suffixIcon: InkWell(
                                child: Padding(
                                  padding: 10.padding,
                                  child: Icon(showPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons
                                      .remove_red_eye_outlined,size: 16,),
                                ),
                                onTap: () {
                                  showPassword = !showPassword;
                                  setState(() {});
                                }),
                          ),
                          Utils.getFilledButton(
                            'SignIn',
                                () {
                              Utils.dismissKeyboard(context);
                              if (emailController.text
                                  .trim()
                                  .isEmpty ||
                                  !emailController.text
                                      .trim()
                                      .isValidEmail()) {
                                Utils.showMobileToast(
                                    Str.emailEmptyValidAlertText);
                              } else if (passwordController.text
                                  .trim()
                                  .isEmpty ||
                                  !passwordController.text
                                      .trim()
                                      .isValidPassword()) {
                                Utils.showMobileToast(Str
                                    .passwordEmptyValidAlertText);
                              } else {
                                authenticationBloc!.add(
                                    DoLoginEvent(
                                        email: emailController.text,
                                        password: passwordController
                                            .text));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                        visible: (state is AuthenticationLoading),
                        child: Container(
                            // color: AppC.opacityWhiteColor ,
                            child: Utils.getProgressIndicator(context)))
                  ],
                );
              },
            ),
          )),
    );
  }
}
