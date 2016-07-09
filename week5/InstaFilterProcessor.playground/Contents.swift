//: Playground - noun: a place where people can play

import UIKit



// ******************************************************************
// Description
// Applies the following filters on a given image:
//  1) Mean Filter
//      Given a pixel, calculate the average of its 8 neighbors and itself
//
//  2) Median Filter
//      Given a pixel, calculate the median of its 8 neighbors and itself
//
//  3) Linear Filter
//      Given a pixel, calculate the weighted average of its 8 neighbors and itself
//
//  4) High Pass Filter
//      Reset a pixel value to 0 unless it is greater than a given threshold
//
//  5) Low Pass Filter
//      Reset a pixel value to 0 unless it is less than a given threshold
//
//  6) Mirror Filter
//      Create the mirror image of a given image
//
//  7) Convolution Filter
///     Create a convolution of a given image with another input matrix

// Usage Model
// Modify the run() method as follows:
// Create a filter object
// Set filter properties
// Execute the filters
// Example execution is provided
// ******************************************************************





class Filter {
    //*********************** Variables *****************************
    var m_convolutionMatrix : [[Float]] = []
    var m_weights           : [Float]   = []
    var m_filterList        : [String!] = []
    var m_threshold         : [UInt8]   = []
    var m_segment           : [Int]     = []
    
    
    
    required init(convMatrix:[[Float]] = [], weights:[Float] = [],
        filters:[String!] = [], threshold : [UInt8] = [100,100,100],
        segment : [Int] = []) {
        // Set the parameters needed
        self.m_convolutionMatrix = convMatrix
        self.m_weights           = weights
        self.m_threshold         = threshold
        self.m_filterList        = filters
        self.m_segment           = segment
    }
    
    // Setter for parameters
    private func setConvolutionMatrix(convMatrix : [[Float]]) {
        m_convolutionMatrix = convMatrix
    }
    private func setWeights(weights : [Float]) {
        m_weights = weights
    }
    private func setThreshold(threshold : [UInt8]) {
        m_threshold = threshold
    }
    
    private func setSegment(segment : [Int]) {
        m_segment = segment
    }
    
    // This function will register all the filters that need to be 
    // run on an image. All it does is set up an array of string,
    // where each string represents a filter
    private func setFilterList(filterList:[String!]) {
        m_filterList = filterList
    }
    
    // Return the x and y boundaries for an image. The filter is only applied 
    // on the segment of the image
    private func getImageSegment(rgbAImage:RGBAImage) -> [Int] {
        var xMin, xMax, yMin, yMax : Int
        if (m_segment == []) {
            xMin = 0
            xMax = rgbAImage.width
            yMin = 0
            yMax = rgbAImage.height
        } else {
            xMin = m_segment[0]
            xMax = m_segment[1]
            yMin = m_segment[2]
            yMax = m_segment[3]
        }
        return ([xMin,xMax,yMin,yMax])
    }
    
    //*********************** Helper Functions **********************
    //**** Use this section to implement helper functions that will be
    //     used across several filters

    // A helper function to return the neighbors in one dimension
    //    Input: A location in X or Y dimension, the length over which
    //           the neighbors are requested, and the size of the
    //           image in the given dimension

    //    Output:A tuple consisting of the locations of the neighboring
    //           pixels

    //    Examples: if loc = 3, size = 8, len = 2, output will be
    //              [1,2,4,5]
    //              if loc = 3, size = 8, len = 4, output will be
    //              [1,2,4,5,6,7]
    //              if loc = 6, size = 8, len = 4, output will be
    //              [2,3,4,5,7]
    //              if loc = 4, size = 8, len = 2, output will be
    //              [2,3,5,6]
    private func getOneDimNeighbor(loc:Int, len:Int, size:Int) -> [Int] {
        var oneDTuple : [Int] = []
        oneDTuple.append(loc)
        if (loc < Int(len/2)) {
            for i in 0..<loc {
                oneDTuple.append(i)
            }
            for i in loc..<loc + Int(len/2) {
                oneDTuple.append(loc+i)
            }
        } else if (loc + Int(len/2) > size) {
            for i in loc..<size {
                oneDTuple.append(i)
            }
        
            for i in 0..<Int(len/2) {
                oneDTuple.append(loc - i)
            }
        } else {
            for i in Int(loc-len/2)..<loc {
                oneDTuple.append(i)
            }
            for i in loc..<Int(loc+len/2) {
                oneDTuple.append(i)
            }
        }
        return oneDTuple
    }

