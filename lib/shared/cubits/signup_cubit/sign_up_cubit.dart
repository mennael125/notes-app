
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/modeles/user_model.dart';
import 'package:notesapp/shared/componants/componants.dart';
import 'package:notesapp/shared/cubits/signup_cubit/sign_up_states.dart';

class SignUpCubit extends Cubit<SignUpStates> {
  SignUpCubit() : super(SignUpInitialState());

  static SignUpCubit get(context) => BlocProvider.of(context);

//sign up register throw firebase
  Future<UserCredential?> signUpAuth(
      {required email, required password, required name}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        emit(RegisterLoadingState());
        UserModel model = UserModel(
          email: email,
          uID: value.user!.uid,
          name: name,
        );

        emit(RegisterSuccessState());
      }).catchError((onError) {


        print(onError.toString());
        emit(RegisterErrorState());
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        toast(text: 'weak-password', state: ToastState.error);


        emit(ShowToastState());
        // print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        toast(
            text: 'The account already exists for that email.',
            state: ToastState.error);

        emit(ShowToastState());
      }
    } catch (e) {
      print(e);
    }
  }


  //fireStore cloud
  fireStoreCloud({
    required  String email ,
    required  String name ,


}) async {
    try{
      emit(FireCloudLoadingState());

      await FirebaseFirestore.instance.collection('Users'). doc(name).set({

        'Username':name ,
        'Email':email

      });
      emit(FireCloudSuccessState());

    }catch(e){

      print (e.toString());
      emit(FireCloudErrorState());
    }

  }



  //password Visibility
  bool isPassword = true;

  IconData suffix = Icons.visibility;

  void passwordVisibility() {
    isPassword = !isPassword;

    suffix = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(RegisterPasswordShowState());
  }
}
