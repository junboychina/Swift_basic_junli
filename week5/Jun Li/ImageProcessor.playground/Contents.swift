//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "sample")!

class ImageProcessor {
  var k: Int = 0
  var image: UIImage
  
  init(k: Int, image: UIImage) {
    self.k = k
    self.image = image
  }
  func filters (process: [String]) -> UIImage{
    for filter in process{
      switch filter{
      case "IncreaseRed":
        image = self.IncreaseRed(image)
      case "IncreaseGreen":
        image = self.IncreaseGreen(image)
      case "IncreaseBlue":
        image = self.IncreaseBlue(image)
      case "IncreaseTransparency":
        image = self.IncreaseTransparency(image)
      case "convertToGrayScale":
        image = self.convertToGrayScale(image)
      default:
        print("processor doesn't exist")
      }
    }
    return image
  }
  //get convert the RGBA to GrayScale image
  func convertToGrayScale(image: UIImage) -> UIImage {
    let imageRect:CGRect = CGRectMake(0, 0, image.size.width, image.size.height)
    let colorSpace = CGColorSpaceCreateDeviceGray()
    let width = image.size.width
    let height = image.size.height
    
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.None.rawValue)
    let context = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, colorSpace, bitmapInfo.rawValue)
    
    CGContextDrawImage(context, imageRect, image.CGImage)
    let imageRef = CGBitmapContextCreateImage(context)
    let newImage = UIImage(CGImage: imageRef!)
    
    return newImage
  }
  
  //increase contrast of Red component
  func IncreaseRed ( image : UIImage ) -> UIImage{
    var myRGBA = RGBAImage(image:image)!
    
    var totalRed = 0
    
    for x in 0..<myRGBA.width{
      for y in 0..<myRGBA.height{
        let index = y*myRGBA.width+x
        let pixel = myRGBA.pixels[index]
        totalRed += Int(pixel.red)
      }
    }
    
    let count = myRGBA.width*myRGBA.height
    let avgRed = totalRed/count
    
    for x in 0..<myRGBA.width{
      for y in 0..<myRGBA.height{
        let index = y*myRGBA.width+x
        var pixel = myRGBA.pixels[index]
        let redDiff = Int( pixel.red ) - avgRed
        if redDiff>0 {
          pixel.red = UInt8(max( 0 , min ( 255 , avgRed + redDiff*k )))
          myRGBA.pixels[index] = pixel
        }
      }
    }
    
    let newimage = myRGBA.toUIImage()
    return(newimage)!
  }
  
  //increase contrast of Green component
  func IncreaseGreen ( image : UIImage ) -> UIImage {
    var myRGBA = RGBAImage(image:image)!
    
    var totalGreen = 0
    
    for x in 0..<myRGBA.width{
      for y in 0..<myRGBA.height{
        let index = y*myRGBA.width+x
        let pixel = myRGBA.pixels[index]
        totalGreen += Int(pixel.green)
      }
    }
    
    let count = myRGBA.width*myRGBA.height
    let avgGreen = totalGreen/count
    
    for x in 0..<myRGBA.width{
      for y in 0..<myRGBA.height{
        let index = y*myRGBA.width+x
        var pixel = myRGBA.pixels[index]
        let greenDiff = Int( pixel.green ) - avgGreen
        if greenDiff>0 {
          pixel.green = UInt8(max( 0 , min ( 255 , avgGreen + greenDiff*k )))
          myRGBA.pixels[index] = pixel
        }
      }
    }
    
    let newimage = myRGBA.toUIImage()
    return(newimage)!
  }
  
  //increase contrast of Blue component
  func IncreaseBlue ( image : UIImage ) -> UIImage {
    var myRGBA = RGBAImage(image:image)!
    
    var totalBlue = 0
    
    for x in 0..<myRGBA.width{
      for y in 0..<myRGBA.height{
        let index = y*myRGBA.width+x
        let pixel = myRGBA.pixels[index]
        totalBlue += Int(pixel.blue)
      }
    }
    
    let count = myRGBA.width*myRGBA.height
    let avgBlue = totalBlue/count
    
    for x in 0..<myRGBA.width{
      for y in 0..<myRGBA.height{
        let index = y*myRGBA.width+x
        var pixel = myRGBA.pixels[index]
        let blueDiff = Int( pixel.blue ) - avgBlue
        if blueDiff>0 {
          pixel.blue = UInt8(max( 0 , min ( 255 , avgBlue + blueDiff*k )))
          myRGBA.pixels[index] = pixel
        }
      }
    }
    
    let image = myRGBA.toUIImage()
    return(image)!
  }
  
  //increase contrast of transparent component
  func IncreaseTransparency ( image : UIImage ) -> UIImage {
    var myRGBA = RGBAImage(image:image)!
    
    var totalAlpha = 0
    
    for x in 0..<myRGBA.width{
      for y in 0..<myRGBA.height{
        let index = y*myRGBA.width+x
        let pixel = myRGBA.pixels[index]
        totalAlpha += Int(pixel.alpha)
      }
    }
    
    let count = myRGBA.width*myRGBA.height
    let avgAlpha = totalAlpha/count
    
    for x in 0..<myRGBA.width{
      for y in 0..<myRGBA.height{
        let index = y*myRGBA.width+x
        var pixel = myRGBA.pixels[index]
        let alphaDiff = Int( pixel.alpha ) - avgAlpha
        if alphaDiff>0 {
          pixel.alpha = UInt8(max( 0 , min ( 255 , avgAlpha + alphaDiff*k )))
          myRGBA.pixels[index] = pixel
        }
      }
    }
    
    let newimage = myRGBA.toUIImage()
    return(newimage)!
  }
  
}
//the first instance: get GrayScale Image
var myimage1 = ImageProcessor(k: 8, image: image)
let filter1 = ["convertToGrayScale"]
myimage1.filters(filter1)
myimage1.image

//the second instance: apply filters in specific order
var myimage2 = ImageProcessor(k: 5, image:image)
let filter2 = ["IncreaseRed","IncreaseBlue","IncreaseGreen"]
myimage2.filters(filter2)

//the third instance : try the last filter
var myimage3 = ImageProcessor(k: 4, image:image)
let filter3 = ["IncreaseTransparency"]
myimage3.filters(filter3)
