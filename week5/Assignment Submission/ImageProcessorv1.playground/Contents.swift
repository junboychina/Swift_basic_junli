//: Playground - noun: a place where people can play

import UIKit


let image = UIImage(named: "sample")!

// Process the image!
let myRGBA = RGBAImage(image: image)! //load the image into processor


let filter1 = imageProcessor(myRGBA: myRGBA, function: "Halve Red")
let filter2 = imageProcessor(myRGBA: myRGBA, function: "Double Red")
let filter3 = imageProcessor(myRGBA: myRGBA, function: "Halve Green")
let filter4 = imageProcessor(myRGBA: myRGBA, function: "Double Green")
let filter5 = imageProcessor(myRGBA: myRGBA, function: "Halve Blue")
let filter6 = imageProcessor(myRGBA: myRGBA, function: "Double Blue")
let filter7 = imageProcessor(myRGBA: myRGBA, function: "Halve Alpha")
let filter8 = imageProcessor(myRGBA: myRGBA, function: "Double Alpha")



let processedImage1 = filter1!.myRGBA.toUIImage()
let processedImage2 = filter2!.myRGBA.toUIImage()
let processedImage3 = filter3!.myRGBA.toUIImage()
let processedImage4 = filter4!.myRGBA.toUIImage()
let processedImage5 = filter5!.myRGBA.toUIImage()
let processedImage6 = filter6!.myRGBA.toUIImage()
let processedImage7 = filter7!.myRGBA.toUIImage()
let processedImage8 = filter8!.myRGBA.toUIImage()
