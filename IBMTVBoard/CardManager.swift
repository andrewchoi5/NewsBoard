//
//  CardDataManager.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-17.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

extension Set {
    
    mutating func insertElementsFromArray(array : [ Element ]) {
        for element in array {
            self.insert(element)
        }
    }
    
}

protocol CardDataClient {
    func updatedWithAddedCards(cards : [ Card ])
    func updatedWithChangedCards(cards : [ Card ])
    func updatedWithDeletedCards(cards: [ Card ])
    
}

class CardDataServer : NSObject {
    
    var currentDeck = Set<Card>()
    var client : CardDataClient?
    var timer : NSTimer!
    
    init(withClient aClient: CardDataClient) {
        super.init()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(CardDataServer.backgroundCheck), userInfo: nil, repeats: true)
        
        client = aClient
    }
    
    func backgroundCheck() {
        ServerInterface.getAllCardsForToday({ (cards) in
            
            
//            if self.currentDeck.contains()
            self.currentDeck.insertElementsFromArray(cards)
//            self.client?.didReceiveNewCards(cards)
            
        })
    }
    
    func sortNewCardList() {
        
    }
    
}