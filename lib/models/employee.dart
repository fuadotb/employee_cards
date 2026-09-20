class Employee {
  final int id;
  final String nameAr;
  final String nameEn;
  final String emailId;
  final String userType;

  Employee({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.emailId,
    required this.userType,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      nameAr: json['name_ar']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? '',
      emailId: json['email_id']?.toString() ?? '',
      userType: json['user_type']?.toString() ?? '',
    );
  }

  String get avatarUrl {
    final idString = id.toString();

    if (idString.length < 3 || emailId.isEmpty) {
      return '';
    }

    final firstThree = idString.substring(0, 3);

    return 'https://drive.uqu.edu.sa/up/avatar/$firstThree/$emailId.png';
  }
}