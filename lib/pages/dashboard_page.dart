import 'package:flutter/material.dart';
import '../utils/storage.dart';
import 'login_page.dart';
import 'cek_container_page.dart';
import 'container_masuk_page.dart';

class DashboardPage extends StatelessWidget {
  final String fullname;

  const DashboardPage({
    super.key,
    required this.fullname,
  });

  Future<void> logout(BuildContext context) async {
    await Storage.clearToken();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  Widget menuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade100,
            child: Text(
              "Halo, $fullname",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // GRID MENU
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                menuItem(
                  context: context,
                  icon: Icons.search,
                  title: "Cek Container",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CekContainerPage(),
                      ),
                    );
                  },
                ),
                menuItem(
                  context: context,
                  icon: Icons.download,
                  title: "Container Masuk",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ContainerMasukPage(),
                      ),
                    );
                  },
                ),
                menuItem(
                  context: context,
                  icon: Icons.swap_horiz,
                  title: "Shifting",
                  onTap: () {},
                ),
                menuItem(
                  context: context,
                  icon: Icons.inventory,
                  title: "Handling",
                  onTap: () {},
                ),
                menuItem(
                  context: context,
                  icon: Icons.local_shipping,
                  title: "Trucking In",
                  onTap: () {},
                ),
                menuItem(
                  context: context,
                  icon: Icons.qr_code_scanner,
                  title: "Scan QR",
                  onTap: () {},
                ),
                menuItem(
                  context: context,
                  icon: Icons.logout,
                  title: "Logout",
                  onTap: () => logout(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}






// import 'package:flutter/material.dart';
// import '../utils/storage.dart';
// import 'login_page.dart';
//
// class DashboardPage extends StatelessWidget {
//   final String fullname;
//
//   const DashboardPage({
//     super.key,
//     required this.fullname,
//   });
//
//   Future<void> logout(BuildContext context) async {
//     await Storage.clearToken();
//
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (_) => const LoginPage(),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Dashboard"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () => logout(context),
//           ),
//         ],
//       ),
//       body: Center(
//         child: Text(
//           "Selamat datang, $fullname",
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }