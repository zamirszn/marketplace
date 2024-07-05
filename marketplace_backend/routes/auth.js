const express = require("express");
const bcrypt = require("bcryptjs");
const User = require("../models/user_model");

const authRouter = express.Router();

authRouter.post("/api/signup", async (req, res) => {
  console.log(req.body);
  const { email, password, name, accountType, phoneNumber } = req.body;

  try {
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ msg: "User with this email already exists" });
    }

    const hashedPassword = await bcrypt.hash(password, 8);

    let user = new User({
      email,
      password: hashedPassword,
      name,
      accountType,
      phoneNumber,
    });

    user = await user.save();
    res.status(200).json({ msg: "Registration Successful" });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = authRouter;
