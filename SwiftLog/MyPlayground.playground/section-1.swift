// Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

func bubbleSort(arr: inout [Int], cl: (Int, Int) -> (Bool)) {
    for _ in arr {
        for l in 0...arr.count-2 {
            let swap = cl(arr[l], arr[l+1])
            //println("\(i) < \(j): \(smaller)")
            
            if swap {
                let temp = arr[l]
                arr[l] = arr[l+1]
                arr[l+1] = temp
            }
        }
    }
}

var arr = [6,5,4,8,0,9,23,2,1]
/*
bubbleSort(&arr, { (i1: Int, i2: Int) -> Bool in return i1 > i2 })
println(arr)

var arr2 = [6,5,4,8,0,9,23,2,1]
bubbleSort(&arr2, { i1, i2 in i1 > i2 })
println(arr2)
bubbleSort(&[1,2,3], { $0 < $1 })
*/
bubbleSort(arr: &arr) { $0 > $1 }
println(arr)
