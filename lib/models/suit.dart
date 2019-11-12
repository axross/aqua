enum Suit {
  spade,
  heart,
  diamond,
  club,
}

int compareSuit(Suit a, Suit b) => a.index - b.index;
