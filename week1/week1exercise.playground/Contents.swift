//: Playground - noun: a place where people can play

import UIKit

var str:String? = "HI JUN"
str!.characters.count

func domath(operation:String, on a:Double, and b:Double) ->Double{
  var result:Double = 0
  switch operation{
    case "+": result = a + b
    case "-": result = a - b
    case "*": result = a * b
    case "/": result = a / b
  default: print("no such operation")
  }
  return result
}

domath("-",on:2.0,and:2.0)

var image = [
  [1 ,2 ,3],
  [8, 7, 10],
  [9, 9, 9]
]
func imageprocess(inout image:[[Int]]){
  for row in 0..<image.count{
      for col in 0..<image[row].count{
          if image[row][col]<5 {
             image[row][col]=5
        }
    }
  }
}

imageprocess(&image)
image

let x = 1
let y:Double = 1.0

if (true) {print("true")}

for i in 0..<5 {
  print(i)
}

func add(a:Int, to b:Int){
  //.safa
}
let array:[Int]=[]

let a = 1
let b = 2
a+b
var c:Double = -8
while c <= 8{
  sin(c)
  c+=1
}
