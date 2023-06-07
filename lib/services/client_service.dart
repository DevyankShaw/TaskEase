import 'package:appwrite/appwrite.dart';

import '../utilities/utilities.dart';

class ClientService {
  static late Client _client;

  static Client get client => _client;

  static void init({String? userToken}) {
    if (userToken == null) {
      _client = Client()
        ..setEndpoint(Constants.endPoint) // Your API Endpoint
        ..setProject(Constants.projectId) // Your project ID
        ..setSelfSigned();
    } else {
      _client = Client()
        ..setEndpoint(Constants.endPoint) // Your API Endpoint
        ..setProject(Constants.projectId) // Your project ID
        ..setJWT(userToken)
        ..setSelfSigned();
    }
  }
}
