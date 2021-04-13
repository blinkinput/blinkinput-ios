//
//  MBCroatianIDTemplateUtils.swift
//  Templating-sample-swift
//
//  Created by Jura Skrlec on 10/05/2018.
//  Copyright © 2018 Microblink. All rights reserved.
//

import UIKit
import BlinkInput

class MBCroatianIDTemplateUtils: NSObject {
    
    class func croatianCharsWhitelist() -> Set<MBIOcrCharKey> {
        // initialize new char whitelist
        var charWhitelist = Set<MBIOcrCharKey>()
        // Add chars 'A'-'Z'
        for val in UnicodeScalar("A").value...UnicodeScalar("Z").value {
            charWhitelist.insert(MBIOcrCharKey(code: Int32(val), font: MBIOcrFont.MB_OCR_FONT_ANY))
        }
        
        charWhitelist.insert(MBIOcrCharKey(code: Int32(UnicodeScalar("Š").value), font:  MBIOcrFont.MB_OCR_FONT_ANY))
        charWhitelist.insert(MBIOcrCharKey(code: Int32(UnicodeScalar("Ž").value), font:  MBIOcrFont.MB_OCR_FONT_ANY))
        charWhitelist.insert(MBIOcrCharKey(code: Int32(UnicodeScalar("Č").value), font:  MBIOcrFont.MB_OCR_FONT_ANY))
        charWhitelist.insert(MBIOcrCharKey(code: Int32(UnicodeScalar("Ć").value), font:  MBIOcrFont.MB_OCR_FONT_ANY))
        charWhitelist.insert(MBIOcrCharKey(code: Int32(UnicodeScalar("Đ").value), font:  MBIOcrFont.MB_OCR_FONT_ANY))
        
        return charWhitelist
    }

}
