import {app} from './app.js';
import mongoose from 'mongoose';

const connectDB = async () => {
  mongoose.connect("mongodb+srv://anubhavgupta:anubhavgupta0910@cluster0.xgw6zo2.mongodb.net/", {
    dbName: 'Zylu_Assignment'
  })
  .then(() => console.log('Connected to the Database'))
  .catch((err) => console.log(err))
}

connectDB();

app.listen(3000, () => {
  console.log('Server is running');
});