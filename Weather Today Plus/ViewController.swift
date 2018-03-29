//
//  ViewController.swift
//  Weather Today Plus
//
//  Created by Viet Hoang Pham on 2017-11-26.
//  Copyright © 2017 Viet Hoang Pham. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   let kelvinToOneCelcius = 274.15
   @IBOutlet var resultLabel: UILabel!
   @IBOutlet var cityTextField: UITextField!
   
   @IBAction func getWeather(_ sender: Any)
   {
      self.view.endEditing(true)
      let cityInput = cityTextField.text!.replacingOccurrences(of: " ", with: "%20")
      if let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=" + cityInput + "&appid=83e3d4b700795fae451651cb5fefba74")
      {
         let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil
            {
               print(error)
            }
            else
            {
               if let urlContent = data
               {
                  do
                  {
                     let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                  
                     var result = ""
//                     print(jsonResult)
                     
                     if let connectionResult = jsonResult["cod"] as? String
                     {
                        if connectionResult == "404"
                        {
                           result.append("Could not find weather for that city.\n Please try again")
                        }
                     }
                     
                     if let cityName = jsonResult["name"] as? String
                     {
                        result.append("City: " + cityName)
                     }
                     
                     if let temp = (jsonResult["main"] as? NSDictionary)?["temp"] as? Double
                     {
                        let tempInCelcius = Int(temp / self.kelvinToOneCelcius)
                        result.append("\nTemperature: " + String(tempInCelcius) + "°C")
                     }
                     
                     if let description = ((jsonResult["weather"] as? NSArray)?[0] as? NSDictionary)?["description"] as? String
                     {
                        result.append("\nDescription: " + description)
                     }
                     
                     DispatchQueue.main.sync(execute: {
                        self.resultLabel.text = result
                     })
                  }
                  catch
                  {
                     print("JSON Processing Failed")
                  }
               }
            }
         } // task
         task.resume()
      }
      cityTextField.text = ""
   }
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      resultLabel.text = ""
   }
   
   // Hide keyboard after tapping on the background
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.view.endEditing(true)
   }

}

extension ViewController: UITextFieldDelegate
{
   func textFieldShouldReturn(_ textField: UITextField) -> Bool
   {
      getWeather((Any).self)
      textField.resignFirstResponder()
      return true
   }
}

