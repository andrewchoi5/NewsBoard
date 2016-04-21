//
//  QRCoder.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-20.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

enum QRStringEncodingScheme {
    case MinimumLossless        // One - one mapping with card, but very long, requires bigger image
    case Lossy                  // Possible, but very unlikely mismatch with another card, more compact
    
}

class QRCoder {
    private static let DefaultEncodingScheme = QRStringEncodingScheme.Lossy
    private let encodedStringLength = 8
    
    private var encodingScheme = QRCoder.DefaultEncodingScheme
    private var encodedString : String!
    
    convenience init(card: Card) {
        self.init(card: card, encodingScheme: QRCoder.DefaultEncodingScheme)
        
    }
    
    init(card : Card, encodingScheme scheme: QRStringEncodingScheme) {
        
        encodingScheme = scheme
        
        switch scheme {
            
            case           .MinimumLossless :  encodedString = minimumLosslessEncodedString(card)
            case           .Lossy :            encodedString = lossyEncodedString(card)
            
        }
    }
    
    init(encodedString string: String) {
        encodedString = string
        encodedString = encodedString.stringByPaddingToLength(encodedStringLength, withString: "0", startingAtIndex: 0)
        
    }
    
    private func lossyEncodedString(card : Card) -> String {
        let type = card.type.rawValue
        
        let ID = card.id
        let rev = card.revision
        
        let IDFragment = ID.substringWithRange(ID.startIndex ..< ID.startIndex.advancedBy( 3 ))
        let revFragment = rev.substringWithRange(ID.startIndex.advancedBy( 2 ) ..< ID.startIndex.advancedBy( 2 + 3 ))
        
        return "\(type)-\(IDFragment)\(revFragment)"
        
    }
    
    private func minimumLosslessEncodedString(card: Card) -> String {
        return card.id

    }
    
    private func queryForLossy() -> CardQuery {
        let type = Int(encodedString.substringWithRange(encodedString.startIndex ..< encodedString.startIndex.successor()))!
        
        let idFrag = encodedString.substringWithRange(encodedString.startIndex.advancedBy( 2 ) ..< encodedString.startIndex.advancedBy( 2 + 3 ))
        let revFrag = encodedString.substringWithRange(encodedString.startIndex.advancedBy( 2 + 3 ) ..< encodedString.startIndex.advancedBy( 2 + 3 + 3 ))
        
        return CardQuery(idFrag, revFrag, type)
        
    }
    
    private func queryForMinimumLossless() -> CardQuery {
        return CardQuery(withID: encodedString)
        
    }
    
    private func queryForEncoding() -> CardQuery {
        if encodingScheme == .Lossy {
            return queryForLossy()
            
        } else {
            return queryForMinimumLossless()
            
        }
    }
    
    func getEncodedCard(completion: ( Card? ) -> Void) {
        ServerInterface.getCards(withQuery: queryForEncoding()) { (cards) in
            guard let card = cards.first else { return }
            completion(card)
            
        }
        
    }
    
    func encodedImage() -> UIImage? {
        return encodedString.encodedQRImage()
        
    }
    
}

extension CardQuery {
    
    convenience init(_ IDFrag: String, _ revFrag: String, _ type: Int) {
        self.init()
        
        self.addSelector("_id", .GreaterThan, 0)
        self.selectors["_id"] = [  QueryComparatorOperator.GreaterThan.rawValue : 0, "$regex" : "^\(IDFrag)" ]
        self.selectors["_rev"] = [ "$regex" : "^[0-9]*[-]\(revFrag)" ] // 
        self.addSelector("card.type", .Equals, type)
    }
    
}