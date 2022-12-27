//
//  SubModel.swift
//  MTIAPurchase
//
//  Created by Minh Tường on 07/10/2022.
//

public protocol SubModel {
    var name: String {get set}
    var keyID: String {get set}
    var description: String {get set}
    var selected: Bool {get set}
    var isSubscription: Bool {get set}
    var sort: Int {get set}
}
