export interface ScoreEntry {
  id: number;
  name: string;
  score: number;
}

const scores: ScoreEntry[] = [];


export function addOrUpdateScore(id: number, name: string, score: number): ScoreEntry {
  let scoreEntry = scores.find(entry => entry.id === id);

  if (scoreEntry) {
    // If entry exists, update its score
    scoreEntry.score += score;  // Add the incoming score to the existing one
  } else {
    // If no entry exists, create a new one
    scoreEntry = { id, name, score };
    scores.push(scoreEntry);
  }

  return scoreEntry;  // Return the existing or new entry
}


export function getScores(): ScoreEntry[] {
  return scores;
}

export function getScoreByID(id: number): ScoreEntry | null {
  const scoreDataByID =  scores.find(entry => entry.id === id);
  return scoreDataByID ?? null;
}

export function resetData(): null {
  scores.length = 0;
  return null;
}