    // A helper function to return the neighboring pixel locations
    //    Input: X and Y location of a pixel, width and height of the image,
    //           the length of the neighbors in x and y directions

    //    Output:A list of doubles, where each double represents the location
    //          of a pixel, and the list denotes the list of pixels 
    //          constituting the neighbors.

    //    Examples: if x = 3, width = 8, xlen = 2, y = 3, height = 8, len = 2,
    //              output will be
    //              [[1,1],[1,2],[1,4],[1,5],[2,1],[2,2],[2,4],[2,5],
    //               [4,1],[4,2],[4,4],[4,5],[5,1],[5,2],[5,4],[5,5]]
    //
    private func getNeighbors(x:Int, y:Int, width:Int, height:Int, xLen:Int = 3, yLen:Int = 3) -> [[Int]]
    {
        var xTuple : [Int] = []
        var yTuple : [Int] = []
        var neighborhood: [[Int]] = []
        if (width == 0 || height == 0) {
            // return an empty array as width or height cannot be 0
            return [[]]
        }
        
        
        xTuple = getOneDimNeighbor(x, len: xLen, size: width)
        yTuple = getOneDimNeighbor(y, len: yLen, size: height)
        let xTupleSorted = xTuple.sort()
        let yTupleSorted = yTuple.sort()
        for i in 0..<xTupleSorted.count {
            for j in 0..<yTupleSorted.count {
                neighborhood.append([xTupleSorted[i], yTupleSorted[j]])
            }
        }
        return neighborhood
    }

    // Given an image and neighbors, get the list of red, blue and green
    // color values
    private func getNeighboringPixels(neighbors : [[Int]], rgbAImage : RGBAImage, inout nRed : [UInt8], inout nBlue : [UInt8], inout nGreen : [UInt8]) {
        for i in 0..<neighbors.count {
        
            let nx     = neighbors[i][0]
            let ny     = neighbors[i][1]
            let nloc   = ny + nx * rgbAImage.height
            let npixel = rgbAImage.pixels[nloc]
            nRed.append(npixel.red)
            nBlue.append(npixel.blue)
            nGreen.append(npixel.green)
        }
    }


    // Given an array of color vlaues in UInt8 values, return the median
    //    Input: A list of one color value of pixels.
    //    Output:Median of this list.

    //    Examples: if a list of pixels of red component given be [4,3,5,2,8]
    //              output will be 5

    //              if a list of pixels of red component given be [14,3,15,2]
    //              output will be floor(avg(3,14)) = 8
    //
    private func calcMedian(colors: [UInt8]) -> UInt8 {
        let sortedColors  = colors.sort()
        var median:UInt8  = 0
        let count = sortedColors.count
        if sortedColors.count % 2 == 0 {
            let count = sortedColors.count
            let lowVal  : UInt8 = sortedColors[count/2]
            let highVal : UInt8 = sortedColors[(count/2)+1]
            
            let medInt : Int = (Int(lowVal) + Int(highVal)) >> 1
            median = UInt8(medInt)
        }else {
            median = sortedColors[((count - 1)/2) + 1]
        }
        return median
    }



    // Given an array of color vlaues in UInt8 values, return the mean
    //    Input: A list of one color value of pixels.
    //    Output:Median of this list.

    //    Examples: if a list of pixels of red component given be [4,3,5,2,8]
    //              output will be floor(22/5) = 4

    //              if a list of pixels of red component given be [14,3,15,2]
    //              output will be floor(34/5) = 6
    //

