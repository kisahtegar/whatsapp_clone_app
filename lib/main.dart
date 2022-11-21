import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_clone_app/data/models/user_model.dart';
import 'package:whatsapp_clone_app/presentation/bloc/auth/auth_cubit.dart';
import 'package:whatsapp_clone_app/presentation/bloc/get_device_number/get_device_number_cubit.dart';
import 'package:whatsapp_clone_app/presentation/bloc/phone_auth/phone_auth_cubit.dart';
import 'package:whatsapp_clone_app/presentation/bloc/user/user_cubit.dart';
import 'package:whatsapp_clone_app/presentation/screens/home_screen.dart';
import 'package:whatsapp_clone_app/presentation/screens/welcome_screen.dart';
import 'package:whatsapp_clone_app/presentation/widgets/theme/style.dart';

import 'firebase_options.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("MyApp: first page");
    return MultiBlocProvider(
      providers: [
        // NOTE: Calling this cubit when app started
        BlocProvider(create: (context) => di.sl<AuthCubit>()..appStarted()),
        BlocProvider(create: (context) => di.sl<PhoneAuthCubit>()),
        BlocProvider(create: (context) => di.sl<GetDeviceNumberCubit>()),
        BlocProvider(create: (context) => di.sl<UserCubit>()..getAllUsers()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WhatsApp Clone App',
        theme: ThemeData(primaryColor: primaryColor),
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return BlocBuilder<UserCubit, UserState>(
                    builder: (context, userState) {
                      if (userState is UserLoaded) {
                        final currentUser = userState.users.firstWhere(
                          (user) => user.uid == authState.uid,
                          orElse: () => const UserModel(),
                        );
                        return HomeScreen(userInfo: currentUser);
                      }
                      return Container();
                    },
                  );
                }
                if (authState is UnAuthenticated) {
                  return const WelcomeScreen();
                }
                return Container();
              },
            );
          },
        },
        // home: const WelcomeScreen(),
      ),
    );
  }
}
