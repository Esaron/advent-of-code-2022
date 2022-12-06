#!/usr/bin/env groovy

INPUT = 'input.txt'

def index = 0
new File(INPUT).withReader { reader ->
  def uniqueChars = []
  for (char c = reader.read(); c != -1 && uniqueChars.size() != 4; c = reader.read()) {
    def currentIndex = uniqueChars.indexOf(c)
    if (currentIndex != -1) {
      uniqueChars = uniqueChars.drop(currentIndex + 1)
    }
    uniqueChars << c
    index++
  }
}

println(index)
