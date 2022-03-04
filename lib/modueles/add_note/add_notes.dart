import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notesapp/layouts/app_layout.dart';
import 'package:notesapp/shared/componants/componants.dart';
import 'package:notesapp/shared/cubits/add_note_cubit/add_cubit.dart';
import 'package:notesapp/shared/cubits/add_note_cubit/add_states.dart';
import 'package:notesapp/shared/cubits/app_cubit/app_cubits.dart';
import 'package:notesapp/shared/styles/colors/colors.dart';

var titleController = TextEditingController();
var noteController = TextEditingController();
var formKey = GlobalKey<FormState>();
//to save image

var imageUrl;

class AddNotesScreen extends StatelessWidget {
  const AddNotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AddCubit(),
        child: BlocConsumer<AddCubit, AddStates>(
          listener: (context, state) {
            if (state is AddNoteLoadingState) {
              const Center(child: CircularProgressIndicator());

            }

          },
          builder: (context, state) {
            var cubit = AddCubit.get(context);
            return Scaffold(
              appBar: defaultAppBar(
                context: context,
                title: 'AddNotes',
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [                      //text form of title


                      defaultFormField(
                          controller: titleController,
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
                          controller: noteController,
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
                                            'Please choose image',
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
                                                await cubit.pickImageAndAdd(
                                                context: context
                                                ,
                                                    source: ImageSource.gallery,
                                                    refName:
                                                        'Image from gallery ',
                                                    note: noteController.text,
                                                    title:
                                                        titleController.text);
                                                noteController.text = '';
                                                titleController.text = '';


                                              } else {
                                                backTo(
                                                    context: context,
                                                    widget:
                                                        const AddNotesScreen());
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
                                             await   cubit.pickImageAndAdd(

                                             context: context
                                             ,
                                                    source: ImageSource.camera,
                                                    refName:
                                                        'Image from camera ',
                                                    note: noteController.text,
                                                    title:
                                                        titleController.text);
                                                noteController.text = '';
                                                titleController.text = '';

                                              } else {
                                                backTo(
                                                    context: context,
                                                    widget:
                                                        const AddNotesScreen());
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
                        },                        // add image to note

                        color: defaultColor,
                        child: Text(
                          'Add image to the note',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      // add  note

                      MaterialButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                             await cubit.addNoteFun(
                               context: context,
                              title: titleController.text,
                              note: noteController.text,
                            );
                            noteController.text = '';
                            titleController.text = '';

                          }
                        },
                        color: defaultColor,
                        child: Text(
                          'Add note',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
