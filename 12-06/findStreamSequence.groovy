#!/usr/bin/env groovy

INPUT = 'input.txt'
FILE = new File(INPUT)
START_OF_PACKET_MARKER_LENGTH = 4
START_OF_MESSAGE_MARKER_LENGTH = 14

def uniqueSequenceEndIndex(file, length) {
  int index = 0
  file.withReader { reader ->
  List<char> uniqueChars = []
  for (char c = reader.read(); c != -1 && uniqueChars.size() != length; c = reader.read()) {
    def currentIndex = uniqueChars.indexOf(c)
    if (currentIndex != -1) {
      uniqueChars = uniqueChars.drop(currentIndex + 1)
    }
    uniqueChars << c
    index++
  }
  }
  return index
}

println "Part 1: ${uniqueSequenceEndIndex(FILE, START_OF_PACKET_MARKER_LENGTH)}"
println "Part 2: ${uniqueSequenceEndIndex(FILE, START_OF_MESSAGE_MARKER_LENGTH)}"
