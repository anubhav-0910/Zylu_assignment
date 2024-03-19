# ZYLU Assignment - Employee Management App

This is a Flutter application developed as part of the internship assignment for Zylu Business Solutions Pvt. Ltd. The app allows you to manage employees, including listing all employees, creating new employees, updating employee details, and deleting employees.

## Features

- **List Employees**: View a list of all employees with their details.
- **Create Employee**: Add a new employee by providing their name, department, salary, and join date.
- **Update Employee**: Edit the details (name, department, and salary) of an existing employee.
- **Delete Employee**: Remove an employee from the list.
- **Employee Search**: Search for employees by their name.
- **Filter Employees**:
 - Filter employees based on their tenure (1+ year, 3+ years, 5+ years).
 - Filter employees based on their active status (active or inactive).
- **Active Employee Indicator**: Employees who have been active for more than 5 years are highlighted with a green dot.

## Technologies Used

- **Frontend**: Flutter
- **Backend**: Node.js, Express.js
- **Database**: MongoDB

## Getting Started

To run this app locally, follow these steps:

1. Clone the repository:
   `https://github.com/anubhav-0910/Zylu_assignment.git`
   
2. Navigate to the project directory:
   `cd zylu-assignment`
   
3. Install the required dependencies:
   `flutter pub get`

4. Start the backend server (make sure MongoDB is running):
-  `cd Server`

-  `npm install`
   
-  `npm start`

5. In a separate terminal window or tab, run the Flutter app:
   `flutter run`

The app should now be running on your device or emulator.


