enum Routes {
  home,
  login,
}

extension RouteExtension on Routes {
  String get toPath {
    switch (this) {
      case Routes.home:
        return "/";
      case Routes.login:
        return "/login";
      default:
        return "/";
    }
  }

  String get toName {
    switch (this) {
      case Routes.home:
        return "home";
      case Routes.login:
        return "login";
      default:
        return "home";
    }
  }
}
