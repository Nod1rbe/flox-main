import 'package:auto_route/auto_route.dart';
import 'package:flox/core/routes/app_router.gr.dart';
import 'package:flox/core/utils/text_field_validators.dart';
import 'package:flox/feature/authentication/bloc/authentication_bloc.dart';
import 'package:flox/feature/authentication/ui/widgets/auth_base_container.dart';
import 'package:flox/feature/authentication/ui/widgets/auth_toggle_prompt.dart';
import 'package:flox/feature/authentication/ui/widgets/auth_welcoming_widget.dart';
import 'package:flox/feature/authentication/ui/widgets/google_auth_button.dart';
import 'package:flox/feature/authentication/ui/widgets/or_divider.dart';
import 'package:flox/ui_components/components/atoms/button_atom.dart';
import 'package:flox/ui_components/components/atoms/text_field_atom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isValidatingFirstTime = false;

  void _validateForm() {
    if (!_isValidatingFirstTime) return;
    setState(() {
      _formKey.currentState?.validate() ?? false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Stack(
        children: [
          AuthWelcomingWidget(
            title: 'Welcome!',
            subtitle: 'Create your account to get started\nand enjoy all the features we have to offer.',
          ),
          AuthBaseContainer(
            title: 'Create your account to get started.',
            height: 530,
            child: Column(
              children: [
                TextFieldAtom(
                  outerPadding: const EdgeInsets.symmetric(horizontal: 16),
                  controller: _emailController,
                  validator: (email) {
                    return TextFieldValidators.validateEmail(email);
                  },
                  headerText: 'Email',
                  hintText: 'Enter your email',
                  onChanged: (_) => _validateForm(),
                ),
                const SizedBox(height: 16),
                TextFieldAtom(
                  outerPadding: const EdgeInsets.symmetric(horizontal: 16),
                  controller: _passwordController,
                  validator: (password) {
                    return TextFieldValidators.validatePassword(password);
                  },
                  headerText: 'Password',
                  hintText: 'Enter your password',
                  obscureText: true,
                  onChanged: (_) => _validateForm(),
                ),
                const SizedBox(height: 16),
                TextFieldAtom(
                  outerPadding: const EdgeInsets.symmetric(horizontal: 16),
                  controller: _confirmPasswordController,
                  validator: (password) {
                    return TextFieldValidators.validatePassword(password);
                  },
                  headerText: 'Confirm password',
                  hintText: 'Confirm your password',
                  obscureText: true,
                  onChanged: (_) => _validateForm(),
                ),
                const SizedBox(height: 24),
                BlocConsumer<AuthenticationBloc, AuthenticationState>(
                  listenWhen: (o, n) => o.registerStatus != n.registerStatus,
                  listener: (context, state) {
                    if (state.registerStatus.isFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.registerErrorMessage)),
                      );
                    }
                    if (state.registerStatus.isSuccess) {
                      context.router.replaceAll([const MainNavigationRoute()]);
                    }
                  },
                  buildWhen: (o, n) => o.registerStatus != n.registerStatus,
                  builder: (context, state) {
                    return ButtonAtom(
                      loading: state.registerStatus.isLoading,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      text: 'Sign up',
                      onTap: () {
                        _isValidatingFirstTime = true;
                        if (!_formKey.currentState!.validate()) return;
                        if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Passwords do not match')),
                          );
                          return;
                        }
                        context.read<AuthenticationBloc>().add(
                              RegisterEvent(
                                email: _emailController.text,
                                password: _passwordController.text,
                              ),
                            );
                      },
                    );
                  },
                ),
                OrDivider(),
                GoogleAuthButton(title: 'Sign up with Google'),
                const SizedBox(height: 16),
                AuthTogglePrompt(
                  text: 'Already have an account?',
                  buttonText: 'Sign in',
                  shouldSwitchToLogin: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
