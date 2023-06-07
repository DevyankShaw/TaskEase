import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

import 'services.dart';

class FunctionService {
  late final Functions _functions;

  FunctionService() {
    _functions = Functions(ClientService.client);
  }

  Future<Execution> createExecution({required String functionId, String? data}) {
    try {
      return _functions.createExecution(functionId: functionId, data: data);
    } catch (e) {
      rethrow;
    }
  }
}
