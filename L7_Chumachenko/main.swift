//
//  main.swift
//  L7_Chumachenko
//
//  Created by Александр Чумаченко on 30.03.2021.
//
import Foundation

struct Item {
    var price: Int
    var count: Int
    let product: Product
}

struct Product {
    let name: String
}

enum DealerError: Error {
    case notEnoughMoney(moneyNeeded: Int)
    case notAvailable
    case invalidItem
    
    var localizedDescription: String {
        switch self {
        case .invalidItem:
            return "Такой автомобиль не продаётся в данном автосалоне"
        case .notAvailable:
            return "Автомобиля нет в наличии"
        case .notEnoughMoney(moneyNeeded: let moneyNeeded):
            return "Недостаточно средств: \(moneyNeeded)"
        }
    }
}

//MARK: - Error

class LexusDealer {
    
    
    var inventory = [
        "ES 250": Item(price: 3000000, count: 3, product: Product(name: "ES 250")),
        "LS 500": Item(price: 7000000, count: 1, product: Product(name: "LS 500")),
        "LX 570": Item(price: 7600000, count: 5, product: Product(name: "LX 570")),
        "IS 250": Item(price: 2400000, count: 0, product: Product(name: "IS 250"))
    ]
    
    var deposit = 0
    
    func topupDeposit(on topup: Int) { deposit += topup }
    
    func saleLexus(itemNamed name: String) -> (product: Product?, error: String) {
        guard let item = inventory[name] else {
            return (product: nil, error: DealerError.invalidItem.localizedDescription)
        }
        
        guard item.count > 0 else {
            return (product: nil, error: DealerError.notAvailable.localizedDescription)
        }
        
        guard item.price <= deposit else {
            return (product: nil, error: DealerError.notEnoughMoney(moneyNeeded: item.price - deposit).localizedDescription)
        }
        
        deposit -= item.price
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        return (product: newItem.product, error: "")
    }
}

let lexusIsmaylovo = LexusDealer()
lexusIsmaylovo.topupDeposit(on: 2400000)
let sellES250 = lexusIsmaylovo.saleLexus(itemNamed: "ES 250")
let sellMazdaRX7 = lexusIsmaylovo.saleLexus(itemNamed: "RX-7")
let sellIS250 = lexusIsmaylovo.saleLexus(itemNamed: "IS 250")
print(sellES250)
print(sellMazdaRX7)
print(sellIS250)


//MARK: - Try/Catch

class VolkswagenDealer {
    var inventory = [
        "Polo": Item(price: 930000, count: 5, product: Product(name: "Polo")),
        "Jetta": Item(price: 1627000, count: 10, product: Product(name: "Jetta")),
        "Passat": Item(price: 2096000, count: 4, product: Product(name: "Passat")),
        "Golf": Item(price: 1925000, count: 0, product: Product(name: "Golf"))
    ]
    
    var deposit = 0
    
    func topupDeposit(on topup: Int) { deposit += topup }
    
    func saleVw(itemNamed name: String) throws -> Product {
        guard let item = inventory[name] else {
            throw DealerError.invalidItem
        }
        
        guard item.count > 0 else {
            throw DealerError.notAvailable
        }
        
        guard item.price <= deposit else {
            throw DealerError.notEnoughMoney(moneyNeeded: item.price - deposit)
        }
        
        deposit -= item.price
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        return newItem.product
    }
}

let volkswagenDealerMKAD = VolkswagenDealer()
volkswagenDealerMKAD.topupDeposit(on: 1925000)

do {
    let sellVag = try volkswagenDealerMKAD.saleVw(itemNamed: "Golf")
    print("Мы купили: \(sellVag.name)")
    
} catch DealerError.invalidItem {
    print("Такого автомобиля нет в автосалоне Volkswagen")
    
} catch DealerError.notAvailable {
    print("Автомобиля нет в наличии")
    
} catch DealerError.notEnoughMoney(let moneyNeeded) {
    print("Недостаточно средств: \(moneyNeeded)")
    
} catch let error {
    print(error)
}
