/****************
 *
 * Created by Joep Ruiter
 * Struct to filter objects of the type RGBAImage, 
 * which in turn contain an Image.
 *
 * Parameters determine the type of filter applied
 *
 *****************/

import UIKit

public struct imageProcessor{
    public var myRGBA: RGBAImage

    
    public init?(myRGBA: RGBAImage, color: String, multiplier: Int, function: String){
        self.myRGBA = myRGBA
        self.myRGBA = genericFilter(color, multiplier: multiplier, function: function)
        
    }
    
    public init?(myRGBA: RGBAImage){
        self.myRGBA = myRGBA

    }
    
    public init?(myRGBA: RGBAImage, function: String){
        self.myRGBA = myRGBA
        predefinedFilter(function)

    }
    
    mutating func genericFilter(color: String, multiplier: Int, function: String) -> RGBAImage {
        let avgRGBA = myRGBA.defineAverageRGBA()
        
        for y in 0..<myRGBA.height {
            for x in 0..<myRGBA.width{
                let index = y * myRGBA.width + x
                var pixel = myRGBA.pixels[index]
                
                switch color{
                case "Red" :
                    let colorDiff = Int(pixel.red) - avgRGBA["avgRed"]!
                    
                    
                    if (colorDiff>0) {
                        if (function == "Increase color"){
                            pixel.red = UInt8(max(0,min(255,avgRGBA["avgRed"]!+colorDiff*multiplier)))
                        }
                        if (function == "Decrease color"){
                            pixel.red = UInt8(max(0,min(255,avgRGBA["avgRed"]!-colorDiff*multiplier)))
                        }
                        myRGBA.pixels[index] = pixel
                        
                    }
                case "Green" :
                    let colorDiff = Int(pixel.green) - avgRGBA["avgGreen"]!
                    
                    if (colorDiff>0) {
                        if (function == "Increase color"){
                            pixel.green = UInt8(max(0,min(255,avgRGBA["avgGreen"]!+colorDiff*multiplier)))
                        }
                        if (function == "Decrease color"){
                            pixel.green = UInt8(max(0,min(255,avgRGBA["avgGreen"]!-colorDiff*multiplier)))
                        }
                        myRGBA.pixels[index] = pixel
                    }
                case "Blue" :
                    let colorDiff = Int(pixel.blue) - avgRGBA["avgBlue"]!
                    
                    if (colorDiff>0) {
                        if (function == "Increase color"){
                            pixel.blue = UInt8(max(0,min(255,avgRGBA["avgBlue"]!+colorDiff*multiplier)))
                        }
                        if (function == "Decrease color") {
                            pixel.blue = UInt8(max(0,min(255,avgRGBA["avgBlue"]!-colorDiff*multiplier)))
                        }
                        myRGBA.pixels[index] = pixel
                    }
                case "Alpha" :
                    let colorDiff = Int(pixel.alpha) - avgRGBA["avgAlpha"]!
                    
                    if (colorDiff>0) {
                        if (function == "Increase color"){
                            pixel.alpha = UInt8(max(0,min(255,avgRGBA["avgAlpha"]!+colorDiff*multiplier)))
                        }
                        if (function == "Decrease color"){
                            pixel.alpha = UInt8(max(0,min(255,avgRGBA["avgAlpha"]!-colorDiff*multiplier)))
                        }
                        myRGBA.pixels[index] = pixel
                    }
                default:
                    return myRGBA
                }
                
            }
        }
        return myRGBA
    }
    public mutating func predefinedFilter(filter: String) ->  RGBAImage {
        
        
        switch filter {
        case "Halve Red" :
            myRGBA = genericFilter("Red",multiplier: 2,function: "Decrease color")
        case "Double Red" :
            myRGBA = genericFilter("Red",multiplier: 2,function: "Increase color")
        case "Halve Green" :
            myRGBA = genericFilter("Green",multiplier: 2,function: "Decrease color")
        case "Double Green" :
            myRGBA = genericFilter("Green",multiplier: 2,function: "Increase color")
        case "Halve Blue" :
            myRGBA = genericFilter("Blue",multiplier: 2,function: "Decrease color")
        case "Double Blue" :
            myRGBA = genericFilter("Blue",multiplier: 2,function: "Increase color")
        case "Halve Alpha" :
            myRGBA = genericFilter("Alpha",multiplier: 2,function: "Decrease color")
        case "Double Alpha" :
            myRGBA = genericFilter("Alpha",multiplier: 2,function: "Increase color")
        default :
            return myRGBA
        }
        return myRGBA
    }

}

