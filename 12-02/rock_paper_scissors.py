#!/usr/bin/env python3

from functools import reduce

GAME_POINTS = {
  'X': 0,
  'Y': 3,
  'Z': 6
}

SHAPE_POINTS = {
  'A': 0,
  'B': 1,
  'C': 2,
  'X': 2,
  'Y': 0,
  'Z': 1
}

def shape_points(opponent, outcome):
    return (SHAPE_POINTS[opponent] + SHAPE_POINTS[outcome]) % 3 + 1

def points(game):
  if not game:
    return 0

  opponent, outcome = game.split()
  return shape_points(opponent, outcome) + GAME_POINTS[outcome]

f = open("input.txt", "r")
games = f.read().split("\n")
print(reduce(lambda x, y: x + points(y), games, 0))
