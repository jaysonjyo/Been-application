import 'package:bee_chem/personal%20list.dart';
import 'package:bee_chem/toast.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/storage.dart';
import 'core/validators.dart';
import 'features/auth/auth_provider.dart';

class BeeChemLoginPage extends StatefulWidget {
  const BeeChemLoginPage({super.key});

  @override
  State<BeeChemLoginPage> createState() => _BeeChemLoginPageState();
}

class _BeeChemLoginPageState extends State<BeeChemLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;
  bool obscurePassword = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => isLoading = false);
    });
    Future.delayed(const Duration(seconds: 2), () async {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('saved_email');
      if (savedEmail != null) {
        emailController.text = savedEmail;
        rememberMe = true;
      }
      setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 📱 Responsive measures
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final textScale = width / 400; // base scaling on 400px width

    return Scaffold(
      backgroundColor: Colors.white,
      body: Skeletonizer(
        enabled: isLoading,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/Frame 18338.png',
                    width: double.infinity,
                    height: height * 0.35,
                    fit: BoxFit.cover,
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: height * 0.15),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/Vector.png',
                            fit: BoxFit.cover,
                            height: height * 0.06,
                          ),
                          SizedBox(height: height * 0.015),
                          Text(
                            "BEE CHEM",
                            style: GoogleFonts.poppins(
                              fontSize: 37 * textScale,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome Back!",
                      style: GoogleFonts.poppins(
                        fontSize: 30 * textScale,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: height * 0.005),
                    Text(
                      "Login to your account",
                      style: GoogleFonts.poppins(
                        fontSize: 15 * textScale,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    _buildTextField(
                      controller: emailController,
                      label: "Email address",
                      icon: Icons.email_outlined,
                      textScale: textScale,
                      height: height,
                      width: width,
                    ),
                    SizedBox(height: height * 0.025),
                    _buildTextField(
                      controller: passwordController,
                      label: "Password",
                      icon: Icons.lock_outline,
                      obscureText: obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? BootstrapIcons.eye_slash_fill
                              : BootstrapIcons.eye_slash,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() => obscurePassword = !obscurePassword);
                        },
                      ),
                      textScale: textScale,
                      height: height,
                      width: width,
                    ),
                    SizedBox(height: height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!isLoading)
                          Row(
                            children: [
                              Checkbox(
                                activeColor: const Color(0xFFFFC107),
                                value: rememberMe,
                                onChanged: (val) => setState(
                                        () => rememberMe = val ?? false),
                              ),
                              Text(
                                "Remember me",
                                style: GoogleFonts.poppins(
                                  fontSize: 13 * textScale,
                                ),
                              ),
                            ],
                          )
                        else
                          const SizedBox(height: 24),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "FORGOT PASSWORD?",
                            style: GoogleFonts.poppins(
                              fontSize: 13 * textScale,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFFFC107),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    SizedBox(
                      width: double.infinity,
                      height: height * 0.06,
                      child: ElevatedButton(
                        // onPressed: () async {
                        //   final auth = context.read<AuthProvider>();
                        //
                        //   // Basic validation
                        //   if (V.email(emailController.text) != null ||
                        //       V.password(passwordController.text) != null) {
                        //     showToast("Enter valid credentials");
                        //     return;
                        //   }
                        //
                        //   setState(() => isLoading = true);
                        //
                        //   try {
                        //     final success = await auth.login(
                        //       emailController.text.trim(),
                        //       passwordController.text,
                        //     );
                        //
                        //     setState(() => isLoading = false);
                        //
                        //     if (!mounted) return;
                        //     if (success) {
                        //       final token = auth.accessToken;
                        //      // print("User Token: $token");
                        //       final storage = SecureStorage();
                        //       await storage.saveToken(token!);
                        //       showToast("Login Successful", success: true);
                        //       Navigator.of(context).pushReplacement(
                        //         MaterialPageRoute(
                        //           builder: (_) => PersonnelDetailsListScreen(token: token!),
                        //         ),
                        //       );
                        //     } else {
                        //       showToast("Incorrect email or password");
                        //     }
                        //   } catch (e) {
                        //     setState(() => isLoading = false);
                        //     showToast("Network error. Please try again.");
                        //   }
                        // },
                        onPressed: () async {
                          final auth = context.read<AuthProvider>();

                          final emailError = V.email(emailController.text);
                          final passwordError = V.password(passwordController.text);
                          if (emailError != null || passwordError != null) {
                            showToast(emailError ?? passwordError ?? "Invalid credentials");
                            return;
                          }

                          setState(() => isLoading = true);
                          try {
                            final success = await auth.login(
                              emailController.text.trim(),
                              passwordController.text,
                            );

                            setState(() => isLoading = false);

                            if (!mounted) return;

                            if (success) {
                              final token = auth.accessToken!;
                              final storage = SecureStorage();
                              await storage.saveToken(token);

                              // ✅ Save email if Remember Me is checked
                              if (rememberMe) {
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setString('saved_email', emailController.text.trim());
                              }

                              showToast("Login Successful", success: true);

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => PersonnelDetailsListScreen(token: token)),
                              );
                            } else {
                              showToast("Incorrect email or password");
                            }
                          } catch (e) {
                            setState(() => isLoading = false);
                            showToast("Network error. Please try again.");
                          }
                        },


                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC107),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "LOGIN",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16 * textScale,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade400)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.02,
                          ),
                          child: Text(
                            "OR",
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: 13 * textScale,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade400)),
                      ],
                    ),
                    SizedBox(height: height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don’t have an account? ",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14 * textScale,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            "REGISTER",
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFFFC107),
                              fontWeight: FontWeight.w600,
                              fontSize: 14 * textScale,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.05),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required double textScale,
    required double width,
    required double height,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: height * 0.007),
          child: Container(
            height: height * 0.065,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: TextFormField(
                cursorColor: Colors.black,
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
                style: TextStyle(fontSize: 15 * textScale, color: Colors.black),
                decoration: InputDecoration(
                  hintText: label,
                  hintStyle:
                  TextStyle(color: Colors.grey, fontSize: 14 * textScale),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                   // vertical: height * 0.028,
                    horizontal: width * 0.18,
                  ),
                  suffixIcon: suffixIcon,
                ),
              ),
            ),
          ),
        ),
        Container(
          height: height * 0.078,
          width: height * 0.075,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(height * 0.012),
            child: Icon(icon, color: Colors.grey[700], size: 22 * textScale),
          ),
        ),
      ],
    );
  }

}

