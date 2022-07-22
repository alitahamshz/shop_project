import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_project/data/repo/auth_repository.dart';
import 'package:shop_project/data/repo/cart_repository.dart';
import 'package:shop_project/ui/auth/bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _userNameController =
      TextEditingController(text: 'test@gmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: '123456');
  // bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    const onBackground = Colors.white;
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Theme(
          data: themeData.copyWith(
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size.fromHeight(56)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                      backgroundColor: MaterialStateProperty.all(onBackground),
                      foregroundColor: MaterialStateProperty.all(
                          themeData.colorScheme.secondary))),
              colorScheme: themeData.colorScheme.copyWith(
                onSurface: onBackground,
              ),
              inputDecorationTheme: InputDecorationTheme(
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1)))),
          child: Scaffold(
            backgroundColor: themeData.colorScheme.secondary,
            body: BlocProvider<AuthBloc>(
              create: (context) {
                final bloc = AuthBloc(authRepository,cartRepository);
                bloc.stream.forEach((state) {
                  if(state is AuthSuccess){
                    Navigator.of(context).pop();
                  }else if(state is AuthError){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("خطا")));
                  }
                });
                bloc.add(AuthStarted());
                return bloc;
              },
              child: BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (previous, current) {
                  return current is AuthError ||
                      current is AuthInitial ||
                      current is AuthLoading;
                },
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 38, right: 38),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/img/nike_logo.png',
                          color: Colors.white,
                          width: 120,
                        ),
                        Text(
                          state.isLoginMode ? 'خوش آمدید' : 'ثبت نام',
                          style:
                              const TextStyle(color: onBackground, fontSize: 22),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                            state.isLoginMode
                                ? 'لطفا وارد حساب کاربری خود شوید'
                                : 'نام کاربری و رمز عبور خود را تعیین کنید',
                            style: const TextStyle(
                                color: onBackground, fontSize: 16)),
                        const SizedBox(
                          height: 16,
                        ),
                        TextField(
                          controller: _userNameController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(label: Text('نام کاربری')),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        _PasswordTextField(
                            onBackground: onBackground,
                            inputController: _passwordController),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // authRepository.login(_userNameController.text,
                            //     _passwordController.text);
                                BlocProvider.of<AuthBloc>(context).add(AuthButtonIsClicked(_userNameController.text,  _passwordController.text));
                          },
                          child: state is AuthLoading
                                  ? const CircularProgressIndicator(): Text(state.isLoginMode ? 'ورود' : 'ثبت نام'),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.isLoginMode
                                  ? 'حساب کاربری ندارید؟'
                                  : 'قبلا ثبت نام کرده اید؟',
                              style: TextStyle(color: onBackground),
                            ),
                            TextButton(
                              child:
                                   Text(state.isLoginMode ? 'ثبت نام' : 'ورود'),
                              onPressed: () {
                                BlocProvider.of<AuthBloc>(context)
                                    .add(AuthModeIsClicked());
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  final Color onBackground;
  final TextEditingController inputController;
  const _PasswordTextField(
      {Key? key, required this.onBackground, required this.inputController})
      : super(key: key);

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.inputController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obscureText,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
            icon: Icon(
              obscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: widget.onBackground.withOpacity(0.6),
            ),
          ),
          label: Text('رمز عبور')),
    );
  }
}