    private func calcMean(colors: [UInt8], weights : [Float]) -> UInt8 {
        var meanVal : UInt8 = 0
        
        var meanValInt : Int = 0
        var meanValFloat : Float = 0.0
        var weightCount : Int = 0
        
        assert(colors.count <= weights.count, "In Calculating Mean, weight should be given to every neighbor.")
        
        for i in 0..<colors.count {
            var temp : Float = 0.0
            temp = Float(colors[i])*weights[i]
            meanValFloat = temp + meanValFloat
            weightCount = weightCount + Int(weights[i])
        }
        if (weightCount > 0) {
            meanValInt = Int(meanValFloat/Float(weightCount))
        }
        meanVal    = UInt8(meanValInt)
        return meanVal
    }


    // Mean or Median Filter
    // For each pixel, examine its neighborhood.
    // Sort the neighbors, and pick the mean or median value.
    //    Input: A UIImage, an option that is mean, or median, and weights for
    //           weighted mean calculation.

    //    Output: Median or weighted mean as per the option
    private func MeanMedianFilter(image:UIImage, option:String, weights:[Float]) -> UIImage {
        let rgbAImage = RGBAImage(image: image)!
        var filteredRgbAImage = rgbAImage
        let thisSegment : [Int]
        thisSegment = getImageSegment(rgbAImage)
        for x in thisSegment[0]..<thisSegment[1] {
            for y in thisSegment[2]..<thisSegment[3] {
                
                var neighbors:[[Int]]
                neighbors = getNeighbors(x,y:y,width: rgbAImage.width,height: rgbAImage.height)
            
                
                var nRed   : [UInt8]
                var nBlue  : [UInt8]
                var nGreen : [UInt8]
                nRed   = []
                nBlue  = []
                nGreen = []
                
                getNeighboringPixels(neighbors, rgbAImage: rgbAImage, nRed: &nRed, nBlue: &nBlue, nGreen: &nGreen)
                var redOut   :UInt8  = 0
                var blueOut  :UInt8  = 0
                var greenOut :UInt8  = 0
                
                if option == "Median" {
                    redOut   = calcMedian(nRed)
                    blueOut  = calcMedian(nBlue)
                    greenOut = calcMedian(nGreen)
                } else if option == "Mean" {
                    var meanWeights: [Float] = [1,1,1,1,1,1,1,1,1]
                    if (weights != []) {
                        meanWeights  = weights
                    }
                    redOut   = calcMean(nRed,   weights:meanWeights)
                    blueOut  = calcMean(nBlue,  weights:meanWeights)
                    greenOut = calcMean(nGreen, weights:meanWeights)
                }
            
                let loc = y + x * rgbAImage.height
                var pixel = rgbAImage.pixels[loc]
            
                pixel.red   = redOut
                pixel.blue  = blueOut
                pixel.green = greenOut
            
                filteredRgbAImage.pixels[loc] = pixel
            }
        }

        return filteredRgbAImage.toUIImage()!
    }

//***************************BEGIN FILTER IMPLEMENTATION **********************

    //*** Use this section to implement new filters, and

    // Median Filter
    // For each pixel, examine its neighborhood.
    // Pick the median value among the neighbors.
    private func MedianFilter(image:UIImage) -> UIImage {
        let weights:[Float] = []
        return MeanMedianFilter(image, option: "Median", weights:weights)
    }

    // Mean Filter
    // For each pixel, examine its neighborhood.
    // Pick the mean value among the neighbors.
    private func MeanFilter(image:UIImage) -> UIImage {
        let weights:[Float] = []
        return MeanMedianFilter(image, option: "Mean", weights:weights)
    }

    // Linear Filter
    // For each pixel, examine its neighborhood.
    // Perform (A(X-1)*X(-1) + A(X+1)*X(+1)...)/NumNeighbors
    private func LinearFilter(image:UIImage) -> UIImage {
        let weights : [Float] = m_weights
        return MeanMedianFilter(image, option: "Mean", weights:weights)
    }

