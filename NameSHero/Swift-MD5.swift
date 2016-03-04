//
//  Swift-MD5.swift
//  NameSHero
//
//  Created by coreylin on 3/3/16.
//  Copyright © 2016 coreylin. All rights reserved.
//

import Foundation

extension String {
  func md5() -> String! {
    let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
    let strLen = CUnsignedInt(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
    let digestLen = Int(CC_MD5_DIGEST_LENGTH)
    let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)

    CC_MD5(str!, strLen, result)

    let hash = NSMutableString()
    for i in 0..<digestLen {
      hash.appendFormat("%02x", result[i])
    }

    result.destroy()

    return String(format: hash as String)
  }
}
