import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimizu_app/core/providers/auth_state_notifier.dart';
import 'package:shimizu_app/widgets/constants/theme.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Lu harus setuju sama Terms & Privacy Policy dulu, brok!',
              style: GoogleFonts.roboto(color: AppColors.whitePrimary),
            ),
            backgroundColor: AppColors.redPrimary,
          ),
        );
        return;
      }

      final success = await ref.read(authControllerProvider.notifier).register(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            _nameController.text.trim(),
          );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registrasi berhasil! Silakan login, brok.', style: GoogleFonts.roboto()),
              backgroundColor: AppColors.greenPrimary,
            ),
          );
          Navigator.of(context).pop();
        } else {
          final errorState = ref.read(authControllerProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorState.error?.toString() ?? 'Registrasi gagal, periksa kembali data lu!',
                style: GoogleFonts.roboto(color: AppColors.whitePrimary),
              ),
              backgroundColor: AppColors.redPrimary,
            ),
          );
        }
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
                  // Logo Aplikasi dari asset lu
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/application_logo.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Create Account',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.whitePrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Fill in the details to get started',
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: AppColors.whiteQuaternary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Input Full Name
                  Text(
                    'Full Name',
                    style: GoogleFonts.roboto(
                      color: AppColors.whiteSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
                    style: GoogleFonts.roboto(color: AppColors.whitePrimary),
                    decoration: _buildInputDecoration('Enter your full name', Icons.person_outline),
                    validator: (val) => val == null || val.isEmpty ? 'Nama kagak boleh kosong, brok!' : null,
                  ),
                  const SizedBox(height: 16),

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
                      'Create a password',
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
                  const SizedBox(height: 16),

                  // Input Confirm Password
                  Text(
                    'Confirm Password',
                    style: GoogleFonts.roboto(
                      color: AppColors.whiteSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    style: GoogleFonts.roboto(color: AppColors.whitePrimary),
                    decoration: _buildInputDecoration(
                      'Confirm your password',
                      Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.whiteTertiary,
                        ),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Konfirmasi password wajib diisi';
                      if (val != _passwordController.text) return 'Password kagak cocok, brok!';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Checkbox Terms and Conditions
                  Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _agreeToTerms,
                          activeColor: AppColors.greenPrimary,
                          checkColor: AppColors.whitePrimary,
                          side: const BorderSide(color: AppColors.whiteQuaternary),
                          onChanged: (val) => setState(() => _agreeToTerms = val ?? false),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'I agree to the Terms of Service and Privacy Policy',
                          style: GoogleFonts.roboto(color: AppColors.whiteSecondary, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Tombol Sign Up
                  ElevatedButton(
                    onPressed: authState.isLoading ? null : _handleRegister,
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
                            'SIGN UP',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.whitePrimary,
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),

                  // Footer Back to Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: GoogleFonts.roboto(color: AppColors.whiteSecondary, fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text(
                          "Login",
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
      
      // Menggunakan OutlineInputBorder yang valid agar tidak error merah
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