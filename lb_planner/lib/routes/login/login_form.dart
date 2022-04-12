part of lbplanner_routes;

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  /// The width of the login form.
  static const width = 350.0;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  RawApiResponse? _loginResponse;
  Future<RawApiResponse>? _loginFuture;

  _togglePassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  _login(UserProvider user) async {
    setState(() {
      _loginFuture = user.login(
        _userNameController.text.trimNewLineAndWhitespace(),
        _passwordController.text.trimNewLineAndWhitespace(),
        theme: NcThemes.current.name,
        language: EnumToString.fromString(Languages.values, t.localeName)!,
      );
    });

    _loginResponse = await _loginFuture!;

    if (mounted) {
      setState(() {
        _loginFuture = null;
      });
    }

    if (mounted && (_loginResponse?.succeeded ?? false)) {
      Navigator.of(context).pushNamed(DashboardRoute.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        var errorMessage = _loginResponse?.failed ?? false ? t.invalidUsernameOrPassword : null;

        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: LoginForm.width),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LpLogo(size: LoginRoute.logoSize),
                NcSpacing.xl(),
                LpTextField(
                  prefixIcon: FluentIcons.person_24_filled,
                  controller: _userNameController,
                  placeholder: t.username,
                  errorText: errorMessage,
                ),
                NcSpacing.large(),
                LpTextField(
                  prefixIcon: Icons.lock,
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  placeholder: t.password,
                  errorText: errorMessage,
                  suffix: IconButton(
                    icon: LpIcon(
                      _showPassword ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                    ),
                    splashRadius: 0.1,
                    onPressed: _togglePassword,
                  ),
                ),
                NcSpacing.xl(),
                SizedBox(
                  width: LoginForm.width,
                  child: ConditionalWrapper(
                    condition: _loginFuture != null,
                    wrapper: (context, _) => FutureBuilder(
                      future: _loginFuture!,
                      builder: (context, snapshot) => LpButton(
                        onPressed: () {},
                        child: SizedBox(
                          width: LoginForm.width,
                          child: Center(
                            child: SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: buttonTextColor,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    child: LpButton(
                      text: t.login,
                      onPressed: () => _login(ref.read(userProvider.notifier)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
