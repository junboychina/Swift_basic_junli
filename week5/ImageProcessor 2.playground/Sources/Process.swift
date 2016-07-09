import Foundation
import UIKit


public class ProcessImage {
    
    var filtersToRun: [String] = []
    var inputImage: UIImage?
    var workingImage: RGBAImage?
    
    //set up the class, add the image to use
    public init?(image: UIImage) {
        filtersToRun.removeAll()
        inputImage = image
        workingImage = RGBAImage(image: image)
    }
    
    public func Go() {
 
        //loop through the requested filters
        for filter in filtersToRun {
            //split the string that was passed, and take the first two items (assumes the first is a filter instruction and the second is an intensity for that filter)
            let allFilters = filter.characters.split {$0 == " "}.map { String($0) }
            var firstFilter: String = ""
            firstFilter = allFilters[0]
            var secondFilter: String = ""
            secondFilter = allFilters.count > 1 ? allFilters[1] : "" //possible the user doesn't pass a second filter, we'll use a default in the function
            
            
            //for each filter, loop through each pixel, applying the filters as we go
            for y in 0..<(workingImage?.height)! {
                for x in 0..<(workingImage?.width)! {
                    let index = y * (workingImage?.width)! + x

                    //figure out which function was called, and call it
                    switch (firstFilter) {
                        case "Bright": workingImage?.pixels[index] = Bright((workingImage?.pixels[index])!, intensity: secondFilter)
                        case "Contrast": workingImage?.pixels[index] = Contrast((workingImage?.pixels[index])!, intensity: secondFilter)
                        case "SwapRedGreen": workingImage?.pixels[index] = SwapRedGreen((workingImage?.pixels[index])!)
                        case "TintBlue": workingImage?.pixels[index] = TintBlue((workingImage?.pixels[index])!, intensity: secondFilter)
                        case "Fuzz": workingImage?.pixels[index] = Fuzz((workingImage?.pixels[index])!, inputImage: workingImage!, x: x, y: y, intensity: secondFilter)
                    default: break
                    }
                }
            }
        }
    }
    
    public func AddFilter(filter: String) {
        //append whatever string was passed to the filters
        filtersToRun.append(filter)
    }
    
    public func ShowResult() -> UIImage? {
        //convert the image to a UIImage and return it
        return workingImage?.toUIImage()
    }
    

}