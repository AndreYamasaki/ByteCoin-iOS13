//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

//MARK: - CoinManager Delegate
protocol CoinManagerDelegate{
    func didFailwithError(error: Error)
    func passLastPriceOfBitcoin(price: String, currency: String)
}

struct CoinManager {
    
    //MARK: - Attributes
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "5668BA67-D1DB-48F3-BC93-E3492182BB9D"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    
    //MARK: - Methods
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
//                    print(error!)
                    self.delegate?.didFailwithError(error: error!)
                return
                }
                if let safeData = data {
//                    let dataString = String(data: safeData, encoding: .utf8)
//                    print(dataString)
                    if let bitCoinPrice = self.parseJSON(safeData) {
                        let stringBitCoinPrice = String(format: "%.2f", bitCoinPrice)
                        self.delegate?.passLastPriceOfBitcoin(price: stringBitCoinPrice, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let lastPrice = decodedData.rate
//            print(lastPrice)
            return lastPrice
        } catch {
            self.delegate?.didFailwithError(error: error)
            return nil
        }
    }
    
}
