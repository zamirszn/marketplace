const jwt = require("jsonwebtoken");

const authMiddleware = (req, res, next) => {
  const token = req.header("x-auth-token");

  if (!token) {
    return res
      .status(401)
      .json({ msg: "No auth  token, authorization denied" });
  }

  try {
    const verified = jwt.verify(token, process.env.JWT_SECRET);

    if (!verified) return res.status(401).json({ msg: "Token is not valid" });

    req.user = verified.id;
    req.token = token;

    next();
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

module.exports = authMiddleware;
