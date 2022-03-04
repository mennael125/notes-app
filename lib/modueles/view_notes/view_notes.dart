import 'package:flutter/material.dart';
import 'package:notesapp/shared/componants/componants.dart';
import 'package:notesapp/shared/styles/colors/colors.dart';

class ViewNotesScreen extends StatelessWidget {
  const ViewNotesScreen({Key? key, this.image, this.title, this.note}) : super(key: key);
  final image ;
  final title ;
  final note ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: defaultAppBar(context: context , title: 'View Notes') ,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
           pageBuilder (title: title ,note: note , image: image , context: context)



        ],),
      ),
    );
  }
}
pageBuilder( {required String title, required String note ,  String ?image , required context })=>

    image !=null ?
    Column(
 crossAxisAlignment: CrossAxisAlignment.start,

  children: [
    Text('Your image is : ' ,   style: Theme.of(context).textTheme.headline1!.copyWith(color: defaultColor),) ,
    const SizedBox( height: 2  ,) ,

  SizedBox(
      height: 200,
      width: double.infinity,
      child:

      Image.network(image , fit: BoxFit.cover, )),
  const SizedBox( height: 10 ,) ,
    Text('The title is : ' ,   style: Theme.of(context).textTheme.headline1!.copyWith(color: defaultColor),) ,
    const SizedBox( height: 2  ,) ,
    Text(title,   style: Theme.of(context).textTheme.bodyText2,) ,

    const SizedBox( height: 10 ,) ,


    Text('Your  note is : ' ,   style: Theme.of(context).textTheme.headline1!.copyWith(color: defaultColor),) ,
    const SizedBox( height: 2  ,) ,
    Text(note,   style: Theme.of(context).textTheme.bodyText2,) ,


],):  Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [



        Text('The title is : ' ,   style: Theme.of(context).textTheme.headline1!.copyWith(color: defaultColor),) ,
        const SizedBox( height: 2  ,) ,
        Text(title,   style: Theme.of(context).textTheme.bodyText2,) ,

        const SizedBox( height: 10 ,) ,


        Text('Your  note is : ' ,   style: Theme.of(context).textTheme.headline1!.copyWith(color: defaultColor),) ,
        const SizedBox( height: 2  ,) ,
        Text(note,   style: Theme.of(context).textTheme.bodyText2,) ,


      ],);