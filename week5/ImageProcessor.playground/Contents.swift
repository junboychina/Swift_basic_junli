//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "sample")!

// Process the image!
/*
 You will be asked to provide feedback to your peers in the following areas:
 
 1. Does the playground code apply a filter to each pixel of the image? Maximum of 2 pts
 
 2. Are there parameters for each filter formula that can change the intensity of the effect of the filter? Maximum of 3 pts
 
 3. Is there an interface to specify the order and parameters for an arbitrary number of filter calculations that should be applied to an image? Maximum of 2 pts
 
 4. Is there an interface to apply specific default filter formulas/parameters to an image, by specifying each configuration’s name as a String? Maximum of 2 pts
*/

// Normalize the RGB values to be between 0 and 255
func MinMaxValues(value: Double) -> UInt8{
    
    if (value > 255){
        return 255
    }
    else if (value < 0) {
        return 0
    }
    return UInt8(value)
}

// 4. Parameters for Red, Green, and Blue percentage changes
func ApplyRGBFilters(RedPercent: Int, GreenPercent: Int, BluePercent: Int, image: UIImage) -> UIImage {
    var filteredImage = RGBAImage(image: image)!
    var pixel = filteredImage.pixels[0]
    
    let red = Double(RedPercent)/100
    let green = Double(GreenPercent)/100
    let blue = Double(BluePercent)/100
    
    // 1. Process each pixel in the image:
    for x in 0..<filteredImage.height {
        for y in 0..<filteredImage.width{
            pixel = filteredImage.pixels[y * filteredImage.width + x]
            
            pixel.red = MinMaxValues(Double(pixel.red) + Double(pixel.red) * red)
            pixel.green = MinMaxValues(Double(pixel.green) + Double(pixel.green) * green)
            pixel.blue = MinMaxValues(Double(pixel.blue) + Double(pixel.blue) * blue)
            filteredImage.pixels[y * filteredImage.width + x] = pixel
        }
    }
    
    return filteredImage.toUIImage()!
}


// 2/3. Parameters for each filter formula that can change the intensity of the effect of the filter
// Parameters can be adjusted to be both positive and negative percentages, ranging from -100% to 100%
let newImage = ApplyRGBFilters(20, GreenPercent: -19, BluePercent: 0, image: image)

