import express from 'express';
import employeeRouter from './routes/employee.js';

export const app = express();

app.use(express.json());
app.use('/api/employees', employeeRouter);

app.get('/', (req, res) => {
  res.send('Hello World');
});
