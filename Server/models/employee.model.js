import mongoose from 'mongoose';

const employeeSchema = new mongoose.Schema({
  name: { type: String, required: true },
  joinDate: { type: Date, required: true }, // Include joinDate in the schema
  isActive: { type: Boolean, default: true },
  department: { type: String, required: true },
  salary: { type: Number, required: true },
});

export const Employee = mongoose.model('Employee', employeeSchema);
