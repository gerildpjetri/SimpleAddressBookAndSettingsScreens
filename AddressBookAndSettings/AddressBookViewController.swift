//
//  AddressBookViewController.swift
//  AddressBookAndSettings
//
//  Created by Gerild Pjetri on 19.11.20.
//

import UIKit

class AddressBookViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var name: UITextField!
    
    
    @IBOutlet weak var address: UITextField!
    
    
    @IBOutlet weak var addRow: UIButton!
    
    
    @IBOutlet weak var deleteRowOnSelectionButton: UIButton!
    
    
    @IBOutlet weak var addressBookTableView: UITableView!
    
    
    var addressBookSampleData : [AddressBook] = []
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var selectedRow : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedRow = addressBookSampleData.count + 1
        
        let nib = UINib.init(nibName: "CustomTableViewCell", bundle: nil)
        self.addressBookTableView.register(nib, forCellReuseIdentifier: "CustomCell")

        self.addressBookTableView.rowHeight = 60
        
        
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
   
   
        //scrollView.addGestureRecognizer(tap)
        
        
        
        let itemAddressBook = AddressBook()
        itemAddressBook.name = "John"
        itemAddressBook.address = "Street 14 , London"
        
        
        let itemAddressBook1 = AddressBook()
        itemAddressBook1.name = "Klaus"
        itemAddressBook1.address = "Street 34553 , Munchen"
        
        
        let itemAddressBook2 = AddressBook()
        itemAddressBook2.name = "Akihiro"
        itemAddressBook2.address = "Street 7488 , Tokyo"
        
        
        let itemAddressBook3 = AddressBook()
        itemAddressBook3.name = "Karlo"
        itemAddressBook3.address = "Street 4778 , Roma"
        
        let itemAddressBook4 = AddressBook()
        itemAddressBook4.name = "Aeolus"
        itemAddressBook4.address = "Street 4778 , Athens"
            
        
        
        addressBookSampleData.append(itemAddressBook)
        addressBookSampleData.append(itemAddressBook1)
        addressBookSampleData.append(itemAddressBook2)
        addressBookSampleData.append(itemAddressBook3)
        addressBookSampleData.append(itemAddressBook4)
        
      
        
       
        
        
        
        addressBookTableView.delegate = self
        addressBookTableView.dataSource = self
        
        
        addressBookTableView.reloadData()
        
        
    }
    
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
        
    }
    
   
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
            
        return addressBookSampleData.count
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //let Item = self.addressBookSampleData[indexPath.row]
        
        selectedRow =  indexPath.row
        
        //tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        
    }
    
   
       
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        
        
       
        
        let Item = self.addressBookSampleData[indexPath.row]
        
        cell.name.text = Item.name!
        
        cell.address.text = Item.address!
            
        
        
        return(cell)
    }

    

    @IBAction func addRowEvent(_ sender: Any) {
        
        
        if (name.text?.isEmpty)! || (address.text?.isEmpty)!{
            AddressBookViewController.ShowAlert("Name and Address must be completed in order to add a row on AddressBook", parentVC: self)
        }else {
          
            let itemAddressBook = AddressBook()
            itemAddressBook.name = name.text
            itemAddressBook.address = address.text
            
            addressBookSampleData.append(itemAddressBook)
            
            addressBookTableView.reloadData()
        }
        
        
    }
    
    @IBAction func deleteRowEvent(_ sender: Any) {
        
        
        if(selectedRow != addressBookSampleData.count + 1){
            
            addressBookSampleData.remove(at: selectedRow)
            addressBookTableView.reloadData()
        }
        
        
        
    }
    
    
    fileprivate static var alertController : UIAlertController?
  
    static var AlertController : UIAlertController
    {
        get { return alertController! }
        set { alertController = newValue }
    }
    
    static func ShowAlert(_ msg : String, parentVC : UIViewController)
    {
        alertController = UIAlertController(title: "Kujdes!", message: msg, preferredStyle: .alert)
        
        alertController?.addAction(UIAlertAction(title: "Ne Rregull", style: UIAlertAction.Style.default, handler: nil))
        
        parentVC.present(alertController!, animated: true, completion: nil)
    }
    
}
