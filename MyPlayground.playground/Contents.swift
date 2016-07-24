//: Playground - noun: a place where people can play


import Foundation
import RxSwift
import RxCocoa


var str = "aaa"
print(str.characters)

let v1 = Variable(0)
let v2 = Variable(1)
let v3 = Variable(2)
let streamFromArray = [v1.asObservable(), v2.asObservable(), v3.asObservable()].toObservable()
let subscription = streamFromArray
//    .merge()
    .subscribe { event in
        print(event)
}

print("start")
NSThread.sleepForTimeInterval(0.5)
v1.value = 2
