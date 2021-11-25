//
//  HomeViewController.swift
//  Felician_Ishark_cobsccomp192p049
//
//  Created by Felician Ishark on 2021-11-17.
//

import UIKit
import Firebase

class HomeViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var db: Firestore?
    
//    var SlotName = [String]()
//    var SlotStatus = [String]()
//    var VehicalNo = [String]()
//    var SlotTime = [String]()
//    var SlotType = [String]()
    
    let colors = [UIColor.blue, UIColor.yellow, UIColor.magenta, UIColor.red, UIColor.brown]
    let cellReuseIdentifier = "cell"
    let cellSpacingHeight: CGFloat = 5
    var SlotModels: [Slots] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.db = Firestore .firestore()
        
        self.db?.collection("Slots").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                                 self.SlotModels.append(Slots(
                                    SlotName: document.get("SlotName") as! String?,
                                    SlotStatus: document.get("SlotStatus") as! String?,
                                    VehicalNo: document.get("VehicalNo") as! String?,
                                    SlotTime: document.get("SlotTime") as! String?,
                                    SlotType: document.get("SlotType") as! String?
                                 ))
                                 self.tableView.reloadData()
                             }
            }
        }
    }
    
    // number of rows in table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SlotModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    // create a cell for each table view row  UITableViewCell
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyCustomCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MyCustomCell
        
//        cell.SlotName.text = self.SlotName[indexPath.row]
//        cell.SlotStatus.text = self.SlotStatus[indexPath.row]
//        cell.VehicalNo.text = self.VehicalNo[indexPath.row]
        
        let status = self.SlotModels[indexPath.row].SlotStatus
            cell.SlotName.text = self.SlotModels[indexPath.row].SlotName
            cell.SlotStatus.text =  status == "A" ? "Available" : status == "R" ? "Reserved" : "Booked"
            cell.VehicalNo.text = self.SlotModels[indexPath.row].VehicalNo
            cell.lblType.text = self.SlotModels[indexPath.row].SlotType
            cell.lblTime.text = self.SlotModels[indexPath.row].SlotTime
        
         cell.layer.borderWidth = 2
         cell.layer.cornerRadius = 8
         cell.clipsToBounds = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}

