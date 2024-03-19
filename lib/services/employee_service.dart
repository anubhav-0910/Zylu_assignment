import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee.dart';

class EmployeeService {
  List<Employee> employees = [];

  Future<List<Employee>> fetchEmployees({
    required String searchQuery,
    required int? tenureFilter,
    required int? isActiveFilter,
    required void Function() setState,
  }) async {
    setState();

    try {
      final response = searchQuery.isEmpty
          ? await http.get(
              Uri.parse('https://zylu-assignment.onrender.com/api/employees/'))
          : await http.get(Uri.parse(
              'https://zylu-assignment.onrender.com/api/employees/search?name=$searchQuery'));

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        final data = res['employees'];
        if (data is List) {
          employees = data.map((json) => Employee.fromJson(json)).toList();
        } else if (data is Map<String, dynamic>) {
          employees = [Employee.fromJson(data)];
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load employees');
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    setState();

    return employees;
  }

  Future<void> createEmployee({
    required BuildContext context,
    required void Function() setState,
    required VoidCallback onSuccess,
    required TextEditingController nameController,
    required TextEditingController departmentController,
    required TextEditingController salaryController,
    required TextEditingController dateController,
  }) async {
    setState();

    try {
      final response = await http.post(
          Uri.parse('https://zylu-assignment.onrender.com/api/employees/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(
            {
              'name': nameController.text,
              'department': departmentController.text,
              'salary': salaryController.text,
              'joinDate': dateController.text,
            },
          ));
      if (response.statusCode == 201) {
        onSuccess();
      } else {
        throw Exception('Failed to create employees');
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    setState();
  }

  Future<bool?> confirmDeleteDialog(BuildContext context, String employeeName) {
    return showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete $employeeName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'No',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Yes', style: TextStyle(color: Colors.red))),
          ],
        );
      },
    );
  }

  Future<void> updateEmployee({
    required Employee employee,
    required String name,
    required String department,
    required int salary,
    required BuildContext context,
    required VoidCallback onSuccess,
    required void Function() setState,
  }) async {
    try {
      final response = await http.put(
        Uri.parse(
            'https://zylu-assignment.onrender.com/api/employees/${employee.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'department': department,
          'salary': salary,
        }),
      );

      if (response.statusCode == 200) {
        onSuccess();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Employee updated successfully!')),
        );
        setState();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update employee.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while updating employee.')),
      );
      print(e);
    }
  }
}
