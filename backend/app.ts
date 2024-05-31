import cors from "cors";
import express, { Request, Response } from "express";
import helmet from "helmet";
import * as path from "path";
import { PORT } from "./config";
import { addOrUpdateScore, getScoreByID, getScores, resetData } from "./score";

const app = express();
// Middleware for CORS settings
const corsOptions = {
  origin: "*",
  // optionsSuccessStatus: 200,
};

app.use(cors(corsOptions));
app.use(
  helmet({
    contentSecurityPolicy: {
      directives: {
        defaultSrc: ["'self'"],
        scriptSrc: ["'self'", "'unsafe-inline'", "'wasm-unsafe-eval'"],
        connectSrc: ["'self'", "https://ship-game-3.onrender.com"],
        objectSrc: ["'none'"], // Optionally, you can tighten this
        // Other directives as needed
        // These are permissive CSP directives, not entirely sure if they work this way
        // defaultSrc: ["*"],
        // scriptSrc: ["*", "'unsafe-inline'", "'unsafe-eval'"],
        // styleSrc: ["*", "'unsafe-inline'"],
        // imgSrc: ["*"],
        // childSrc: ["*"],
        // frameSrc: ["*"],
        // connectSrc: ["*"],
      },
    },
    crossOriginEmbedderPolicy: { policy: "require-corp" },
    crossOriginOpenerPolicy: { policy: "same-origin" },
  }),
);
app.use(express.json());
app.use(express.static(path.join(__dirname, "..", "public")));

// POST endpoint to add a score
app.post("/score", (req: Request, res: Response) => {
  const { id, name, score } = req.body;
  if (
    typeof id !== "number" ||
    typeof name !== "string" ||
    typeof score !== "number"
  ) {
    res.status(400).send("Invalid input");
    return;
  }
  const updatedScore = addOrUpdateScore(id, name, score);
  res.status(201).send(updatedScore);
});

// GET endpoint to retrieve scores
app.get("/score", (req: Request, res: Response) => {
  const scores = getScores();
  res.status(200).json(scores);
});

// GET endpoint to retrieve score by ID
app.get("/score/:id", (req: Request, res: Response) => {
  const id = parseInt(req.params.id);
  if (typeof id !== "number") {
    res.status(400).send("Invalid input");
    return;
  }
  const scoreDataByID = getScoreByID(id);
  if (!scoreDataByID) {
    res.status(404).send("Score not found");
    return;
  }
  res.status(200).json(scoreDataByID);
});

// reset game data
app.get("/reset", (req: Request, res: Response) => {
  resetData();
  res.status(200);
});

const port = process.env.PORT || PORT;

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
