enum Routes {
  home,
  login,
  qrScanner,
  task,
}

extension RouteExtension on Routes {
  String get toPath {
    switch (this) {
      case Routes.home:
        return "/";
      case Routes.login:
        return "/login";
      case Routes.qrScanner:
        return "/qr-scanner";
      case Routes.task:
        return "/task";
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
      case Routes.qrScanner:
        return "qr-scanner";
      case Routes.task:
        return "task";
      default:
        return "home";
    }
  }
}
