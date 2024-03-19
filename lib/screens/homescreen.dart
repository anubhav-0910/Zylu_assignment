import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/employee.dart';
import '../services/employee_service.dart';
import 'package:intl/intl.dart';
import '../widgets/add_employee.dart';
import '../widgets/dismissible_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EmployeeService _employeeService = EmployeeService();
  List<Employee> employees = [];
  bool isLoading = true;
  String searchQuery = '';
  int? tenureFilter;
  int? isActiveFilter;

  final dateController = TextEditingController();
  final nameController = TextEditingController();
  final departmentController = TextEditingController();
  final salaryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    employees = await _employeeService.fetchEmployees(
      searchQuery: searchQuery,
      tenureFilter: tenureFilter,
      isActiveFilter: isActiveFilter,
      setState: () => setState(() {}),
    );
    setState(() => isLoading = false);
  }

  Future<void> createEmployee() async {
    await _employeeService.createEmployee(
      context: context,
      setState: () => setState(() {}),
      onSuccess: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('EMPLOYEE ADDED SUCCESSFULLY!')),
        );
        fetchEmployees();
      },
      nameController: nameController,
      departmentController: departmentController,
      salaryController: salaryController,
      dateController: dateController,
    );
  }

  Future<bool?> confirmDeleteDialog(BuildContext context, String employeeName) {
    return _employeeService.confirmDeleteDialog(context, employeeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff113051),
        leading: Image.asset('assets/images/Zylu_logo.png'),
        title: const Text(
          'Employee List',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 26),
        ),
        elevation: 0,
        actions: [
          IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              icon: const Icon(Icons.add, size: 30, color: Colors.white),
              onPressed: () {
                bottomSheet(context);
              }),
        ],
        toolbarHeight: 60,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
                fetchEmployees(); // Call fetchEmployees here
              },
              decoration: const InputDecoration(
                hintText: 'Search name of the Employee',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              cursorColor: const Color(0xff113051),
              cursorHeight: 20,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<int>(
                value: tenureFilter, // Initialize with 0 for "All"
                hint: const Text('Filter by tenure'),
                onChanged: (value) {
                  setState(() {
                    tenureFilter = value;
                  });
                },
                items: const [
                  DropdownMenuItem(
                      value: 0, child: Text('All')), // Change this line
                  DropdownMenuItem(value: 12, child: Text('1+ year')),
                  DropdownMenuItem(value: 36, child: Text('3+ years')),
                  DropdownMenuItem(value: 60, child: Text('5+ years')),
                ],
              ),
              DropdownButton<int>(
                value: isActiveFilter, // Initialize with false for "All"
                hint: const Text('Filter by status'),
                onChanged: (value) {
                  setState(() {
                    isActiveFilter =
                        value; // No need to change if "All" is selected
                  });
                },
                items: const [
                  DropdownMenuItem<int>(
                      value: 0, child: Text('All')), // Change this line
                  DropdownMenuItem<int>(value: 1, child: Text('Active')),
                  DropdownMenuItem<int>(
                      value: -1, child: Text('Inactive')), // Change this line
                ],
              ),
            ],
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: fetchEmployees,
                    child: ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        final employee = employees[index];
                        bool showEmployee = true;
                        // Search query
                        if (searchQuery.isNotEmpty) {
                          showEmployee = employee.name
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase());
                        }
                        // Calculate tenure
                        final now = DateTime.now();
                        final tenure =
                            now.difference(employee.joinDate).inDays ~/ 30;
                        // Filter by tenure
                        if (tenureFilter != null) {
                          if (tenureFilter == 0) {
                            showEmployee = showEmployee;
                          } else {
                            showEmployee =
                                showEmployee && tenure >= tenureFilter!;
                          }
                        }
                        // Filter by active status
                        if (isActiveFilter != null) {
                          if (isActiveFilter == 1) {
                            showEmployee = showEmployee && employee.isActive;
                          } else if (isActiveFilter == -1) {
                            showEmployee = showEmployee && !employee.isActive;
                          } else {
                            showEmployee = showEmployee;
                          }
                        }
                        if (!showEmployee) return const SizedBox.shrink();

                        return Dismissible(
                            key: UniqueKey(),
                            background: const dismissibleContainer(),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) async {
                              final confirmed = await confirmDeleteDialog(
                                  context, employee.name);
                              if (confirmed == true) {
                                try {
                                  final response = await http.delete(
                                    Uri.parse(
                                        'https://zylu-assignment.onrender.com/api/employees/${employee.id}'),
                                  );
                                  if (response.statusCode == 200) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Employee deleted successfully!')),
                                    );
                                    // Remove the deleted employee from the list
                                    setState(() {
                                      employees.removeWhere(
                                          (e) => e.id == employee.id);
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Failed to delete employee.')),
                                    );
                                  }
                                } catch (e) {
                                  print(e);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'An error occurred while deleting employee.')),
                                  );
                                }
                              } else {
                                setState(() {
                                  fetchEmployees();
                                });
                              }
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: ExpansionTile(
                                tilePadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                childrenPadding: const EdgeInsets.only(
                                    left: 16.0, bottom: 8.0),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                                backgroundColor: Colors.white,
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.mode_edit_outlined,
                                    size: 20,
                                    color: Color.fromARGB(223, 3, 90, 183),
                                  ),
                                  onPressed: () {
                                    // Perform the necessary operations to edit the employee
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Column(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    top: 10, bottom: 0),
                                                child: Text(
                                                  'EDIT EMPLOYEE DETAILS',
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff113051),
                                                  ),
                                                ),
                                              ),
                                              const Divider(
                                                color: Color(0xff113051),
                                                thickness: 1,
                                                indent: 50,
                                                endIndent: 50,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          nameController,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText: 'Name',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xff113051)),
                                                        ),
                                                      ),
                                                      cursorColor: const Color(
                                                          0xff113051),
                                                      cursorHeight: 20,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    TextField(
                                                      controller:
                                                          departmentController,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText: 'Department',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xff113051)),
                                                        ),
                                                      ),
                                                      cursorColor: const Color(
                                                          0xff113051),
                                                      cursorHeight: 20,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    TextField(
                                                      controller:
                                                          salaryController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText: 'Salary',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xff113051)),
                                                        ),
                                                      ),
                                                      cursorColor: const Color(
                                                          0xff113051),
                                                      cursorHeight: 20,
                                                    ),
                                                    const SizedBox(height: 10),
                                                  ],
                                                ),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xff113051),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 30,
                                                      vertical: 10),
                                                ),
                                                onPressed: () {
                                                  final name =
                                                      nameController.text;
                                                  final department =
                                                      departmentController.text;
                                                  final salary = int.tryParse(
                                                          salaryController
                                                              .text) ??
                                                      0;

                                                  if (name.isNotEmpty &&
                                                      department.isNotEmpty &&
                                                      salary > 0) {
                                                    _employeeService
                                                        .updateEmployee(
                                                      employee: employee,
                                                      name: name,
                                                      department: department,
                                                      salary: salary,
                                                      context: context,
                                                      onSuccess: () {
                                                        Navigator.pop(context);
                                                      },
                                                      setState: () =>
                                                          setState(() {}),
                                                    );
                                                    setState(() {
                                                      nameController.clear();
                                                      departmentController
                                                          .clear();
                                                      salaryController.clear();
                                                      fetchEmployees();
                                                    });
                                                  } else {
                                                    print(
                                                        'Please fill in all required fields.');
                                                  }
                                                },
                                                child: const Text('Update',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white)),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      employee.name,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    (tenure >= 60 && employee.isActive)
                                        ? const Icon(
                                            Icons.circle,
                                            color: Colors.green,
                                            size: 12,
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Role: ${employee.department}'),
                                    Text(
                                        'Current Employee: ${employee.isActive ? 'Yes' : 'No'}'),
                                  ],
                                ),
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Tenure: ${tenure ~/ 12} year ${tenure % 12} month'),
                                        Text('Salary: ${employee.salary}₹/-'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      },
                    ),
                  ),
          )
        ],
      ),
    );
  }

  void bottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 0),
              child: Text(
                'ADD EMPLOYEE',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff113051),
                ),
              ),
            ),
            const Divider(
              color: Color(0xff113051),
              thickness: 1,
              indent: 50,
              endIndent: 50,
            ),
            AddEmployee(
                nameController: nameController,
                departmentController: departmentController,
                salaryController: salaryController,
                dateController: dateController),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff113051),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              onPressed: () {
                final name = nameController.text;
                final department = departmentController.text;
                final salary = int.tryParse(salaryController.text) ?? 0;
                final joinDate = dateController.text.isNotEmpty
                    ? DateFormat('yyyy-MM-dd').parse(dateController.text)
                    : null;
                if (name.isNotEmpty &&
                    department.isNotEmpty &&
                    salary > 0 &&
                    joinDate != null) {
                  // Perform the necessary operations to add the employee
                  createEmployee();

                  setState(() {
                    nameController.clear();
                    departmentController.clear();
                    salaryController.clear();
                    dateController.clear();
                    fetchEmployees();
                  });
                  Navigator.pop(context);
                } else {
                  // Show an error message or handle the case where required fields are missing
                  // ignore: avoid_print
                  print('Please fill in all required fields.');
                }
              },
              child: const Text('Add',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
