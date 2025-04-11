import 'dart:async';
import 'dart:core';
import 'package:novi/home_page.dart';
import 'package:novi/pallete.dart';
import 'package:flutter/material.dart';
import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:novi/screens/clerk_sign_in_example.dart';

Future<void> main() async {
    await clerk.setUpLogging(printer: const LogPrinter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ClerkAuth(
        config: const ClerkAuthConfig(
            publishableKey:
                'pk_test_b2JsaWdpbmctbGlvbi01MS5jbGVyay5hY2NvdW50cy5kZXYk'),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'novi',
          theme: ThemeData.light(useMaterial3: true).copyWith(
            scaffoldBackgroundColor: Pallete.whiteColor,
            appBarTheme: const AppBarTheme(
              backgroundColor: Pallete.whiteColor,
            ),
          ),
          home: const ClerkSignInExample(),
          routes: {
            ClerkSignInExample.path: (context) => const ClerkSignInExample(),},
        ));
  }
}

/// Log Printer
class LogPrinter extends clerk.Printer {
  /// Constructs an instance of [LogPrinter]
  const LogPrinter();

  @override
  void print(String output) {
    Zone.root.print(output);
  }
}
