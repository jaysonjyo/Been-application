import 'package:flutter/material.dart';
import 'package:bee_chem/core/storage.dart';
import 'package:bee_chem/personal list.dart';

import 'login.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  bool _loading = true;
  String? _token;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final storage = SecureStorage();
    final savedToken = await storage.readToken();
    setState(() {
      _token = savedToken;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xffffcc00))),
      );
    }

    // ✅ Navigate based on token presence
    if (_token != null && _token!.isNotEmpty) {
      return PersonnelDetailsListScreen(token: _token!);
    } else {
      return const BeeChemLoginPage();
    }
  }
}
