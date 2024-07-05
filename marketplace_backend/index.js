require("dotenv").config();
const express = require("express");

const mongoose = require("mongoose");

const authRouter = require("./routes/auth");

const app = express();

const PORT = 3000;

const mongoDBConnectionString = process.env.MONGO_URI;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(authRouter);

mongoose
  .connect(mongoDBConnectionString)
  .then(() => {
    console.log("connnection to DB successfull");
  })
  .catch((e) => {
    console.log(e);
  });

app.listen(PORT, () => {
  console.log(`server started at port : ${PORT}`);
});

app.get("/helloworld", (req, res) => {
  res.json({ hello: "world" });
});
