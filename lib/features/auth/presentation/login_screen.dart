import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_assessment_app/features/auth/presentation/widgets/custom_text_field.dart';
import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/app_images.dart';
import 'package:flutter_assessment_app/core/config/custom_screen_util.dart';
import 'providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool isEmailTab = true;
  bool isLogin = false;

  @override
  Widget build(BuildContext context) {
    CustomScreenUtil.init(context);
    final formState = ref.watch(signupProvider);
    final notifier = ref.read(signupProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
          size: 20,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              isLogin ? "Welcome Back!" : "Welcome!",
              style: const TextStyle(
                fontFamily: AppFonts.sfPro,
                fontWeight: FontWeight.w700,
                fontSize: 34,
                color: Color(0xFF2B2B2C),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                isLogin
                    ? "Please enter your credentials to login"
                    : "Please complete the required information, and then press the Next button",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppFonts.sfPro,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 1.8,
                  letterSpacing: 0.9,
                  color: Color(0xFF61636F),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTab("Email Address", isActive: isEmailTab, onTap: () => setState(() => isEmailTab = true)),
                const SizedBox(width: 30),
                _buildTab("Phone Number", isActive: !isEmailTab, onTap: () => setState(() => isEmailTab = false)),
              ],
            ),
            const SizedBox(height: 35),
            CustomTextField(
              label: "E-mail",
              hint: "email@example.com",
              iconPath: AppImages.icMailGrey,
              activeIconPath: AppImages.icMailBlue,
              isActive: formState.isEmailValid,
              onChanged: notifier.updateEmail,
            ),
            if (!isLogin) ...[
              const SizedBox(height: 18),
              CustomTextField(
                label: "Username",
                hint: "JohnApple",
                iconPath: AppImages.icUserGrey,
                activeIconPath: AppImages.icUserBlue,
                isActive: formState.isUsernameValid,
                onChanged: notifier.updateUsername,
              ),
              const SizedBox(height: 18),
              CustomTextField(
                label: "Birthday",
                hint: "14/08/2020",
                iconPath: AppImages.icCalGrey,
                activeIconPath: AppImages.icCalBlue,
                isActive: formState.isBirthdayValid,
                onChanged: notifier.updateBirthday,
                keyboardType: TextInputType.datetime,
              ),
            ],
            const SizedBox(height: 18),
            CustomTextField(
              label: "Password",
              hint: "••••••••••••",
              iconPath: AppImages.icLockGrey,
              activeIconPath: AppImages.icLockBlue,
              isPassword: true,
              isActive: formState.isPasswordValid,
              onChanged: notifier.updatePassword,
            ),
            const SizedBox(height: 15),
            const Text(
              "Password must include a number, a letter, and a special character.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.sfPro,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF61636F),
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 50),
            _buildSubmitButton(formState, notifier),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () => setState(() => isLogin = !isLogin),
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    isLogin ? "Don't have an account? " : "Already have an account? ",
                    style: const TextStyle(
                      fontFamily: AppFonts.sfPro,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF61636F),
                    ),
                  ),
                  Text(
                    isLogin ? "Signup" : "Signin",
                    style: const TextStyle(
                      fontFamily: AppFonts.sfPro,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2B2B2C),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, {required bool isActive, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.sfPro,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: isActive ? const Color(0xFF2B2B2C) : const Color(0xFFC7C7C7),
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 3,
            width: 35,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF0079FF) : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSubmitButton(SignupFormState formState, SignupNotifier notifier) {
    bool isValid = isLogin 
        ? (formState.isEmailValid && formState.isPasswordValid)
        : formState.isFormValid;
    
    bool isLoading = formState.isLoading;

    const Color activeColor1 = Color(0xFF0079FF);
    const Color activeColor2 = Color(0xFF004DFF);
    final double textScale = MediaQuery.textScalerOf(context).scale(1.0);

    return GestureDetector(
      onTap: (isValid && !isLoading)
          ? () async {
              final success = isLogin ? await notifier.signIn() : await notifier.signUp();
              if (success && mounted) {
                context.push('/home');
              } else if (formState.errorMessage != null && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(formState.errorMessage!)),
                );
              }
            }
          : null,
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            constraints: BoxConstraints(minHeight: 62 * textScale),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(62),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isValid
                    ? [activeColor1, activeColor2]
                    : [const Color(0xFFE4E4E4), const Color(0xFF808080)],
              ),
              boxShadow: isValid
                  ? [
                      BoxShadow(
                        color: activeColor1.withValues(alpha: 0.3),
                        blurRadius: 18,
                        offset: const Offset(0, 18),
                        spreadRadius: -20,
                      )
                    ]
                  : [],
            ),
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    isLogin ? "Login" : "Next",
                    style: const TextStyle(
                      fontFamily: AppFonts.sfPro,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}