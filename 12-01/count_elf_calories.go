package main

import(
	"bufio"
	"fmt"
	"os"
	"sort"
	"strconv"
)

func main() {
	f, e := os.Open("input.txt")
	if e != nil {
		panic(e)
	}
	defer f.Close()
	
	scanner, currentCalories := bufio.NewScanner(f), 0
	var line string
	var elfCalories []int
	for scanner.Scan() {
		line = scanner.Text()
		calories, e := strconv.Atoi(line)
		if e != nil {
			 elfCalories = append(elfCalories, currentCalories)
			currentCalories = 0
		} else {
			currentCalories += calories
		}
	}
	sort.Slice(elfCalories, func(i, j int) bool { return elfCalories[i] > elfCalories[j] })
	fmt.Println(elfCalories[0] + elfCalories[1] + elfCalories[2])
}

