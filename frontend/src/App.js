import React from 'react';
import Signup from './components/Signup';
import Login from './components/Login';
import ForgotPassword from './components/ForgotPassword';

const App = () => (
  <div>
    <h1>Auth App</h1>
    <Signup />
    <Login />
    <ForgotPassword />
  </div>
);

export default App;