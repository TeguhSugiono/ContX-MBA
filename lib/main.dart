// import 'package:flutter/material.dart';
// import 'pages/login_page.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ContX',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const LoginPage(),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'pages/login_page.dart';
// import 'pages/dashboard_page.dart';
// import 'utils/storage.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   Future<Widget> _getInitialPage() async {
//     final token = await Storage.getToken();
//
//     if (token != null) {
//       // langsung masuk dashboard (sementara tanpa fullname)
//       return const DashboardPage(fullname: "User");
//     }
//
//     return const LoginPage();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ContX',
//       debugShowCheckedModeBanner: false,
//       home: FutureBuilder(
//         future: _getInitialPage(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             );
//           }
//
//           return snapshot.data!;
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/dashboard_page.dart';
import 'utils/storage.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialPage() async {
    final token = await Storage.getToken();

    if (token != null) {
      final profile = await AuthService().getProfile(token);

      if (profile["status"] == "success") {
        // final username = profile["data"]["username"];
        //
        // return DashboardPage(fullname: username);
        final fullname = profile["data"]["fullname"];
        return DashboardPage(fullname: fullname);
      }

      // token invalid / expired
      await Storage.clearToken();
      return const LoginPage();
    }

    return const LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ContX',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _getInitialPage(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return snapshot.data!;
        },
      ),
    );
  }
}
