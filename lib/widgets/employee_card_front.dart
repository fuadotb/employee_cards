import 'package:employee_cards/widgets/Info_Item.dart';
import 'package:flutter/material.dart';
import '../models/employee.dart';

class EmployeeCardFront extends StatelessWidget {
  final Employee employee;

  const EmployeeCardFront({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF006870);
    const dark = Color(0xFF1E2930);
    const lightBackground = Color(0xFFF7F9F9);

    return Container(
      width: 340,
      height: 540,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5EAEA)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
              decoration: const BoxDecoration(color: lightBackground),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/uqu_logo_fixed.png',
                    width: 210,
                    height: 75,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 8),

                  Container(
                    width: 42,
                    height: 3,
                    decoration: BoxDecoration(
                      color: teal,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  children: [
                    const SizedBox(height: 18),

                    // Profile Image
                    Container(
                      width: 126,
                      height: 126,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: teal, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: teal.withValues(alpha: 0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: employee.avatarUrl.isNotEmpty
                            ? Image.network(
                                employee.avatarUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person_rounded,
                                    size: 68,
                                    color: teal,
                                  );
                                },
                              )
                            : const Icon(
                                Icons.person_rounded,
                                size: 68,
                                color: teal,
                              ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Employee ID
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF4F4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        employee.id.toString(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: teal,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Arabic Name
                    Text(
                      employee.nameAr,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: dark,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // English Name
                    Text(
                      employee.nameEn,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Department
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: lightBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE6EEEE)),
                      ),
                      child: const Text(
                        'عمادة تقنية المعلومات والتعليم الإلكتروني',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: teal,
                          height: 1.4,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Expiry
                    Row(
                      children: [
                        Expanded(
                          child: InfoItem(
                            icon: Icons.event_outlined,
                            title: 'الصلاحية',
                            value: '2028',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Accent
            Container(width: double.infinity, height: 8, color: teal),
          ],
        ),
      ),
    );
  }
}
