import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notesapp/layouts/app_layout.dart';
import 'package:notesapp/modeles/add_note_model.dart';
import 'package:notesapp/shared/componants/componants.dart';
import 'package:notesapp/shared/cubits/add_note_cubit/add_states.dart';
import 'package:notesapp/shared/cubits/edit_note_cubit/edit_states.dart';
import 'package:path/path.dart';

class EditCubit extends Cubit<EditStates> {
  EditCubit() : super(InitialEditState());

  static EditCubit get(context) => BlocProvider.of(context);

  var imageUrl;

  pickImageAndEdit({required String refName, required ImageSource source ,required String note, required String title ,required String docId ,required context}) async {
    //pick image to fire store

    File _file;
    var picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      _file = File(picked.path);
      
      var rand = Random().nextInt(100000);
      //basename package is path. dart
      var nameImage = basename(picked.path);
      var ref =
      await FirebaseStorage.instance.ref(refName).child('$nameImage$rand');
      await ref.putFile(_file);
      imageUrl = await ref.getDownloadURL();
      //add note to fire store
      emit(EditNoteLoadingState());
        await FirebaseFirestore.instance
            .collection('Notes').doc(docId).update
          ({'Note': note, 'Title': title, 'Image': imageUrl , 'uID':            await FirebaseAuth.instance.currentUser!.uid,
        }).then((value) async {

//add data to model
////////////////////////////////
//           EditNoteModel model = EditNoteModel(
//             note: note,
//             title: title,
//             image: imageUrl,
//             uID:await FirebaseAuth.instance.currentUser!.uid,
//
//           );
          backTo(context: context, widget: NotesAppLayout());
          emit(EditNoteSuccessState());



        }).catchError((onError) {

          print(onError.toString());
          emit(EditNoteErrorState());
        });


    } else {
      {






        await FirebaseFirestore.instance
            .collection('Notes').doc(docId).update
          ({'Note': note, 'Title': title , 'uID':            await FirebaseAuth.instance.currentUser!.uid,
        }).then((value) async {

//add data to model
////////////////////////////////
//           EditNoteModel model = EditNoteModel(
//             note: note,
//             title: title,
//             image: imageUrl,
//             uID:await FirebaseAuth.instance.currentUser!.uid,
//
//           );
          backTo(context: context, widget: NotesAppLayout());
          emit(EditNoteSuccessState());



        }).catchError((onError) {

          print(onError.toString());
          emit(EditNoteErrorState());
        });


      }
    }
  }

//add note
  editNoteFun({required String note, required String title ,required String docId ,required context}) async {        emit(EditNoteLoadingState());

  await FirebaseFirestore.instance
        .collection('Notes').doc(docId).update
       ({'Note': note, 'Title': title ,'uID':             FirebaseAuth.instance.currentUser!.uid,}).then((value) async {

    //add data to model
////////////////////////////////
//     EditNoteModel model = EditNoteModel(
//           note: note,
//           title: title,
//         uID: FirebaseAuth.instance.currentUser!.uid,
//
//       );
     backTo(context: context, widget: NotesAppLayout());
      emit(EditNoteSuccessState());

  }).catchError((onError) {

  print(onError.toString());
  emit(EditNoteErrorState());
  });
  }



}
