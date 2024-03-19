import {Employee} from '../models/employee.model.js';

// Get all employees
export const getAllEmployees = async (req, res) => {
  try {
    const employees = await Employee.find({});
    res.status(200).json({employees});
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get employee by ID
export const getEmployeeById = async (req, res) => {
  try {
    const employee = await Employee.findById(req.params.id);
    if (!employee) {
      return res.status(404).json({ error: 'Employee not found' });
    }
    res.status(200).json({employee});
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Create a new employee
export const createEmployee = async (req, res) => {
  try {
    const { name, joinDate, isActive, department, salary } = req.body;

    const employee = new Employee({ name, joinDate, isActive, department, salary });
    await employee.save();

    res.status(201).json(employee);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Update an employee
export const updateEmployee = async (req, res) => {
  try {
    const { name, joinDate, isActive, department, salary } = req.body;
    const employee = await Employee.findByIdAndUpdate(
      req.params.id,
      { name, joinDate, isActive, department, salary },
      { new: true }
    );
    if (!employee) {
      return res.status(404).json({ error: 'Employee not found' });
    }
    res.status(200).json(employee);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Delete an employee
export const deleteEmployee = async (req, res) => {
  try {
    const employee = await Employee.findByIdAndDelete(req.params.id);
    if (!employee) {
      return res.status(404).json({ error: 'Employee not found' });
    }
    res.status(200).json({ message: 'Employee deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Search employees
export const searchEmployees = async (req, res) => {
  try {
    const {name} = req.query;
    const query = {};
    if (name) {
      query.name = { $regex: name, $options: 'i' };
    }
    const employees = await Employee.find(query);
    res.status(200).json(employees);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Filter employees
export const filterEmployees = async (req, res) => {
  try {
    const { tenure } = req.query;
    const query = {};

    if (tenure) {
      const numericTenure = parseInt(tenure, 10);
      query.$expr = {
        $gte: [
          {
            $divide: [
              { $subtract: ["$$NOW", "$joinDate"] }, // (Date.now() -  joinDate) in milliseconds
              86400 * 30 * 1000,                  // milliseconds in 30 days
            ],
          },
          numericTenure,
        ],
      };
    }

    const employees = await Employee.find(query);
    res.status(200).json(employees);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};