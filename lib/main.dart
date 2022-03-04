import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/layouts/app_layout.dart';
import 'package:notesapp/modueles/login_screen/login_screen.dart';
import 'package:notesapp/shared/cubits/app_cubit/app_cubits.dart';
import 'package:notesapp/shared/cubits/app_cubit/app_states.dart';
import 'package:notesapp/shared/network/local/cach_helper.dart';
import 'package:notesapp/shared/styles/styles/styles.dart';

import 'shared/cubits/bloc_observer/bloc_observer.dart';

//belong to fire base messaging in back & term
//
// Future<void> message(RemoteMessage message) async {
//
//  print('____________________');
//
//   print("${message.notification!.body}");
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();

  //FirebaseMessaging.onBackgroundMessage(message) ;
  bool? isDark = CacheHelper.getBoolData(key: 'isDark');

  BlocOverrides.runZoned(
    () {
      //to check the uid of user
      var uID = FirebaseAuth.instance.currentUser?.uid;
      Widget start;

      if (uID != null) {
        start = const NotesAppLayout();
        //  start =  Test();

      } else {
        start = LoginScreen();
      }

      runApp(MyApp(start, isDark));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final Widget start;
  final bool? isDark;

  const MyApp(this.start, this.isDark);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => NotesAppCubit()
              ..darkChange(fromShared: isDark)
              ..getToken())
      ],
      child: BlocConsumer<NotesAppCubit, NotesAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: NotesAppCubit.get(context).isDark
                ? ThemeMode.light
                : ThemeMode.dark,
            theme: lightMode,
            darkTheme: darkMode,
            home: start,
          );
        },
      ),
    );
  }
}
