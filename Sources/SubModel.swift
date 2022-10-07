//
//  SubModel.swift
//  MTIAPurchase
//
//  Created by Minh Tường on 07/10/2022.
//

public struct SubModel {
    public let name: String
    public let keyID: String
    public let description: String
    public let selected: Bool
    public let isSubscription: Bool
    public let sort: Int
    
    public init(name: String, keyID: String, description: String, selected: Bool, isSubscription: Bool, sort: Int) {
        self.name = name
        self.keyID = keyID
        self.description = description
        self.selected = selected
        self.isSubscription = isSubscription
        self.sort = sort
    }
}
