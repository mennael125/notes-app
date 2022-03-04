//test page

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/shared/componants/componants.dart';
import 'package:notesapp/shared/cubits/app_cubit/app_cubits.dart';
import 'package:notesapp/shared/cubits/app_cubit/app_states.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesAppCubit(),
      child: BlocConsumer<NotesAppCubit, NotesAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          NotesAppCubit cubit = NotesAppCubit.get(context);
          return Scaffold(
              appBar: AppBar(
                title: Text('Notes App'),
                titleSpacing: 2,
              ),
              body: Center(child: Column(
                children: [

                ],
              )));
        },
      ),
    );
  }
}



//##################################33    Test In Cubit




// //test fire store
//
// CollectionReference users =
// FirebaseFirestore.instance.collection('users test1');
// List user = [];
//
// getdata() async {
//   try {
//     emit(FirestoreStateLoadingTest());
//
//     QuerySnapshot getDocs = await users.get();
//
//     getDocs.docs.forEach(
//           (element) {
//         user.add(element.data());
//         print(user);
//         print("____________________________");
//         print(user.length);
//         emit(FirestoreStateTest());
//       },
//     );
//   } catch (e) {
//     print("____________________________");
//     throw (e.toString());
//   }
// }
//
// //###########################################  //###########################################  //###########################################  //###########################################  //###########################################  //###########################################
// // uploadImage() async {
// //  File?  file;
// //   var _picker = ImagePicker();
// //  var image = await _picker.pickImage(source: ImageSource.camera);
// // try {
// //   if (image != null) {
// //     file = File(image.path);
// //     var imagename = basename(image.path);
// //     print('===============================');
// //     print(file);
// //     emit(FirestoreStateTest());
// //     var ref = await FirebaseStorage.instance.ref('image/$imagename');
// //     await ref.putFile(file);
// //     var url = ref.getDownloadURL();
// //
// //     emit(FirestoreStateTest());
// //   } else {}
// // }catch(e){
// //   print(e.toString());
// //   print('===============================');
// //
// // }
// // }
//
// //###########################################  //###########################################  //###########################################  //###########################################  //###########################################  //###########################################  //###########################################
//
// // uploadPhotoByRandom()async{
// //   File ? file ;
// // var imgpick=ImagePicker();
// //    var image = await imgpick.pickImage(source: ImageSource.camera);
// //    int rand=Random().nextInt(2000000);
// // if(image!=null){
// //   file=File(image.path);
// //        var imagename = basename(image.path);
// //   imagename='$rand$imagename';
// // var ref=FirebaseStorage.instance.ref('byRand/$imagename');
// // await ref.putFile(file);
// // var url=ref.getDownloadURL();
// //      emit(FirestoreStateTest());
// //
// //
// //
// // }else{}
// //
// // }
// //   getFilesName() async{
// //    var ref= await FirebaseStorage.instance.ref().listAll();
// //    ref.prefixes.forEach((element) {
// //      print (element.fullPath);
// //           print('===============================');
// //
// //    });
// //    print('===============================');
// //    ref.items.forEach((element) {
// //      print (element.name);
// //      print('===============================');
// //
// //    });
// //
// //
// //
// //   }