    // For each pixel, if the value is greater/less than a threshold,
    // keep it. Otherwise, zero it out
    private func PassFilter(image:UIImage, pass : String = "High") -> UIImage {
        let rgbAImage = RGBAImage(image: image)!
        var filteredRgbAImage = rgbAImage
        let threshold : [UInt8] = m_threshold
        if threshold.count == 0 {
            return filteredRgbAImage.toUIImage()!
        }

        let thisSegment : [Int]
        thisSegment = getImageSegment(rgbAImage)
        for x in thisSegment[0]..<thisSegment[1] {
            for y in thisSegment[2]..<thisSegment[3] {
                let loc = y + x * rgbAImage.height
                var pixel = rgbAImage.pixels[loc]
                if ((pixel.red < threshold[0] && pass == "High") ||
                    (pixel.red > threshold[0] && pass == "Low")) {
                    pixel.red   = 0
                }
                if ((pixel.blue < threshold[1] && pass == "High") ||
                    (pixel.blue > threshold[1] && pass == "Low")) {
                    pixel.blue  = 0
                }
                if ((pixel.green < threshold[2] && pass == "High") ||
                    (pixel.green > threshold[2] && pass == "Low")) {
                    pixel.green = 0
                }
            
                filteredRgbAImage.pixels[loc] = pixel
            }
        }
    
        return filteredRgbAImage.toUIImage()!

    }

    // High pass filter
    // For each pixel, if the value is greater than a threshold,
    // keep it. Otherwise, zero it out
    private func HighPassFilter(image:UIImage) -> UIImage {
        return PassFilter(image, pass: "High")
    }

    
    // Low pass filter
    // For each pixel, if the value is less than a threshold,
    // keep it. Otherwise, zero it out
    private func LowPassFilter(image:UIImage) -> UIImage {
        return PassFilter(image, pass: "Low")
    }
    

    // General convolution filter
    // Return a image where each pixel is multiplied by the corresponding
    // value in the convolution matrix
    private func ConvolutionFilter(image:UIImage) -> UIImage {
        let rgbAImage = RGBAImage(image: image)!
        var filteredRgbAImage = rgbAImage
        let convolutionMatrix : [[Float]] = m_convolutionMatrix
        // if convolution matrix is empty, return the original image
        if convolutionMatrix.count == 0 || convolutionMatrix == [[]] {
            return filteredRgbAImage.toUIImage()!
        }
        let thisSegment : [Int]
        thisSegment = getImageSegment(rgbAImage)
        for x in thisSegment[0]..<thisSegment[1] {
            for y in thisSegment[2]..<thisSegment[3] {
                let loc = y + x * rgbAImage.height
                var pixel = rgbAImage.pixels[loc]
                var temp : Float = 0.0
                temp = min(255, Float(pixel.red) * convolutionMatrix[x][y])
                pixel.red   = UInt8(temp)
                temp = min(255, Float(pixel.blue) * convolutionMatrix[x][y])
                pixel.blue  = UInt8(temp)
                temp = min(255, Float(pixel.green) * convolutionMatrix[x][y])
                pixel.green = UInt8(temp)

                filteredRgbAImage.pixels[loc] = pixel
            }
        }
        return filteredRgbAImage.toUIImage()!
    }
    
    private func MirrorFilter(image:UIImage) -> UIImage {
        let rgbAImage = RGBAImage(image: image)!
        var filteredRgbAImage = rgbAImage
        let thisSegment : [Int]
        
        thisSegment = getImageSegment(rgbAImage)
        for x in thisSegment[0]..<thisSegment[1] {
            for y in thisSegment[2]..<thisSegment[3] {
                let loc    = y + x * rgbAImage.height
                let newX   = x
                let newY   = rgbAImage.height - y - 1
                let outLoc = newY + newX * rgbAImage.height
                let pixel = rgbAImage.pixels[loc]
                filteredRgbAImage.pixels[outLoc] = pixel
            }
        }
        return filteredRgbAImage.toUIImage()!
    }
    
    private func executeThisFilter(image : UIImage, filterName : String) -> UIImage {
        var outImage : UIImage
        switch filterName {
            case "MedianFilter":
                outImage = MedianFilter(image)
            case "MeanFilter":
                outImage = MeanFilter(image)
            case "LinearFilter":
                outImage = LinearFilter(image)
            case "HighPassFilter":
                outImage = HighPassFilter(image)
            case "LowPassFilter":
                outImage = LowPassFilter(image)
            case "ConvolutionFilter":
                outImage = ConvolutionFilter(image)
            case "MirrorFilter":
                outImage = MirrorFilter(image)
            default:
                outImage = image
            
            
        }
        return outImage
    }
    
