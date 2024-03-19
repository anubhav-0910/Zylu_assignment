import express from "express";
import {
  getAllEmployees,
  getEmployeeById,
  createEmployee,
  updateEmployee,
  deleteEmployee,
  searchEmployees,
  filterEmployees,
 }
  from "../controllers/employeeController.js";

const router = express.Router();

// Filter and search routes
router.get('/search', searchEmployees);
router.get('/filter', filterEmployees);

// Employee routes
router.get('/', getAllEmployees);
router.post('/', createEmployee);
router.route('/:id').get(getEmployeeById).put(updateEmployee).delete(deleteEmployee);

// Catch-all route for invalid routes or parameters
router.use('*', (req, res) => {
  res.status(404).json({ error: 'Invalid route or parameter' });
});

export default router;