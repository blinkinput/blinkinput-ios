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
    
    class func getPreset() -> [MBIScanElement]? {
        var scanElements = [MBIScanElement]()
        
        let rawElement = MBIScanElement(identifier: "Raw", parser: MBIRawParser())
        rawElement.localizedTitle = "Raw Text"
        rawElement.localizedTooltip = "Scan text"
        scanElements.append(rawElement)
        
        let ibanElement = MBIScanElement(identifier: "IBAN", parser: MBIIbanParser())
        ibanElement.localizedTitle = "IBAN"
        ibanElement.localizedTooltip = "Scan IBAN"
        scanElements.append(ibanElement)
        
        let priceElement = MBIScanElement(identifier: "Price", parser: MBIAmountParser())
        priceElement.localizedTitle = "Amount"
        priceElement.localizedTooltip = "Scan amount to pay"
        scanElements.append(priceElement)
        
        let dateElement = MBIScanElement(identifier: "Date", parser: MBIDateParser())
        dateElement.localizedTitle = "Date"
        dateElement.localizedTooltip = "Scan date"
        scanElements.append(dateElement)
        
        return scanElements
    }
}
