import 'package:employee_cards/core/theme/app_colors.dart';
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
        backgroundColor: AppColors.background,

        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          title: const Text(
            'بطاقة الموظف',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        body: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            30,
          ),
          children: [
            _buildHeader(),

            const SizedBox(height: 18),

            _buildSearch(),

            const SizedBox(height: 24),

            if (isLoading)
              _buildLoading(),

            if (errorMessage != null && !isLoading)
              _buildError(),

            if (employee != null && !isLoading)
              Center(
                child: EmployeeCardFront(
                  employee: employee!,
                ),
              ),

            if (employee == null &&
                errorMessage == null &&
                !isLoading)
              _buildEmptyState(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 6),

        Text(
          'أدخل رقم الموظف لعرض بيانات البطاقة',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _employeeNumberController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => searchEmployee(),
              decoration: InputDecoration(
                labelText: 'رقم الموظف',
                hintText: 'مثال: 123456',
                prefixIcon: const Icon(
                  Icons.badge_outlined,
                  color: AppColors.primary,
                ),
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          SizedBox(
            height: 58,
            width: 58,
            child: FilledButton(
              onPressed: isLoading
                  ? null
                  : searchEmployee,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor:
                    AppColors.primary.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: EdgeInsets.zero,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.search_rounded,
                      size: 25,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.primary,
            ),
          ),

          SizedBox(height: 14),

          Text(
            'جاري البحث عن الموظف...',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.errorBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.errorBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              errorMessage!,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 45),
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.badge_outlined,
              size: 42,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'لا توجد بطاقة لعرضها',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'أدخل رقم الموظف أعلاه للبحث',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}