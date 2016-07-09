/****************
 *
 * Created by Joep Ruiter
 * Extension of the standard RGBAImage struct
 * to calculate the avarage of Red, Green, Blue and Alpha
 * directly from the provided RGBAImage struct
 *
*****************/



import UIKit

public extension RGBAImage {
    
    public func defineAverageRGBA() -> [String : Int]{
        
        var totalRed = 0
        var totalGreen = 0
        var totalBlue = 0
        var totalAlpha = 0
        let numberOfPixels = height * width
        var RGBA : [String : Int]
        
        for y in 0..<height {
            //loop trough image vertically
            for x in 0..<width {
                let index = y * width + x // calculate position in 1-dimensional array of the pixels
                var pixel = pixels[index] // know the exact location within the loop (i.e. index)
                
                // add RGBA values of pixel to total
                totalRed += Int(pixel.red)
                totalGreen += Int(pixel.green)
                totalBlue += Int(pixel.blue)
                totalAlpha += Int(pixel.alpha)
            }
            
        }
        
        RGBA = ["avgRed" : (totalRed / numberOfPixels),
                "avgGreen" : (totalGreen / numberOfPixels),
                "avgBlue" : (totalBlue / numberOfPixels),
                "avgAlpha" : (totalAlpha / numberOfPixels)]

        return RGBA
        
    }
    
}