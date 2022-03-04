import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:notesapp/layouts/app_layout.dart';
import 'package:notesapp/modueles/login_screen/login_screen.dart';
import 'package:notesapp/shared/componants/componants.dart';
import 'package:notesapp/shared/cubits/signup_cubit/sign_up_cubit.dart';
import 'package:notesapp/shared/cubits/signup_cubit/sign_up_states.dart';
import 'package:notesapp/shared/styles/styles/icon_broken.dart';

var passwordController = TextEditingController();
var userNameController = TextEditingController();

var emailController = TextEditingController();
GlobalKey<FormState> formKey = GlobalKey<FormState>();

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SignUpCubit(),
        child: BlocConsumer<SignUpCubit, SignUpStates>(
          listener: (context, state) {
            if (state is RegisterSuccessState) {
              navigateAndRemove(
                  context: context, widget: const NotesAppLayout());
            }
          },
          builder: (context, state) {
            SignUpCubit cubit = SignUpCubit.get(context);

            return Scaffold(
                appBar: AppBar(),
                body: Center(
                    child: Conditional.single(
                  context: context,
                  conditionBuilder: (context) => state is RegisterLoadingState,
                  widgetBuilder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  fallbackBuilder: (context) => SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            defaultFormField(
                                controller: userNameController,
                                textKeyboard: TextInputType.text,
                                prefix: IconBroken.User,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter your user name please";
                                  }
                                  if (value.length > 100) {
                                    return "Your user name can'\t be more than 100 ";
                                  }
                                  if (value.length < 2) {
                                    return "Your user name can'\t be less than 2 ";
                                  }
                                },
                                textLabel: 'User Name'),
                            const SizedBox(
                              height: 5,
                            ),
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'If you have an account ',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                textButton(
                                    text: 'Click here',
                                    fun: () {
                                      backTo(
                                          context: context,
                                          widget: LoginScreen());
                                    }),
                                const Spacer(),
                              ],
                            ),
                            defaultButton(
                                text: 'Sign Up',
                                fun: () async {
                                  if (formKey.currentState!.validate()) {
                                    //fun that add the data to fireAuth

                                    await cubit.signUpAuth(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        name: userNameController.text);

                                    //fun that add the data to fireCloud
                                    await cubit.fireStoreCloud(
                                      email: emailController.text,
                                      name: userNameController.text,
                                    );
                                  }
                                })
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