    private func consistencyCheck(rgbAImage : RGBAImage) -> BooleanType {
        // 1) Weights should be either empty, or 9 entries
        if (m_weights.count != 9 && m_weights.count != 0) {
            print ("Weights must have exactly 9 entries")
            return false
        }
        // 2) If segment is bigger than the image, return false
        if (m_segment.count > 0 && (m_segment[1] > rgbAImage.width || m_segment[3] > rgbAImage.height)) {
            print ("Segment cannot be greater than the image size")
            return false
        }
        // 3) Segment should be of low high low high structure
        if (m_segment.count > 0 && (m_segment[1] <= m_segment[0] || m_segment[3] <= m_segment[2])) {
            print ("Segment is specified as Ylow, Yhigh, Xlow, Xhigh format. Yhigh - Ylow should be at least 1, and Xhigh - Xlow must be at least 1")
            return false
        }
        // 4) Segment must have exactly four values or no values
        if (m_segment.count > 0 && m_segment.count != 4) {
            print ("Segment must be of exactly 4 entries: Ylow, Yhigh, Xlow, Xhigh")
            return false
        }
        
        // 5) Threshold must be exactly 3 entries or none
        if (m_threshold.count > 0 && m_threshold.count != 3) {
            print ("Threshold must be of exactly 3 entries: Reg, Blue, Green")
            return false
        }
        
        // 6) Convolution matrix must be none or exactly size of the image
        if (m_convolutionMatrix != [[]] && m_convolutionMatrix.count != rgbAImage.width){
            print ("Convolution matrix must be exactly the size of the image")
            return false
        } else if (m_convolutionMatrix != [[]]) {
            for i in 0..<m_convolutionMatrix.count {
                if (m_convolutionMatrix[i].count !=  rgbAImage.height) {
                    print ("Convolution matrix must be exactly the size of the image")
                    return false
                }
            }
        }
        
        return true
    }

    // Here, we read the filter list, and execute the filters one by one
    func executeFilters(image:UIImage) -> UIImage {
        var outImage : UIImage
        outImage = image
        print ("Filter List = ", m_filterList)
        for i in 0..<m_filterList.count {
            let filterName : String =  m_filterList[i]
            print ("Executing Filter ", filterName)
            outImage = executeThisFilter(outImage,filterName: filterName)
        }
        return outImage
    }
    
    func setFilterProperties(image : UIImage,
                             filterList:  [String!]   = ["MedianFilter"],
                             weights:     [Float]     = [1,1,1,1,1,1,1,1,1],
                             segment:     [Int]       = [],
                             threshold :  [UInt8]     = [],
                             convMatrix : [[Float]]   = [[]]) -> BooleanType {
        
        let rgbAImage = RGBAImage(image: image)!
        // Set all filter properties here:
        // 1) Set the filters. Default is MedianFilter
        //    Options are: MedianFilter, MeanFilter, HighPassFilter, LowPassFilter,
        //              ConvolutionFilter, LinearFilter, MirrorFilter
        //    More than one filter can be specified by just appending to the list
        //    For example, to run MedianFilter followed by a convolution filter,
        //    we filterObject.setFilterList(["MedianFilter", "ConvolutionFilter"])
        setFilterList(filterList)
        
        // 2) Set the weights for mean or linear filter. Weights are float values.
        //  The weights must be 9 entries, as at this moment we only support the
        //  nearest neighboring pixels to calculate the mean
        setWeights(weights)
        
        // 3) Set the filter segment. A segment is the portion of the image on which
        //    the filter needs to be applied.
        //    Given a rectangle, (X0,Y0)---------------(X1,Y0)
        //                          |                     |
        //                          |                     |
        //                          |                     |
        //                          |                     |
        //                       (X0,Y1)---------------(X1,Y1)
        //    segment is defined as [Y0, Y1, X0, X1]
        setSegment(segment)
        
        // 4) Set a threshold. The threshold is only used for HighPass/LowPass filters
        //    The threshold consists of three values:
        //    [Red threshold, Blue threshold, Green threshold]
        setThreshold(threshold)
        
        // 5) Set the convolution matrix. This is only needed for convolution filter.
        //    The convolution matrix must be exactly the size of the input image, or
        //    the matrix needs to be empty (default)
        setConvolutionMatrix(convMatrix)
                                
        return consistencyCheck(rgbAImage)
    }

}


