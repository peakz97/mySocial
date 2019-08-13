//
//  SpareCodes.swift
//  socialpeak
//
//  Created by fleexx on 2019-08-06.
//  Copyright © 2019 Peakz Entertainment. All rights reserved.
//

import Foundation


/*
 Database.database().reference().child("test1").child("time").observeEventOfType(.Value, withBlock: { (snapshot) in
 if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
 for child in result {
 var orderID = child.key as! String
 print(orderID)
 }
 }
 })
 */


/*
 let dataRef = Database.database().reference()
 
 dataRef.child("Posts").child("likes").runTransactionBlock({
 (currentData:MutableData!) in
 
 var value = currentData.value as? Int
 //check to see if the likes node exists, if not give value of 0.
 if (value == nil) {
 value = 0
 }
 currentData.value = value! + 1
 return TransactionResult.success(withValue: currentData)
 
 })
 */

/*Database.database().reference().child("TPose").observe(.value, with: { (snapshot) in
 if let result = snapshot.children.allObjects as? [DataSnapshot] {
 for child in result {
 let orderID = child.key
 print(orderID)
 
 ref.child("test1").child("likes").child(orderID).runTransactionBlock({
 (currentData:MutableData!) in
 var value = currentData.value as? Int
 //check to see if the likes node exists, if not give value of 0.
 if (value == nil) {
 value = 0
 }
 currentData.value = value! + 1
 return TransactionResult.success(withValue: currentData)
 
 })
 
 
 }
 }
 })*/



/* let ref = Database.database().reference()
 
 ref.child("Posts").child("likes").runTransactionBlock({
 (currentData:MutableData!) in
 var value = currentData.value as? Int
 //check to see if the likes node exists, if not give value of 0.
 if (value == nil) {
 value = 0
 }
 currentData.value = value! + 1
 return TransactionResult.success(withValue: currentData)
 
 })*/

/*  Database.database().reference().child("test1").child("time").observe(.childAdded) { (snapshot) in
 print(snapshot.value)
 
 if let ans = snapshot.value as? [String : Any] {
 let answ = ans["testRe"] as! String
 //print(answ)
 self.TestLabel.text = answ
 
 }}*/
        
