const express = require("express");
const bcrypt = require("bcryptjs");
const User = require("../models/user_model");
const jwt = require("jsonwebtoken");
const sendOTP = require("../utils/send_otp_mail");
const OTP = require("../models/otp_model");
const authMiddleware = require("../middlewares/auth_middleware");

const authRouter = express.Router();

authRouter.post("/api/signup", async (req, res) => {
  console.log(req.body);
  const { email, password, fullName } = req.body;

  try {
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ msg: "User with this email already exists" });
    }

    const hashedPassword = await bcrypt.hash(password, process.env.SALTROUNDS);

    let user = new User({
      email,
      password: hashedPassword,
      fullName,
      accountType,
      emailVerified,
    });

    user = await user.save();
    sendOTP(email, "Account Verification", "Your OTP is", 1);
    res.status(201).json({
      msg: "Account created successfully, a verification code has been sent to your email",
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("api/login", async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res
        .status(400)
        .json({ msg: "User with this email does not exist" });
    }

    if (!user.emailVerified) {
      return res
        .status(400)
        .json({ msg: "Email not verified, please verify your account" });
    }

    const isPasswordMatch = await bcryptjs.compare(password, user.password);
    if (!isPasswordMatch) {
      return res.status(400).json({ msg: "Incorrect password" });
    }

    const accessToken = generateAccessToken(user);
    const refreshToken = generateRefreshToken(user);

    user.refreshToken = refreshToken;
    await user.save();

    res.json({ accessToken, refreshToken, ...user._doc });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/api/refreshToken", async (req, res) => {
  const { refreshToken } = req.body;

  if (!refreshToken) return res.sendStatus(401); // Unauthorized
  const user = await User.findOne({ refreshToken });
  if (!user) return res.sendStatus(403); // Forbidden

  jwt.verify(refreshToken, process.env.REFRESH_TOKEN_SECRET, (err, user) => {
    if (err) return res.sendStatus(403); // Forbidden

    const accessToken = generateAccessToken(user);
    res.json({ accessToken });
  });
});

// authRouter.post("api/tokenIsValid", async (req, res) => {
//   try {
//     const token = req.header("x-auth-token");
//     if (!token) return res.json(false);

//     const verified = jwt.verify(token, process.env.JWT_SECRET);
//     if (!verified) return res.json(false);

//     const user = await User.findById(verified.id);
//     if (!user) return res.json(false);

//     return res.json(true);
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

authRouter.post("/api/sendOTP", async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) {
      return res.status(400).json({ msg: "Email is required" });
    }

    sendOTP(email, "Account Verification", "Your OTP is", 1);

    res.status(200).json({ msg: "OTP sent successfully" });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/api/verifyOTP", async (req, res) => {
  try {
    const { email, otp } = req.body;
    if (!email || !otp) {
      return res.status(400).json({ msg: "Email and OTP are required" });
    }

    const matchedOTP = await OTP.findOne({ email });

    if (!matchedOTP) {
      return res.status(400).json({ msg: "OTP not found" });
    }

    const { expiresAt } = matchedOTP;

    if (Date.now() > expiresAt) {
      await OTP.deleteOne({ email });
      return res.status(400).json({ msg: "OTP has expired" });
    }

    const isMatch = await bcrypt.compare(otp, matchedOTP.otp);

    if (!isMatch) {
      return res.status(400).json({ msg: "Incorrect OTP" });
    }

    await User.updateOne({ email }, { emailVerified: true });

    res.status(200).json({ msg: "OTP verified successfully", email });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.get("/api/userProfile", authMiddleware, async (req, res) => {
  try {
    const user = await User.findById(req.user);
    return res.json(...user._doc);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

function generateAccessToken(user) {
  return jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
    expiresIn: "15m",
  });
}

// Function to generate refresh token
function generateRefreshToken(user) {
  return jwt.sign({ id: user._id }, process.env.REFRESH_TOKEN_SECRET);
}


module.exports = authRouter;
