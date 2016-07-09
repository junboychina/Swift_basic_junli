//: Playground - noun: a place where people can play

import UIKit

////////////////////////////////////// Closure

var str = "Hello, playground"

var Str:String? = "hi,jun" //防止出现 nil 情况

str.characters.count
Str!.characters.count

//第一种定义函数方式
func performMagic(spell:String)->String{
  return spell
}

performMagic("wow")

//复制函数
let newMagic=performMagic

newMagic("wow2")

//第二种定义函数方式
var newMagicFunction={
  (spell:String)->String in
  return spell;
}

newMagicFunction("wow3")

////////////////////////////////////////// Structure

struct Animal {
  var name:String = ""
  var heightInches = 0.0
  var heightCM:Double{
    get{
      return 2.54*heightInches
    }
    set (heightCM){
      heightInches = heightCM/2.54
    }
  }
}

let dog = Animal (name: "dog", heightInches: 5)
dog.heightInches
dog.name
dog.heightCM

var cat = Animal (name: "cat", heightInches: 50)
cat.name
cat.heightCM = 66
cat.heightInches

let noValue:Int? = nil
//let unwrappedValue = noValue!

//value type

class number{
  var n:Int
  init(n:Int){
    self.n=n
  }
}

var anumber=number(n:3)
anumber.n
var bnumber=anumber
bnumber.n

bnumber.n=5
bnumber.n
anumber.n

struct num{
  var n:Int
  init(n:Int){
    self.n=n
  }
}

var cnumber=num(n:3)
cnumber.n
var dnumber=cnumber
dnumber.n

dnumber.n=5
dnumber.n
cnumber.n

