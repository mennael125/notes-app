import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notesapp/layouts/app_layout.dart';
import 'package:notesapp/shared/componants/componants.dart';
import 'package:notesapp/shared/cubits/add_note_cubit/add_cubit.dart';
import 'package:notesapp/shared/cubits/add_note_cubit/add_states.dart';
import 'package:notesapp/shared/cubits/app_cubit/app_cubits.dart';
import 'package:notesapp/shared/cubits/edit_note_cubit/edit_cubit.dart';
import 'package:notesapp/shared/cubits/edit_note_cubit/edit_states.dart';
import 'package:notesapp/shared/styles/colors/colors.dart';
import 'package:notesapp/test.dart';
var titleController = TextEditingController();
var noteController = TextEditingController();
var title ;
var note ;
var formKey = GlobalKey<FormState>();
//to save image

var imageUrl;

class EditNotesScreen extends StatelessWidget {
  //pass doc id  from  layout
   EditNotesScreen({Key? key, this.docid, this.initialValueOfTitle, this.initialValueOfNote}) : super(key: key);
  final docid;
final initialValueOfTitle;

final initialValueOfNote;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => EditCubit(),
        child: BlocConsumer<EditCubit, EditStates>(
          listener: (context, state) {


          },
          builder: (context, state) {
            var cubit = EditCubit.get(context);
            return Scaffold(
              appBar: defaultAppBar(
                context: context,
                title: 'EditNotes',
              ),
              body:state is EditNoteLoadingState ?
    const Center(child: CircularProgressIndicator()): Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      //text form of title
                      defaultFormField(
                        initialValue: initialValueOfTitle,
                          onSaved: (val){
                            title=val;
                          },
                          // controller: titleController,
                          textKeyboard: TextInputType.text,
                          prefix: Icons.title,
                          validate: (val) {
                            if (val!.length > 30) {
                              return "Your title can'\t be more than 30 ";
                            }
                            if (val.length < 2) {
                              return "Your title can'\t be less than 2 ";
                            }
                          },
                          textLabel: 'Title'),
                      const SizedBox(
                        height: 2,
                      ),
                      //text form of note

                      defaultFormField(
                        initialValue: initialValueOfNote,
                          onSaved: (val){
                          note=val;
                          },
                          // controller: noteController,
                          textKeyboard: TextInputType.text,
                          prefix: Icons.note,
                          validate: (val) {
                            if (val!.length > 300) {
                              return "Your Note can'\t be more than 300 ";
                            }
                            if (val.length < 2) {
                              return "Your Note can'\t be less than 2 ";
                            }
                          },
                          textLabel: 'Note'),
                      const SizedBox(
                        height: 2,
                      ),
                      //choose image
                      MaterialButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                    color: NotesAppCubit.get(context).isDark
                                        ? Colors.white
                                        : HexColor('333739'),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: [
                                          const Text(
                                            ' choose image',
                                            style: TextStyle(fontSize: 25),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                       //image from gallery
                                       InkWell(
                                            onTap: () async {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                formKey.currentState!.save();
                                                await cubit.pickImageAndEdit(                                context: context,
                                                  docId: docid

                                                    ,source: ImageSource.gallery,
                                                    refName:
                                                        'Image from gallery ',
                                                    note: note,
                                                    title:
                                                       title,);

                                              } else {
                                                backTo(
                                                    context: context,
                                                    widget:
                                                         EditNotesScreen());
                                              }
                                            },
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Row(
                                                children: const [
                                                  Icon(Icons.photo),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Text('From Gallery'),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          //image from camera

                                          InkWell(
                                            onTap: () async {
                                              if (formKey.currentState!
                                                  .validate()) {
                                      formKey.currentState!.save();

                                         await   cubit.pickImageAndEdit(                               context: context,
                                             docId: docid,
                                                    source: ImageSource.camera,
                                                    refName:
                                                        'Image from camera ',
                                                    note: note,
                                                    title:
                                                        title);
                                                // noteController.text = '';
                                                // titleController.text = '';


                                              } else {
                                                backTo(
                                                    context: context,
                                                    widget:
                                                         EditNotesScreen());
                                              }
                                            },
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Row(
                                                children: const [
                                                  Icon(Icons.camera),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Text('From camera'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                        },
                        color: defaultColor,
                        child: Text(
                          'Edit image in the note',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      MaterialButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            await cubit.editNoteFun(
                              context: context,
                               docId: docid,
                              title:title,
                              note:note,
                            );
                            // noteController.text = '';
                            // titleController.text = '';

                          }
                        },
                        color: defaultColor,
                        child: Text(
                          'Edit note',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),


                     ],


                  ),
                ),
              ),
            );
          },
        ));
  }
}
