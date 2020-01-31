//
//  ViewController.swift
//  BitcoinTicker
//
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""
    let currencySymbols = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]

    // you can actually use this var to store the curr selected, and use it inside any method
    // i haven't used it, as the code stands.
    // found another way to do it.
    var currencySelected = ""
    
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    //**** TODO: Place your 3 UIPickerView delegate methods here ****
    
    // this shows the num of cols in the picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // this shows how many rows are displayed in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    // this populates each row with a title
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    // what happens once a row is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //print the row info
        print(row)
        print(currencyArray[row])
        print(currencySymbols[row])
        
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        
        getBitcoinData(url: finalURL, symbolIndex: row)
    }
    
//    
//    //MARK: - Networking
//    /***************************************************************/
//    
    func getBitcoinData(url: String, symbolIndex: Int) {
        
        Alamofire.request(url, method: .get).responseJSON {
            response in
                if response.result.isSuccess {
                    
                    print("Sucess! Got the Bitcoin data")
                    let bitcoinJSON : JSON = JSON(response.result.value!)
                    self.updateBitcoinData(json: bitcoinJSON, symbolIndex: symbolIndex)

                } else {
                    
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }
    }
 
//    //MARK: - JSON Parsing
//    /***************************************************************/

    func updateBitcoinData(json : JSON, symbolIndex: Int) {
        
        if let bitcoinResult = json["ask"].double {
            print(bitcoinResult)
            bitcoinPriceLabel.text = currencySymbols[symbolIndex] + String(bitcoinResult)
        }
        else {
            bitcoinPriceLabel.text = "Price Unavailable"
        }
    }
}

