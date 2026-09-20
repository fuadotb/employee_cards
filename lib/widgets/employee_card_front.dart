import 'package:flutter/material.dart';

import '../models/employee.dart';

class EmployeeCardFront extends StatelessWidget {
  final Employee employee;

  const EmployeeCardFront({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 540,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE2E2E2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset(
  'assets/images/uqu_logo_fixed.png',
  width: 145,
  fit: BoxFit.contain,
),

          const SizedBox(height: 24),

          Container(
            width: 125,
            height: 125,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF2F2F2),
              border: Border.all(
                color: const Color(0xFF006870),
                width: 3,
              ),
            ),
            child: ClipOval(
              child: employee.avatarUrl.isNotEmpty
                  ? Image.network(
                      employee.avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return const Icon(
                          Icons.person,
                          size: 70,
                          color: Color(0xFF006870),
                        );
                      },
                    )
                  : const Icon(
                      Icons.person,
                      size: 70,
                      color: Color(0xFF006870),
                    ),
            ),
          ),

          const SizedBox(height: 22),

      Text(
  employee.id.toString(),
  style: const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
  ),
),

          const SizedBox(height: 12),

          const Text(
            'عمادة تقنية المعلومات والتعليم الإلكتروني',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF006870),
            ),
          ),

          const SizedBox(height: 12),

         Text(
  employee.nameAr,
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1F1F1F),
  ),
),
const SizedBox(height: 6),

Text(
  employee.nameEn,
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontSize: 13,
    color: Colors.grey,
  ),
),

          const SizedBox(height: 14),

         // const Text(
         //    'عقد تشغيلي شركة حرف',
         //    style: TextStyle(
         //      fontSize: 14,
         //      fontWeight: FontWeight.bold,
         //    ),
         // ),

          const SizedBox(height: 5),

          const Text(
            'صالحة لغاية 2028',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          Container(
            width: double.infinity,
            height: 10,
            decoration: BoxDecoration(
              color: const Color(0xFF006870),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}