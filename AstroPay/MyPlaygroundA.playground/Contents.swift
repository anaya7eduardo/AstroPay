import UIKit

var greeting = "Hello, playground"
struct Fruit { let name: String
    let Price: Double }
let Fruits = [     Fruit(name: "Apple", Price: 0.322),     Fruit(name: "Orange", Price: 0.701),     Fruit(name: "Kiwi", Price: 1.02),     Fruit(name: "Pear", Price: 1.23),     Fruit(name: "Watermelon", Price: 1.44),     Fruit(name: "Fig", Price: 1.66),     Fruit(name: "Date", Price: 1.86),     Fruit(name: "Grape", Price: 1.97) ]

let prices = Fruits.map { $0.Price }

print("prices = \(prices)")

/*
let totalCost = Fruits.map { $0.Price }.reduce(0) { (lhs, rhs) in
    lhs + rhs
*/

/*
let totalCost = Fruits.map { $0.Price }.reduce(0) { (lhs, rhs) in
    lhs + rhs
}
*/

let totalCost = Fruits.reduce(into: 0) { (lhs, rhs) in
    lhs.Price + rhs.Price
}

print("total cost = \(totalCost)")





