//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "sample")

// Process the image!



// Work by Dave

// extending a few missing things from Pixel
extension Pixel {
    init() {
        value = 0
    }
    
    init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8 = 255) {
        value = 0
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    init(red: UInt32, green: UInt32, blue: UInt32, alpha: UInt8 = 255) {
        value = 0
        self.red = UInt8(min(red, 255))
        self.green = UInt8(min(green, 255))
        self.blue = UInt8(min(blue, 255))
        self.alpha = alpha
    }
    
    init(red: Double, green: Double, blue: Double, alpha: UInt8 = 255) {
        value = 0
        self.red = UInt8(min(red, 255.0))
        self.green = UInt8(min(green, 255.0))
        self.blue = UInt8(min(blue, 255.0))
        self.alpha = alpha
    }
}


protocol Filter {
    func run(pixel: Pixel) -> Pixel
}

// requirement #4
// Create five reasonable default Filter configurations (e.g. "50% Brightness”, “2x Contrast”),
// and provide an interface to access instances of such defaults by name

class GrayscaleFilter : Filter {
    func run(pixel: Pixel) -> Pixel {
        let average: UInt32 = (UInt32(pixel.red) + UInt32(pixel.green) + UInt32(pixel.blue)) / 3
        return Pixel(red: average, green: average, blue: average, alpha: pixel.alpha)
    }
}

class RemoveAlphaFilter : Filter {
    func run(pixel: Pixel) -> Pixel {
        return Pixel(red: pixel.red, green: pixel.green, blue: pixel.blue)
    }
}

class FactorFilter : Filter {
    var factor = 1.0        // do nothing
    
    func run(pixel: Pixel) -> Pixel {
        let red = Double(pixel.red) * factor
        let green = Double(pixel.green) * factor
        let blue = Double(pixel.blue) * factor
        return Pixel(red: red, green: green, blue: blue, alpha: pixel.alpha)
    }
}

class DarkenFilter : FactorFilter {
    init(factor: Double = 0.75) {
        super.init()
        self.factor = factor
    }
}

class LightenFilter : FactorFilter {
    init(factor: Double = 1.25) {
        super.init()
        self.factor = factor
    }
}

class InvertFilter : Filter {
    func run(pixel: Pixel) -> Pixel {
        return Pixel(red: 255 - pixel.red, green: 255 - pixel.green, blue: 255 - pixel.green, alpha: pixel.alpha)
    }
}


class InstaFilter {
    
    // process a single filter
    func process(image: UIImage, filter: Filter) -> UIImage? {
        // call the pipeline function with a single filter
        return process(image, filters: [filter])
    }
    
    // process a pipeline of filters
    func process(image: UIImage, filters: [Filter]) -> UIImage? {
        
        if var rgba = RGBAImage(image: image) {
            // iterate each row
            for y in 0 ..< rgba.height {
                // iterate each pixel in row
                for x in 0 ..< rgba.width {
                    // apply the list of filters to the pixel
                    let pixelIndex = rgba.height * y + x
                    var pixel = rgba.pixels[pixelIndex]
                    for filter in filters {
                        pixel = filter.run(pixel)
                    }
                    rgba.pixels[pixelIndex] = pixel
                }
            }
            return rgba.toUIImage()
        }
        // on an error in RGBAImage, return nil image
        return nil
    }
    
    // requirement #5
    // In the ImageProcessor interface create a new method to apply a predefined filter giving its name as a String parameter.
    // The ImageProcessor interface should be able to look up the filter and apply it.

    // filter by simple string
    func process(image: UIImage, filterName: String) -> UIImage? {
        
        switch filterName {
        case "grayscale":
            return process(image, filter: GrayscaleFilter())
        case "removeAlpha":
            return process(image, filter: RemoveAlphaFilter())
        case "darken":
            return process(image, filter: DarkenFilter())
        case "lighten":
            return process(image, filter: LightenFilter())
        case "invert":
            return process(image, filter: InvertFilter())
        default:
            return nil
        }
    }
}


let filter = InstaFilter()

if let image = image {

    filter.process(image, filterName: "grayscale")
    
    filter.process(image, filterName: "removeAlpha")

    filter.process(image, filterName: "darken")

    filter.process(image, filterName: "lighten")

    filter.process(image, filterName: "invert")
    // ensure an empty filter list works OK
    filter.process(image, filters: [])
    // test the pipeline
    filter.process(image, filters: [RemoveAlphaFilter(), GrayscaleFilter(), DarkenFilter(factor: 0.5)])

}
else {
    print("no images to process")
}
