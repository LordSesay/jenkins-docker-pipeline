const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.json({ message: 'Hello from Jenkins Pipeline!', version: '1.0.0' });
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});