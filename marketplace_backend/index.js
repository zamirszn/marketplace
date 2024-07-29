require("dotenv").config();
const express = require("express");

const mongoose = require("mongoose");

const authRouter = require("./routes/auth").default;

const app = express();

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

app.listen(process.env.BASE_URL, () => {
  console.log(`Server started at : ${process.env.BASE_URL}`);
});

app.get("/helloworld", (req, res) => {
  res.json({ hello: "world" });
});
