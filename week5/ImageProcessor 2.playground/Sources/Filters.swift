import Foundation
import UIKit

func Bright(pixel: Pixel, intensity: String) -> Pixel {
    //change the brightness of the pixel, by a passed percentage with a default of 20%
    //positive values make it brighter, negative values make it darker
    var newPixel = pixel

    let value:Double = CheckIntensity(intensity, defaultValue: 20)

    let mult: Double = 1 + (value/100)
    
    newPixel.red = UInt8(max(0,min(255,Int(Double(newPixel.red) * mult)))) //multiply the pixel, making sure it stays within the limits of 0 and 255
    newPixel.blue = UInt8(max(0,min(255,Int(Double(newPixel.blue) * mult))))
    newPixel.green = UInt8(max(0,min(255,Int(Double(newPixel.green) * mult))))
 
    return newPixel
}

func Contrast(pixel: Pixel, intensity: String) -> Pixel {
    //change the contrast of the pixel, by a passed percentage with a default of 20%
    //positive values increase the contrast, negative values decrease the contrast
    var newPixel = pixel

    let value:Double = CheckIntensity(intensity, defaultValue: 20)

    let mult: Double = 1 + (value/100)
    
    //using 127 as the average, pushing it away from there (or to, for negative values)
    newPixel.red = UInt8(max(0,min(255,Int((Double(newPixel.red) - 127) * mult) + 127)))
    newPixel.blue = UInt8(max(0,min(255,Int((Double(newPixel.blue) - 127) * mult) + 127)))
    newPixel.green = UInt8(max(0,min(255,Int((Double(newPixel.green) - 127) * mult) + 127)))
    
    return newPixel
}

func SwapRedGreen(pixel: Pixel) -> Pixel {
    //switch the red and green channels
    //no associated intensity values used, simply switches them
    var newPixel = pixel
    let red = newPixel.red //store it temporarily
    
    newPixel.red = newPixel.green
    newPixel.green = red
    
    return newPixel
}

func TintBlue(pixel: Pixel, intensity: String) -> Pixel {
    //increase the amount of blue
    //positive values add blue, negative values remove it
    var newPixel = pixel

    let value: Double = CheckIntensity(intensity, defaultValue: 100)

    let mult: Double = 1 + (value/100)
    
    newPixel.blue = UInt8(max(0,min(255,Int(Double(newPixel.blue) * mult))))
    
    return newPixel
}

func Fuzz(pixel: Pixel, inputImage: RGBAImage, x: Int, y: Int, intensity: String) -> Pixel {
    //we bring in the original image (inputImage) to blur off, rather than off pixels we already blurred

    var newPixel = pixel
    
    let value:Int = Int(CheckIntensity(intensity, defaultValue: 1))
    
    var red: UInt32 = 0 //the total values for each red surrounding our pixel
    var blue: UInt32 = 0
    var green: UInt32 = 0
    var pixelCount: UInt32 = 0 //need a counter for how many pixels we are averaging, for the edges of the image where it will not be 8

    //loop through the surrounding pixels (as many as defined in the input), totaling their colors so we can average it
    for blurX in (x-value)..<(x+value + 1) {
        for blurY in (y-value)..<(y+value + 1){
            if (blurX >= 0 && blurX < inputImage.width) { //make sure it's within the image, otherwise we'll get errors
                if (blurY >= 0 && blurY < inputImage.height) {
                    let wkgindex = blurY * (inputImage.width) + blurX
                    let wkgpixel = inputImage.pixels[wkgindex]
                    red = red + UInt32(wkgpixel.red)
                    blue = blue + UInt32(wkgpixel.blue)
                    green = green + UInt32(wkgpixel.green)
                    pixelCount = pixelCount + 1
                }
            }
        }
    }

    //then set our new result to the average of what we found around it
    newPixel.red = UInt8(red/pixelCount)
    newPixel.blue = UInt8(blue/pixelCount)
    newPixel.green = UInt8(green/pixelCount)
    
    return newPixel
}

func CheckIntensity(intensity: String, defaultValue: Double) -> Double {
    //this function does a conversion of the intensity that was passed, and returns it or the default value
    //I put this in because I was repeating it in several functions, so split it out to a new function to make it cleaner
    var value:Double = 0
    
    if (intensity == "") {
        value = defaultValue
    }
    else
        if Double(intensity) != nil {
            value = Double(intensity)!
    }
    
    return value
}










