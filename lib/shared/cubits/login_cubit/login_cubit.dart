
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/shared/componants/componants.dart';
import 'package:notesapp/shared/cubits/login_cubit/login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);
// log in
  Future<UserCredential?> logIn(
      {required email, required password})

  async {
  try {
 await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: email,
  password: password
  ).then((value) {
   emit(LoginLoadingState());


   emit(LoginSuccessState(value.user!.uid));

 }).catchError((onError){
   print(onError.toString());
   toast(text: 'please enter correct email and password or sign up now', state: ToastState.error);

   emit(LoginErrorState());
 });
  }

  on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
  print('No user found for that email.');
  toast(text: 'No user found for that email.', state: ToastState.error);


  emit(ShowToastState());
  } else if (e.code == 'wrong-password') {
    toast(
        text: 'wrong-password',
        state: ToastState.error);

    emit(ShowToastState());
  print('Wrong password provided for that user.');
  }
  }


  }


  bool isPassword = true;

  IconData suffix = Icons.visibility;

  void passwordVisibility() {
    isPassword = !isPassword;

    suffix = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(LoginPasswordShowState());
  }

}
