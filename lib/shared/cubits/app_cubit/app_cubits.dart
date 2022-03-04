import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notesapp/modueles/edit_note/edit_notes.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:notesapp/modueles/add_note/add_notes.dart';
import 'package:notesapp/modueles/login_screen/login_screen.dart';
import 'package:notesapp/shared/componants/componants.dart';
import 'package:notesapp/shared/cubits/app_cubit/app_states.dart';
import 'package:notesapp/shared/network/local/cach_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notesapp/shared/styles/colors/colors.dart';

class NotesAppCubit extends Cubit<NotesAppStates> {
  NotesAppCubit() : super(NotesAppInitialState());

  static NotesAppCubit get(context) => BlocProvider.of(context);

  //fun to log out throw firebase
  Future<void> logOut({required context}) async {
    await FirebaseAuth.instance.signOut().then((value) {
      emit(LogOutLoadingState());
      navigateAndRemove(context: context, widget: LoginScreen());
      emit(LogOutSuccessState());
    }).catchError((onError) {
      emit(LogOutErrorState());
    });
  }

//dark mood
  bool isDark = false;

  void darkChange({
    bool? fromShared,
  }) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(DarkStateChange());
    } else {
      isDark = !isDark;
      CacheHelper.savetData(value: isDark, key: 'isDark');
      emit(DarkStateChange());
    }
  }

  //DismissConfirm
  dismissConfirm({required context, required String doc}) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: isDark ? Colors.white : HexColor('333739'),
            title: const Text("Confirm"),
            content: Text(
              "Are you sure you wish to delete this item?",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            actions: <Widget>[
              MaterialButton(
                  color: Colors.red,
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                    //delete from fire store
                    await FirebaseFirestore.instance
                        .collection('Notes')
                        .doc(doc)
                        .delete();
                  },
                  child: const Text("DELETE")),
              MaterialButton(
                color: Colors.green,
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("CANCEL"),
              )
            ]);
      },
    );

    emit(ConfirmSuccess());
  }

  //floating fun
  addNote(context) {
    navigateTo(context: context, widget: AddNotesScreen());
  }

//firebase messaging
  FirebaseMessaging fBM = FirebaseMessaging.instance;

  //get token
  getToken() {
    fBM.getToken().then((value) {
      print(value);
      print('__________________________________');
    }).catchError((error) {
      print(error.toString());
      print('__________________________________');
    });
  }

// //notify if app in   Foreground mode
//   onForeground(context) {
//     FirebaseMessaging.onMessage.listen((event) {
//       print(event.notification!.body);
//       print('__________________________________');
//
//     });
//   }
//what happen when you click in notify  if app in   background mode
//   onbackground(context) {
//     FirebaseMessaging.onMessageOpenedApp.listen((event) {
//       print(event.notification!.body);
//       print('__________________________________');
//     });
//   }
//what happen when you click in notify  if app in   terminate mode
//   onTerminated(context) async {
//     var message =  await FirebaseMessaging.instance.getInitialMessage() ;
//
//     if(message!=null){
//
//       navigateTo(context: context, widget: EditNotesScreen());
//     }
//   }

}
