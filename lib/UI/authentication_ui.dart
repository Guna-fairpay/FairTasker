import 'package:fairpytasker/Bloc/authentication_bloc.dart';
import 'package:fairpytasker/Event/authentication_event.dart';
import 'package:fairpytasker/State/authentication_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Component/bottom_nav_for_task.dart';
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
  TextEditingController cEmailController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool showPassword = true;
  bool showConfirmPassword = true;
 // bool showLogin = false;
  // bool showCreateAccount = false;

  @override
  void initState() {
    super.initState();
    authenticationBloc = AuthenticationBloc();
    // checkBiometric();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          // appBar: AppBar(
          //   elevation: 0,
          //   centerTitle: true,
          //   backgroundColor: AppC.trans,
          //   title: Utils.getAppBarText(
          //      'Login',
          //       color: AppC.text,
          //       size: 18),
          // ),
          body: BlocProvider(
            create: (context) =>
                authenticationBloc!..add(AuthenticationInitialEvent()),
            child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) async {
                if (state is AuthenticationLoaded) {
                  if (state.authenticationData != null) {
                    if (state.authenticationData?.token != null) {
                      //var userData = state.authenticationData!.toJson(); // Convert User to JSON string

                      // Map<String, dynamic> decodedData = jsonDecode(jsonDecode(userData.toString()));

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
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(Assets.splashBg),
                              fit: BoxFit.cover)),
                      child: SingleChildScrollView(
                        child: Container(
                          color: Colors.white54,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 30),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 20),
                                  child: Image.asset(
                                      Assets.logoWithoutWatermarkBg),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Utils.getText('Welcome Back !',size: 18,color: AppC.appColor),
                                    const SizedBox(height: 10,),

                                    Utils.getText('Sign in to Continue',color:Colors.indigo.shade300),
                                    const SizedBox(height: 30,),
                                    Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                                            'Email', emailController,
                                            readOnly: false,
                                            hintText: 'Enter Email ID',
                                            hintTextColor: AppC.fieldBase,
                                            textType:
                                                TextInputType.emailAddress,
                                            onTapCallback: () {},
                                            label: Utils.getText('Email')),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Utils
                                        .getBackgroundFilledTextFieldFirstLetterCaps(
                                      'Password',
                                      passwordController,
                                      hintText: 'Enter Password',
                                      hintTextColor: AppC.fieldBase,
                                      obscure: showPassword,
                                      label: Utils.getText('Password'),
                                      suffixIcon: InkWell(
                                          child: Icon(showPassword
                                              ? Icons.visibility_off_outlined
                                              : Icons
                                                  .remove_red_eye_outlined,size: 16,),
                                          onTap: () {
                                            showPassword = !showPassword;
                                            setState(() {});
                                          }),
                                    ),
                                    const SizedBox(
                                      height: 35,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Utils.getFilledButton(
                                      'Login',
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
                                    const SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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
