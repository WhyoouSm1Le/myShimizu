import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimizu_app/core/providers/auth_state_notifier.dart';
import 'package:shimizu_app/widgets/constants/theme.dart';
import 'register_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref.read(authControllerProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
      
      if (mounted && !success) {
        final errorState = ref.read(authControllerProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorState.error?.toString() ?? 'Login Gagal, brok! Periksa kembali akunmu.',
              style: GoogleFonts.roboto(color: AppColors.whitePrimary),
            ),
            backgroundColor: AppColors.redPrimary,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryDark, 
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  // Logo Aplikasi myShimizu
                  Center(
                    child: Container(
                      height: 140, 
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/application_logo.jpeg'), 
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Smart Monitoring and Control\nfor Your Pump System',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: AppColors.whiteSecondary,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Welcome Back!',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.whitePrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Sign in to continue',
                    style: GoogleFonts.roboto(
                      fontSize: 13, 
                      color: AppColors.whiteQuaternary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Input Email
                  Text(
                    'Email',
                    style: GoogleFonts.roboto(
                      color: AppColors.whiteSecondary, 
                      fontSize: 12, 
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _emailController,
                    style: GoogleFonts.roboto(color: AppColors.whitePrimary),
                    keyboardType: TextInputType.emailAddress,
                    decoration: _buildInputDecoration('Enter your email', Icons.email_outlined),
                    validator: (val) => val == null || !val.contains('@') ? 'Email kagak valid, brok!' : null,
                  ),
                  const SizedBox(height: 16),

                  // Input Password
                  Text(
                    'Password',
                    style: GoogleFonts.roboto(
                      color: AppColors.whiteSecondary, 
                      fontSize: 12, 
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: GoogleFonts.roboto(color: AppColors.whitePrimary),
                    decoration: _buildInputDecoration(
                      'Enter your password',
                      Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility, 
                          color: AppColors.whiteTertiary,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (val) => val == null || val.length < 6 ? 'Password minimal 6 karakter' : null,
                  ),
                  
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {}, 
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.roboto(color: AppColors.greenPrimary, fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Tombol Login
                  ElevatedButton(
                    onPressed: authState.isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenPrimary, 
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: authState.isLoading
                        ? const SizedBox(
                            height: 20, 
                            width: 20, 
                            child: CircularProgressIndicator(color: AppColors.whitePrimary, strokeWidth: 2),
                          )
                        : Text(
                            'LOGIN', 
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold, 
                              fontSize: 16, 
                              color: AppColors.whitePrimary,
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Footer Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ", 
                        style: GoogleFonts.roboto(color: AppColors.whiteSecondary, fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterPage())),
                        child: Text(
                          "Sign Up", 
                          style: GoogleFonts.roboto(
                            color: AppColors.greenPrimary, 
                            fontWeight: FontWeight.bold, 
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData prefix, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.roboto(color: AppColors.whiteTertiary, fontSize: 14),
      prefixIcon: Icon(prefix, color: AppColors.whiteQuaternary),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.secondaryDark, 
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      
      // DISINI PENYAKITNYA, BROK! WAJIB PAKAI OutlineInputBorder
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), 
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), 
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), 
        borderSide: const BorderSide(color: AppColors.greenPrimary, width: 1.5),
      ),
    );
  }
}