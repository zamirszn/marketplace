const nodemailer = require("nodemailer");
const OTP = require("../models/otp_model");

let transporter = nodemailer.createTransport({
  host: process.env.EMAIL_HOST,
  ServiceWorker: process.env.EMAIL_SERVICE,
  port: process.env.EMAIL_PORT,
  secure: Boolean(process.env.EMAIL_SECURE),
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

const sendOTP = async (email, subject, duration = 1) => {
  try {
    if (!email || !subject || !message) {
      throw new Error("Email, subject and message are required");
    }

    await OTP.deleteOne({ email });

    const generatedOTP = generateOTP();

    await transporter.sendMail({
      html: `<p>Your OTP is ${generatedOTP}</p><p>This code expires in : ${duration} hour(s)</p>`,
      from: process.env.EMAIL_USER,
      to: email,
      subject: "OTP Verification",
      text: `Your OTP is ${generatedOTP}. Expiry Date: ${expiryDate}`,
    });

    // save otp to database
    const hashedOTP = await bcrypt.hash(generatedOTP, process.env.SALTROUNDS);

    const newOTP = await new OTP({
      email,
      otp: hashedOTP,
      createdAt: Date.now(),
      expiresAt: Date.now() + 3600000 * +duration,
    });

    await newOTP.save();
  } catch (e) {
    console.log("email not sent " + e.message);
  }
};

const generateOTP = () => {
  return `${Math.floor(1000 + Math.random() * 9000)}`;
};

module.exports = sendOTP;
