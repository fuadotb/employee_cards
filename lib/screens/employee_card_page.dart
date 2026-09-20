import 'package:flutter/material.dart';

import '../models/employee.dart';
import '../services/employee_api_service.dart';
import '../widgets/employee_card_front.dart';

class EmployeeCardPage extends StatefulWidget {
  const EmployeeCardPage({super.key});

  @override
  State<EmployeeCardPage> createState() => _EmployeeCardPageState();
}

class _EmployeeCardPageState extends State<EmployeeCardPage> {
  final EmployeeApiService _apiService = EmployeeApiService();

  final TextEditingController _employeeNumberController =
      TextEditingController();

  Employee? employee;

  bool isLoading = false;
  String? errorMessage;

  @override
  void dispose() {
    _employeeNumberController.dispose();
    super.dispose();
  }

  Future<void> searchEmployee() async {
    final employeeNumber =
        _employeeNumberController.text.trim();

    if (employeeNumber.isEmpty) {
      setState(() {
        errorMessage = 'الرجاء إدخال رقم الموظف';
      });
      return;
    }

    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
        employee = null;
      });

      final loadedEmployee =
          await _apiService.getEmployee(
        employeeNumber: employeeNumber,
      );

      if (!mounted) return;

      setState(() {
        employee = loadedEmployee;
        isLoading = false;
      });
    } catch (e) {
  if (!mounted) return;

  setState(() {
    errorMessage = e.toString();
    employee = null;
    isLoading = false;
  });
}
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: const Text('بطاقة الموظف'),
          centerTitle: true,
          backgroundColor: const Color(0xFF006870),
          foregroundColor: Colors.white,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildSearch(),

            const SizedBox(height: 25),

            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),

            if (errorMessage != null && !isLoading)
              _buildError(),

            if (employee != null && !isLoading)
              Center(
                child: EmployeeCardFront(
                  employee: employee!,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _employeeNumberController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => searchEmployee(),
            decoration: InputDecoration(
              labelText: 'رقم الموظف',
              hintText: 'أدخل رقم الموظف',
              prefixIcon: const Icon(
                Icons.badge_outlined,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        SizedBox(
          height: 56,
          child: FilledButton(
            onPressed: isLoading
                ? null
                : searchEmployee,
            style: FilledButton.styleFrom(
              backgroundColor:
                  const Color(0xFF006870),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16),
              ),
            ),
            child: const Icon(
              Icons.search,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              errorMessage!,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}