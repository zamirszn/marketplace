const mongoose = require("mongoose");

const userOTPVerificationSchema = Schema({
  email: { type: String, required: true, unique: true },
  otp: String,
  createdAt: Date,
  expiresAt: Date,
});

const userOTPModel = mongoose.model(
  "userOTPVerification",
  userOTPVerificationSchema
);

module.exports = userOTPModel;
