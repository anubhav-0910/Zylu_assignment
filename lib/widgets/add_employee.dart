import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEmployee extends StatelessWidget {
  const AddEmployee({
    super.key,
    required this.nameController,
    required this.departmentController,
    required this.salaryController,
    required this.dateController,
  });

  final TextEditingController nameController;
  final TextEditingController departmentController;
  final TextEditingController salaryController;
  final TextEditingController dateController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Color(0xff113051)),
              ),
            ),
            cursorColor: const Color(0xff113051),
            cursorHeight: 20,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: departmentController,
            decoration: const InputDecoration(
              hintText: 'Department',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Color(0xff113051)),
              ),
            ),
            cursorColor: const Color(0xff113051),
            cursorHeight: 20,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: salaryController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Salary',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Color(0xff113051)),
              ),
            ),
            cursorColor: const Color(0xff113051),
            cursorHeight: 20,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: dateController,
            readOnly: true,
            decoration: const InputDecoration(
              hintText: 'Join Date',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Color(0xff113051)),
              ),
            ),
            cursorColor: const Color(0xff113051),
            cursorHeight: 20,
            onTap: () async {
              DateTime? date = await showDatePicker(
                  context: context,
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Colors.black,
                          onPrimary: Colors.white,
                          surface: Colors.white,
                          onSurface: Colors.black,
                        ),
                        dialogBackgroundColor: Colors.black,
                      ),
                      child: child!,
                    );
                  },
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  confirmText: "Select");
              if (date != null) {
                dateController.text = DateFormat('yyyy-MM-dd').format(date);
              }
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
