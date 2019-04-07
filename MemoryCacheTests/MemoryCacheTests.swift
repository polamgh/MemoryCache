//
//  MemoryCacheTests.swift
//  MemoryCacheTests
//
//  Created by Macintosh on 1/18/1398 AP.
//  Copyright © 1398 ali ghanavati. All rights reserved.
//

import XCTest
@testable import MemoryCache

class MemoryCacheTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    func testReadWriteCache() {
        let str = "testReadWriteCache"
        let key = "testReadWriteCacheKey"
        CacheMemory.default.setValue(value: str , key: key)
        let cachedString = CacheMemory.default.getValue(key: key, type: String.self)
        
        XCTAssert(cachedString == str)
    }
    func testReadWriteImage() {
        let image = UIColor.orange.image(CGSize(width: 128, height: 128))
        let key = "testReadWriteImageKey"
        
        CacheMemory.default.setValue(value: image, key: key)
        let cachedImage = CacheMemory.default.getValue(key: key, type: UIImage.self)
        
        if  let cachedImage = cachedImage {
            XCTAssert(image.size == cachedImage.size)
        }
        else {
            XCTFail()
        }
    }
    
    func testDataOnMemForKey() {
        let data = "testHasDataOnMemForKey".data(using: String.Encoding.utf8)
        let key = "testHasDataOnMemForKeyKey"
        
        CacheMemory.default.setValue(value: data! , key: key)
        let cacheData = CacheMemory.default.getValue(key: key, type: Data.self)
        
        XCTAssert(cacheData == data)
    }
    
    func testClearDataForKey() {
        let data = "testHasDataOnMemForKey"
        let key = "testHasDataOnMemForKeyKey"
        
        CacheMemory.default.setValue(value: data , key: key)
        CacheMemory.default.cleanAll()
        let cacheData = CacheMemory.default.getValue(key: key, type: String.self)
        
        XCTAssert(cacheData != data)
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}



extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
