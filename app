import React, { useState, useEffect } from 'react';
import ExpenseForm from './ExpenseForm';
import ExpenseList from './ExpenseList';
import ChartComponent from './ChartComponent';

import { initializeApp } from "firebase/app";
import { getDatabase, ref, onValue, push, remove } from "firebase/database";

// Firebase config - replace with your own config
const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_PROJECT.firebaseapp.com",
  databaseURL: "https://YOUR_PROJECT-default-rtdb.firebaseio.com",
  projectId: "YOUR_PROJECT",
  storageBucket: "YOUR_PROJECT.appspot.com",
  messagingSenderId: "YOUR_SENDER_ID",
  appId: "YOUR_APP_ID"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getDatabase(app);

function App() {
  const [expenses, setExpenses] = useState({});

  useEffect(() => {
    const expensesRef = ref(db, 'expenses');
    onValue(expensesRef, (snapshot) => {
      const data = snapshot.val() || {};
      setExpenses(data);
    });
  }, []);

  const addExpense = (expense) => {
    const expensesRef = ref(db, 'expenses');
    push(expensesRef, expense);
  };

  const deleteExpense = (id) => {
    const expenseRef = ref(db, `expenses/${id}`);
    remove(expenseRef);
  };

  return (
    <div style={{ maxWidth: 600, margin: '20px auto', fontFamily: 'Arial, sans-serif' }}>
      <h2>Expense Tracker</h2>
      <ExpenseForm addExpense={addExpense} />
      <ExpenseList expenses={expenses} deleteExpense={deleteExpense} />
      <ChartComponent expenses={expenses} />
    </div>
  );
}

export default App;
