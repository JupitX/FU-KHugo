const express = require("express");
const cors = require("cors");

const app = express();
const PORT = 3000;

app.use(
    cors({
        origin: ["http://localhost:5173"], // Should be the actual domain
    })
);

app.get("/", (req, res) => {
    res.send("Welcome to the node server!!");
});

app.get("/api/hello", (req, res) => {
    res.json({"message": "Hello from the API!"});
});

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});