class Employee {
  final String id;
  final String name;
  final DateTime joinDate;
  final bool isActive;
  final String department;
  final int salary;

  Employee({
    required this.id,
    required this.name,
    required this.joinDate,
    required this.isActive,
    required this.department,
    required this.salary,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['_id'],
      name: json['name'],
      joinDate: DateTime.parse(json['joinDate']),
      isActive: json['isActive'],
      department: json['department'],
      salary: json['salary'],
    );
  }
}
