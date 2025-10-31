// import 'package:flutter/material.dart';
// import 'package:bee_chem/core/storage.dart';
// import 'package:bee_chem/personal list.dart';
//
// import 'login.dart';
//
// class RootScreen extends StatefulWidget {
//   const RootScreen({super.key});
//
//   @override
//   State<RootScreen> createState() => _RootScreenState();
// }
//
// class _RootScreenState extends State<RootScreen> {
//   bool _loading = true;
//   String? _token;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkToken();
//   }
//
//   Future<void> _checkToken() async {
//     final storage = SecureStorage();
//     final savedToken = await storage.readToken();
//     setState(() {
//       _token = savedToken;
//       _loading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator(color: Color(0xffffcc00))),
//       );
//     }
//
//     // ✅ Navigate based on token presence
//     if (_token != null && _token!.isNotEmpty) {
//       return PersonnelDetailsListScreen(token: _token!);
//     } else {
//       return const BeeChemLoginPage();
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:bee_chem/core/storage.dart';
import 'package:bee_chem/ui_screen/personal%20list.dart';
import 'login.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String? _token;

  @override
  void initState() {
    super.initState();

    // 🌀 Simple fade-and-scale animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward(); // Start animation

    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    final storage = SecureStorage();
    final savedToken = await storage.readToken();
    _token = savedToken;

    // Small delay so splash is visible
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // Navigate based on token
    if (_token != null && _token!.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PersonnelDetailsListScreen(token: _token!),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const BeeChemLoginPage(fromSplash: true),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final textScale = width / 400;
    return Scaffold(
      backgroundColor: const Color(0xffffcc00), // 🟡 Yellow background
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: FadeTransition(
            opacity: _animation,
            child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/Vector.png',
                  fit: BoxFit.cover,
                  height: height * 0.06,
                ),
                const Text(
                  'BeeChem',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
