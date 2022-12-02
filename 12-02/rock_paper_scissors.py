#!/usr/bin/env python3

from functools import reduce
import pdb

SHAPE_MAP = {
  'A': 'X',
  'B': 'Y',
  'C': 'Z'
}

POINTS = {
  'X': 1,
  'Y': 2,
  'Z': 3
}

WINS = {
  'X': 'Y',
  'Y': 'Z',
  'Z': 'X'
}

def points(game):
  if not game:
    return 0

  opponent, me = game.split()
  opponent = SHAPE_MAP[opponent]
  points = POINTS[me]
  if WINS[opponent] == me:
    return points + 6
  elif me == opponent:
    return points + 3
  else:
    return points

f = open("input.txt", "r")
games = f.read().split("\n")
print(reduce(lambda x, y: x + points(y), games, 0))
