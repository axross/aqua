enum Rank {
  ace,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king,
}

int getStrongnessOfRank(Rank rank, {bool forBottomStraight = false}) =>
    rank == Rank.ace && !forBottomStraight ? 13 : rank.index;

int compareRank(Rank a, Rank b) => a.index - b.index;

int compareStrongnessOfRank(Rank a, Rank b) =>
    getStrongnessOfRank(a) - getStrongnessOfRank(b);

const ranksInStrongnessOrder = [
  Rank.ace,
  Rank.king,
  Rank.queen,
  Rank.jack,
  Rank.ten,
  Rank.nine,
  Rank.eight,
  Rank.seven,
  Rank.six,
  Rank.five,
  Rank.four,
  Rank.three,
  Rank.two,
];
