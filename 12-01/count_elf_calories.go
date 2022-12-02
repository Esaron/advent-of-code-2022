package main

import(
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func main() {
	f, e := os.Open("input.txt")
	if e != nil {
		panic(e)
	}
	defer f.Close()
	
	scanner, currentCalories, mostCalories := bufio.NewScanner(f), 0, 0
	var line string
	for scanner.Scan() {
		line = scanner.Text()
		calories, e := strconv.Atoi(line)
		if e != nil {
			if currentCalories > mostCalories {
				mostCalories = currentCalories
			}
			currentCalories = 0
		} else {
			currentCalories += calories
		}
	}
	fmt.Println(mostCalories)
}

