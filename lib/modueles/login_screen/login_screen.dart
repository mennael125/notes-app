import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:notesapp/layouts/app_layout.dart';
import 'package:notesapp/modueles/sign_up_screen/sign_up_screen.dart';
import 'package:notesapp/shared/componants/componants.dart';
import 'package:notesapp/shared/cubits/login_cubit/login_cubit.dart';
import 'package:notesapp/shared/cubits/login_cubit/login_states.dart';
import 'package:notesapp/shared/network/local/cach_helper.dart';
import 'package:notesapp/shared/styles/styles/icon_broken.dart';

var emailController = TextEditingController();
var passwordController = TextEditingController();

var formKey = GlobalKey<FormState>();

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LoginCubit(),
        child: BlocConsumer<LoginCubit, LoginStates>(
          listener: (context, state) {
            if (state is LoginSuccessState) {
              CacheHelper.savetData(key: 'uID', value: state.uID).then((value) {
                navigateAndRemove(context: context, widget: const NotesAppLayout());
              }).catchError((error) {
                print(error.toString());
              });
            }
          },
          builder: (context, state) {
            LoginCubit cubit = LoginCubit.get(context);

            return Scaffold(
                appBar: AppBar(),
                body: Conditional.single(
                    context: context,
                    conditionBuilder: (context) => state is LoginLoadingState,
                    widgetBuilder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                    fallbackBuilder: (context) => Center(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    defaultFormField(
                                        controller: emailController,
                                        textKeyboard: TextInputType.text,
                                        prefix: IconBroken.Message,
                                        validate: (value) {
                                          if (value!.isEmpty) {
                                            return "Enter your Email please";
                                          }
                                          if (value.length > 200) {
                                            return "Your Email can'\t be more than 200 ";
                                          }
                                          if (value.length < 2) {
                                            return "Your Email can'\t be less than 2 ";
                                          }
                                        },
                                        textLabel: 'Email'),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    defaultFormField(
                                        suffix: cubit.suffix,
                                        suffixPressed: cubit.passwordVisibility,
                                        controller: passwordController,
                                        textKeyboard: TextInputType.text,
                                        prefix: IconBroken.Lock,
                                        validate: (value) {
                                          if (value!.isEmpty) {
                                            return "Enter your password please";
                                          }
                                          if (value.length > 100) {
                                            return "Your password can'\t be more than 100 ";
                                          }
                                          if (value.length < 6) {
                                            return "Your password can'\t be less than 6 ";
                                          }
                                        },
                                        textLabel: 'Password',
                                        isPassword: cubit.isPassword),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'If you don\'t have an account ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        textButton(
                                            text: 'RegisterNow',
                                            fun: () {
                                              navigateTo(
                                                  context: context,
                                                  widget: SignUpScreen());
                                            }),
                                        const Spacer(),
                                      ],
                                    ),
                                    defaultButton(
                                      text: 'Sign In',
                                      fun: () async {
                                        if (formKey.currentState!.validate()) {
                                          await cubit.logIn(
                                              email: emailController.text,
                                              password:
                                                  passwordController.text);
                                        }
                                        //to make fields empty
                                        emailController.text = '';
                                        passwordController.text = '';
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )));
          },
        ));
  }
}
