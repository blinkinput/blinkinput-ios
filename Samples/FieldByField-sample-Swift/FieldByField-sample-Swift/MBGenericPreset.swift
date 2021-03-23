//
//  MBGenericPreset.swift
//  FieldByField-sample-Swift
//
//  Created by Jura Skrlec on 10/05/2018.
//  Copyright © 2018 Jura Skrlec. All rights reserved.
//

import Foundation
import BlinkInput

class MBGenericPreset {
    
    class func getPreset() -> [MBINScanElement]? {
        var scanElements = [MBINScanElement]()
        
        let rawElement = MBINScanElement(identifier: "Raw", parser: MBINRawParser())
        rawElement.localizedTitle = "Raw Text"
        rawElement.localizedTooltip = "Scan text"
        scanElements.append(rawElement)
        
        let ibanElement = MBINScanElement(identifier: "IBAN", parser: MBINIbanParser())
        ibanElement.localizedTitle = "IBAN"
        ibanElement.localizedTooltip = "Scan IBAN"
        scanElements.append(ibanElement)
        
        let priceElement = MBINScanElement(identifier: "Price", parser: MBINAmountParser())
        priceElement.localizedTitle = "Amount"
        priceElement.localizedTooltip = "Scan amount to pay"
        scanElements.append(priceElement)
        
        let dateElement = MBINScanElement(identifier: "Date", parser: MBINDateParser())
        dateElement.localizedTitle = "Date"
        dateElement.localizedTooltip = "Scan date"
        scanElements.append(dateElement)
        
        return scanElements
    }
}
