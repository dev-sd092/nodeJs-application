const express = require("express");
const path = require("path");

const app = express();
const PORT = process.env.PORT || 3000;

// Serve static files (frontend)
app.use(express.static(path.join(__dirname, "public")));

// API route
app.get("/api/hello", (req, res) => {
  res.json({ message: "🚀 Hello from DevOps App running on AWS!" });
});

// Start server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
