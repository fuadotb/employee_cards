import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/employee.dart';

class EmployeeApiService {
  static const String baseUrl =
      'https://uqu.edu.sa/Api/v1/Users/Info';

  static const String uquAuth =
      '8c15a44f19053149b8f21ce6f355a143';

  Future<Employee> getEmployee({
    required String employeeNumber,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/$employeeNumber',
    );

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'x-uqu-auth': uquAuth,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load employee: '
        '${response.statusCode}\n'
        '${response.body}',
      );
    }

    final Map<String, dynamic> body =
        jsonDecode(response.body);

    if (body['status'] != 'success') {
      throw Exception(
        'Employee API returned unsuccessful status\n'
        '${response.body}',
      );
    }

    final data = body['data'];

    if (data == null || data is! Map<String, dynamic>) {
      throw Exception(
        'Invalid employee data\n${response.body}',
      );
    }

    return Employee.fromJson(data);
  }
}