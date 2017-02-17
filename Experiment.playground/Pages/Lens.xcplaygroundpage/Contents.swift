//: [Previous](@previous)

import Foundation
import Curry
import Prelude

let d = Keyboard.numberKeyboardDiagram
let c = Keyboard.alphaKeyboardDiagram




//var str = "Hello, playground"

//: [Next](@next)

//struct Address {
//    let street: String
//    let city: String
//}
//
//struct Person {
//    let name: String
//    let address: Address
//}
//
//struct Lens<Whole,Part> {
//    let from: (Whole) -> Part
//    let to: (Part, Whole) -> Whole
//}
//
//let addr = Lens<Person, Address>(from: {$0.address}, to: {Person(name: $1.name, address: $0)})
//
//let street = Lens<Address, String>(from: {$0.street}, to: {Address(street: $0, city: $1.city)})
//
//let A1 = Address(street: "Juhejie", city: "GZ")
//let P1 = Person(name: "Keith", address: A1)
//
//let a1 = addr.from(P1)
//let s1 = street.from(a1)
//
//let a2 = street.to("Dongqu", a1)
//let p2 = addr.to(a2, P1)
//
//p2.address.street
//
//struct PersonLens: LensType {
//    var view: (Person) -> Address
//    var set: (Address, Person) -> Person
//}
//
//struct AddressLens: LensType {
//    var view: (Address) -> String
//    var set: (String, Address) -> Address
//}
//
//let personLens = PersonLens(view: {$0.address}, set: {Person(name: $1.name, address: $0)})
//let addressLens = AddressLens(view: {$0.street}, set: {Address(street: $0, city: $1.city)})
//
//let personStreetLens = personLens.compose(addressLens)
//
//personStreetLens.view(P1)
//let p3 = personStreetLens.set("XXX", P1)
//p3.address.street




//struct A<B> {
//    var a: B
//}
//
//
//let constructor = A<Int>.init
//








