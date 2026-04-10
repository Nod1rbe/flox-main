import 'package:auto_route/auto_route.dart';
import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/extensions/alignment_extensions.dart';
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
import 'package:flox/ui_components/components/tappable_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Stack(
        children: [
          AuthWelcomingWidget(
            title: 'Welcome back',
            subtitle: 'We are glad to see you',
          ),
          AuthBaseContainer(
            title: 'Sign in to your account',
            child: Column(
              children: [
                TextFieldAtom(
                  outerPadding: const EdgeInsets.symmetric(horizontal: 16),
                  validator: (email) {
                    return TextFieldValidators.validateEmail(email);
                  },
                  controller: _emailController,
                  headerText: 'Email',
                  hintText: 'Enter your email',
                  onChanged: (_) => _validateForm(),
                ),
                const SizedBox(height: 16),
                TextFieldAtom(
                  outerPadding: const EdgeInsets.symmetric(horizontal: 16),
                  validator: (email) {
                    return TextFieldValidators.validatePassword(email);
                  },
                  controller: _passwordController,
                  headerText: 'Password',
                  hintText: 'Enter your password',
                  obscureText: true,
                  onChanged: (_) => _validateForm(),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 6),
                  child: TappableComponent(
                    onTap: () {},
                    borderRadius: 8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ).centerRight,
                ),
                const SizedBox(height: 20),
                BlocConsumer<AuthenticationBloc, AuthenticationState>(
                  listenWhen: (o, n) => o.loginStatus != n.loginStatus,
                  listener: (context, state) {
                    if (state.loginStatus.isFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.loginErrorMessage)),
                      );
                    }
                    if (state.loginStatus.isSuccess) {
                      context.router.replaceAll([const MainNavigationRoute()]);
                    }
                  },
                  buildWhen: (o, n) => o.loginStatus != n.loginStatus,
                  builder: (context, state) {
                    return ButtonAtom(
                      loading: state.loginStatus.isLoading,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      text: 'Sign in',
                      onTap: () {
                        _isValidatingFirstTime = true;
                        if (!(_formKey.currentState?.validate() ?? false)) return;
                        context.read<AuthenticationBloc>().add(
                              LoginEvent(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              ),
                            );
                      },
                    );
                  },
                ),
                OrDivider(),
                GoogleAuthButton(title: 'Sign in with Google'),
                const SizedBox(height: 16),
                AuthTogglePrompt(
                  text: 'Don\'t have an account?',
                  buttonText: 'Sign up',
                  shouldSwitchToLogin: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
