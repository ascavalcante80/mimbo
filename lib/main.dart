import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mimbo/logic/bloc/user_loader_bloc.dart';
import 'package:mimbo/presentation/screens/create_user_screen.dart';
import 'package:mimbo/presentation/widget/widgets.dart';

import 'firebase_options.dart';
import 'logic/bloc/project_operations_bloc.dart';
import 'logic/cubits/page_controller_cubit.dart';
import 'logic/cubits/project_cubit.dart';
import 'logic/cubits/user_cubit.dart';
import 'presentation/screens/create_project_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // firebase_auth.FirebaseAuth.instance.signOut();
  if (kDebugMode) {
    try {
      log('using Firebase emulator');
      // TODO -> ATTENTION: remember to uncomment it in case of caller does not have permission to access the database OR Check if app check is activated
      // await FirebaseFirestore.instance.terminate();
      // await FirebaseFirestore.instance.clearPersistence();
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      firebase_auth.FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
      FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
    } catch (e) {
      log(e.toString());
    }
  } else {
    // await FirebaseAppCheck.instance.activate(
    //   appleProvider: AppleProvider.appAttest,
    // );
    log('using Firebase production');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MimUserCubit(),
        ),
        BlocProvider(
          create: (context) => ProjectCubit(),
        ),
        BlocProvider(
          create: (context) => UserLoaderBloc(),
        ),
        BlocProvider(
          create: (context) => PageControllerCubit(),
        ),
        BlocProvider(
          create: (context) => ProjectOperationsBloc(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
        ],
        initialRoute: AuthGate.routeName,
        routes: {
          AuthGate.routeName: (context) => const AuthGate(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          CreateMimUserScreen.routeName: (context) =>
              const CreateMimUserScreen(),
          CreateProjectScreen.routeName: (context) =>
              const CreateProjectScreen(),
        },

        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
