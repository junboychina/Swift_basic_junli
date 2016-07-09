//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "sample")

// Process the image!
var img = ProcessImage(image: image!)

//HOW TO USE:
//Change the options below to get different effects

//You can change the order of filters, how many are used, which ones to use, or how they are used

//Each item has two possible parts, the first is the name of the filter, and the optional second is the intensity of that filter

//For example, "Bright 100" means change the brightness by 100%
//If you leave out the second part (the "100" in the example) a default value will be used (e.g. just put "Bright")

//Possible filters and their defaults:
    //Bright 20 - changes the filter by 20%. Value can be positive (brighter) or negative (darker).
    //Contrast 20 - changes the contrast by 20%. Value can be positive (more contrast) or negative (less).
    //SwapRedGreen - no value necessary, if one is supplied it is ignored. Simply swaps the red and green channels.
    //TintBlue 100 - increases the amount of Blue in the pixel by 100%. Value can be positive (more blue) or negative (less).
    //Fuzz 1 - averages the pixels surrounding this one. Value tells you how many pixels around (1 = one pixel around, 2 = two pixels around, and so on). The more pixels you supply, the fuzzier it is


//Experiment here with each filter, just comment out the others and see what happens. Change the order, which ones are applied, and so on.


img?.AddFilter("Bright 100")
img?.AddFilter("Contrast 100")
img?.AddFilter("SwapRedGreen")
img?.AddFilter("TintBlue 1000")
img?.AddFilter("Fuzz 2")



//this runs it
img?.Go()

//and this shows the output
let output = img!.ShowResult()
