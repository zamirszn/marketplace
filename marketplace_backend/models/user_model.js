const mongoose = require("mongoose");

// const userOTPVerification = require("./otp_verification");

const userSchema = mongoose.Schema({
  fullName: {
    required: true,
    type: String,
    trim: true,
  },

  email: {
    type: String,
    required: true,
    trim: true,
    validate: {
      validator: (value) => {
        const re =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return value.match(re);
      },
      message: "Please enter a valid email",
    },
  },

  password: {
    required: true,
    type: String,
    trim: true,
  },

  phoneNumber: {
    type: String,
    trim: true,
    default: "",
  },

  role: {
    type: String,
    default: "User",
    enum: ["Admin", "User"],
  },

  emailVerified: {
    type: Boolean,
    default: false,
  },

  refreshToken: { type: String },
});

const User = mongoose.model("User", userSchema);
module.exports = User;
