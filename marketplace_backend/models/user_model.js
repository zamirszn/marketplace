const mongoose = require("mongoose");

const userSchema = mongoose.Schema({
  name: {
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
    default: "user",
  },

  accountType: {
    type: String,
    required: true,
    trim: true,
  },
});

const User = mongoose.model("User", userSchema);
module.exports = User;
