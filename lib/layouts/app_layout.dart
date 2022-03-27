import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:notesapp/modueles/add_note/add_notes.dart';
import 'package:notesapp/modueles/edit_note/edit_notes.dart';
import 'package:notesapp/modueles/view_notes/view_notes.dart';
import 'package:notesapp/shared/componants/componants.dart';
import 'package:notesapp/shared/cubits/add_note_cubit/add_cubit.dart';
import 'package:notesapp/shared/cubits/app_cubit/app_cubits.dart';
import 'package:notesapp/shared/cubits/app_cubit/app_states.dart';
import 'package:notesapp/shared/network/local/cach_helper.dart';
import 'package:notesapp/shared/styles/colors/colors.dart';
import 'package:notesapp/shared/styles/styles/icon_broken.dart';

class NotesAppLayout extends StatelessWidget {
  const NotesAppLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesAppCubit, NotesAppStates>(
      listener: (context, state) {


      },
      builder: (context, state) {
        CollectionReference notesRef =
            FirebaseFirestore.instance.collection('Notes');
        NotesAppCubit cubit = NotesAppCubit.get(context);
        return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    icon: Icon(Icons.brightness_2),
                    onPressed: () {
                      cubit.darkChange();
                      print(cubit.isDark);
                    })
              ],
              leading: IconButton(
                  onPressed: () async {
                    await cubit.logOut(context: context);
                  },
                  icon: Icon(Icons.exit_to_app_outlined)),
              title: Text('Notes App'),
              titleSpacing: 2,
            ),
            body:state is LogOutLoadingState ?
    const Center(
    child: SizedBox(height: 30, child: CircularProgressIndicator()),
    ):Center(
              child: Conditional.single(
                  context: (context),
                  conditionBuilder: (context) => state is LogOutLoadingState,
                  widgetBuilder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                  fallbackBuilder: (context) => StreamBuilder(
                      //check is  the uid is belong to current user
                      stream: notesRef
                          .where('uID',
                              isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          //page builder
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.separated(
                                  separatorBuilder: (context, i) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          color: Colors.grey,
                                          width: 2,
                                          height: 2,
                                        ),
                                      ),
                                  itemBuilder: (context, i) => InkWell(
                                        onTap: () {
                                          navigateTo(
                                              context: context,
                                              widget: ViewNotesScreen(
                                                title: snapshot.data.docs[i]
                                                    .data()['Title'],
                                              note: snapshot.data.docs[i].data()['Note'],
                                                 image: snapshot.data.docs[i]
                                                      .data()['Image']
                                              ));
                                        },
                                        child: Dismissible(
                                          confirmDismiss: (DismissDirection
                                              direction) async {
                                            await cubit.dismissConfirm(
                                                context: context,
                                                doc:
                                                    '${snapshot.data.docs[i].id}');
                                            if (snapshot.data.docs[i]
                                                    .data()['Image'] !=
                                                null) {
                                              await cubit.dismissConfirm(
                                                  context: context,
                                                  doc:
                                                      '${snapshot.data.docs[i].id}');
                                              await FirebaseStorage.instance
                                                  .refFromURL(snapshot
                                                      .data.docs[i]['Image'])
                                                  .delete();
                                            }
                                          },
                                          key: UniqueKey(),
                                          child:  snapshot.data.docs[i]
                                              .data()[
                                          'Image'] !=
                                              null ? Row(
                                            children: [
                                              Container(
                                                width: 110,
                                                height: 110,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: snapshot.data.docs[i]
                                                                  .data()[
                                                              'Image'] ==
                                                          null
                                                      ? const SizedBox()
                                                      : Image.network(
                                                          "${snapshot.data.docs[i].data()['Image']}",
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                              ),
                                              Expanded(
                                                child: ListTile(
                                                    title: Text(
                                                      '${snapshot.data.docs[i].data()['Title']}',
                                                      style: TextStyle(
                                                          fontSize: 26,
                                                          color: defaultColor),
                                                    ),
                                                    subtitle: Text(
                                                      '${snapshot.data.docs[i].data()['Note']}',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.grey), overflow: TextOverflow.ellipsis,
                                                    )),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  navigateTo(
                                                      context: context,
                                                      widget: EditNotesScreen(
                                                          initialValueOfTitle:
                                                              snapshot.data
                                                                      .docs[i]
                                                                      .data()[
                                                                  'Title'],
                                                          initialValueOfNote:
                                                              snapshot.data
                                                                      .docs[i]
                                                                      .data()[
                                                                  'Note'],

                                                          //pass doc id of the note you want to edit
                                                          docid: snapshot.data
                                                              .docs[i].id));
                                                },
                                                icon: const Icon(
                                                  Icons.edit,
                                                ),
                                                color: defaultColor,
                                              )
                                            ],
                                          ):Row(
                                            children: [

                                              Expanded(
                                                child: ListTile(
                                                    title: Text(
                                                      '${snapshot.data.docs[i].data()['Title']}',
                                                      style: TextStyle(
                                                          fontSize: 26,
                                                          color: defaultColor),
                                                    ),
                                                    subtitle: Text(
                                                      '${snapshot.data.docs[i].data()['Note']}',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.grey), overflow: TextOverflow.ellipsis,
                                                    )),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  navigateTo(
                                                      context: context,
                                                      widget: EditNotesScreen(
                                                          initialValueOfTitle:
                                                          snapshot.data
                                                              .docs[i]
                                                              .data()[
                                                          'Title'],
                                                          initialValueOfNote:
                                                          snapshot.data
                                                              .docs[i]
                                                              .data()[
                                                          'Note'],

                                                          //pass doc id of the note you want to edit
                                                          docid: snapshot.data
                                                              .docs[i].id));
                                                },
                                                icon: const Icon(
                                                  Icons.edit,
                                                ),
                                                color: defaultColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                  itemCount: snapshot.data.docs.length));
                        } else if (snapshot.hasError) {
                          return Icon(Icons.error_outline);
                        } else {
                          return CircularProgressIndicator();
                        }
                      })),
            ),
            //floating action
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                cubit.addNote(context);
              },
              child: cubit.isDark
                  ? Center(child: Icon(Icons.add))
                  : Center(
                      child: Icon(
                      Icons.add,
                      color: HexColor('333739'),
                    )),
            ));
      },
    );
  }
}