//************************ END Filter Section *********************************


//************************ Run Section ****************************************
// Use this section to run different filters

func run() {
    // Create the class object
    let filterObject = Filter(convMatrix: [[]], weights: [], filters: ["MedianFilter"], threshold: [], segment : [])

    // Read the image
    let image    = UIImage(named: "sample")!
    image
    let rgbAImage = RGBAImage(image: image)!
    
    
    // Set all filter properties here:
    // This section can be executed from within a for loop to update filter 
    // params and call the filters iteratively
    
    // 1) Set the filters. Default is MedianFilter
    //    Options are: MedianFilter, MeanFilter, HighPassFilter, LowPassFilter,
    //              ConvolutionFilter, LinearFilter, MirrorFilter
    //    More than one filter can be specified by just appending to the list
    //    For example, to run MedianFilter followed by a convolution filter,
    //    we filterObject.setFilterList(["MedianFilter", "ConvolutionFilter"])
    //let filterList:[String!] = ["MirrorFilter", "LowPassFilter"]//, "ConvolutionFilter"]
    var filterList:[String!] = ["HighPassFilter", "MirrorFilter", "ConvolutionFilter"]
    //filterList               = ["LinearFilter","HighPassFilter"]
    // 2) Set the weights for mean or linear filter
    //  The weights must be 9 entries, as at this moment we only support the
    //  nearest neighboring pixels to calculate the mean
    // Weights are provided in the following order of pixels
    // [(Xlow,Ylow), (Xlow, Y), (Xlow, Yhigh), (Xhigh,Ylow), (Xhigh, Y), (Xhigh, Yhigh)],
    let weights:[Float]     = [0.1,10,0.1,0.1,0.1,0.1,0.1,0.1,0.1]
   
    
    // 3) Set the filter segment. A segment is the portion of the image on which
    //    the filter needs to be applied.
    //    Given a rectangle, (X0,Y0)---------------(X1,Y0)
    //                          |                     |
    //                          |                     |
    //                          |                     |
    //                          |                     |
    //                       (X0,Y1)---------------(X1,Y1)
    //    segment is defined as [Y0, Y1, X0, X1]
    var segment:[Int]       = []
    
    // Mean, Median and Linear filters are compute intensive. It is highly recommended
    // to set up a segment of the image to apply these filters
    segment                 = [25,50,25,50]
    
    // 4) Set a threshold. The threshold is only used for HighPass/LowPass filters
    //    The threshold consists of three values:
    //    [Red threshold, Blue threshold, Green threshold]
    var threshold:[UInt8]   = []
    threshold               = [120,220,10]
    
    // 5) Set the convolution matrix. This is only needed for convolution filter.
    //    The convolution matrix must be exactly the size of the input image, or
    //    the matrix needs to be empty (default)
    var convMatrix: [[Float]] = []
    for _ in 0..<rgbAImage.width {
        convMatrix.append([])
    }
    for i in 0..<rgbAImage.width {
        for _ in 0..<rgbAImage.height {
            convMatrix[i].append((Float(random()%100)/100.0) * 2.0)
        }
    }
    
    // Reset the convolution matrix
    // convMatrix = [[]]
    // Set the filter properties and execute the filters
    if (filterObject.setFilterProperties(image, filterList: filterList, weights: weights, segment: segment, threshold: threshold, convMatrix: convMatrix)) {
        let newImage : UIImage = filterObject.executeFilters(image)
        newImage
    }
    
    // Executes the filters with default values.
    //if (filterObject.setFilterProperties(image,segment:segment)) {
    //    let newImage : UIImage = filterObject.executeFilters(image)
    //    newImage
    //}
    
}


run()
