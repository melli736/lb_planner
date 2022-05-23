part of lbplanner_api;

/// Provides the current user
final userProvider = StateNotifierProvider<UserProvider, User>((ref) => UserProvider());

/// Controller for the user.
final userController = userProvider.notifier;

/// Provides the current user
class UserProvider extends StateNotifier<User> {
  /// Provides the current user
  UserProvider() : super(User.loading());

  DateTime? _lastRefresh;

  @override
  init() {
    if (UserDisk.data != null) setState(UserDisk.data!);
    _refresh();
  }

  /// Performs a login request with the given [username] and [password].
  /// If the user is successfully logged in, the [state] will be updated.
  /// If the user was not registered, the user will be automatically registered.
  Future<RawApiResponse> login(String username, String password, {required Languages language, required String theme}) async {
    log("Trying to login user", LogTypes.tracking);

    var lpa = await UserApi.login(username, password);

    if (lpa.failed) return lpa;

    var moodleMobileApp = await Api.requestToken(password, username, ApiServices.moodle_mobile_app);

    if (moodleMobileApp.failed) return moodleMobileApp;

    var token = lpa.value!;
    var moodleToken = moodleMobileApp.value!;

    var id = await UserApi.getUserId(moodleToken);

    if (id.failed) return id;

    var user = await UserApi.getUser(token, id.value!);

    if (user.succeeded) {
      assert(!user.value!.restricted);

      log("Logged in successfully", LogTypes.success);

      state = user.value!;
      UserDisk.saveUser(state);
      _lastRefresh = DateTime.now();
      return user;
    }

    log("Registering user...", LogTypes.tracking);

    var register = await UserApi.registerUser(token, id.value!, language.name, theme);

    if (register.succeeded) {
      state = register.value!;
      UserDisk.saveUser(state);
      _lastRefresh = DateTime.now();
    }

    log("Registered user successfully", LogTypes.success);

    return register;
  }

  /// Logs out the current user.
  Future<void> logout() async {
    log("Logging out user", LogTypes.tracking);
    state = User.loading();
    UserDisk.saveUser(state);
  }

  /// Updates the user's [User.theme] to [theme].
  Future<RawApiResponse> updateTheme(String theme) async {
    var response = await UserApi.updateUser(state.token, state.copyWith(theme: theme));

    if (response.succeeded) {
      state = response.value!;
      UserDisk.saveUser(state);
      _lastRefresh = DateTime.now();
    }

    return response;
  }

  /// Updates the user's [User.language] to [language].
  Future<RawApiResponse> updateLanguage(Languages language) async {
    var response = await UserApi.updateUser(state.token, state.copyWith(language: language));

    if (response.succeeded) {
      state = response.value!;
      UserDisk.saveUser(state);
      _lastRefresh = DateTime.now();
    }

    return response;
  }

  void _refresh() async {
    /*if (_lastRefresh != null) {
      var diff = DateTime.now().difference(_lastRefresh!);

      if (diff < kApiRefreshRate) {
        var delay = kApiRefreshRate - diff;

        await Future.delayed(delay);
      }
    }

    if (!state.loading && !state.restricted) {
      _lastRefresh = DateTime.now();

      var user = await UserApi.getUser(state.token, state.id);

      if (user.succeeded) {
        setState(user.value!);
        UserDisk.saveUser(state);
      }
    }

    await Future.delayed(kApiRefreshRate);

    _refresh();*/
  }
}
