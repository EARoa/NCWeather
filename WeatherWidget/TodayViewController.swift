//
//  TodayViewController.swift
//  WeatherWidget
//
//  Created by Efrain Ayllon on 8/2/16.
//  Copyright © 2016 Efrain Ayllon. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    var location = [Location]()
    
    @IBOutlet weak var currentTemperature :UILabel!
    @IBOutlet weak var currentSummary :UILabel!
    @IBOutlet weak var currentHumidity :UILabel!
    @IBOutlet weak var currentVisibility :UILabel!
    @IBOutlet weak var currentWindSpeed :UILabel!
    
    //    var latitude :Double!
    //    var longitude :Double!
    //
    let latitude = 29.737689
    let longitude = -95.375576
    
    let currentLocation = Location()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiSetup()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func apiSetup() {
        let theAPI = "https://api.forecast.io/forecast/ee590865b8cf07d544c96463ae5d47c5/\(latitude),\(longitude)"
        guard let url = NSURL(string: theAPI) else {
            fatalError("Invalid URL")
        }
        let session = NSURLSession.sharedSession()
        
        session.dataTaskWithURL(url) { (data :NSData?, response :NSURLResponse?, error :NSError?) in
            guard let jsonResult = NSString(data: data!, encoding: NSUTF8StringEncoding) else {
                fatalError("Unable to format data")
            }
            let postResult = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves) as! NSDictionary
            
            
            
            let dataArray = postResult["currently"] as! NSDictionary?;
            self.currentLocation.temperature = dataArray!.valueForKey("temperature") as! Int
            self.currentLocation.summary = dataArray!.valueForKey("summary") as! String
            self.currentLocation.humidity = dataArray!.valueForKey("humidity") as! Int
            self.currentLocation.visibility = dataArray!.valueForKey("visibility") as! Int
            self.currentLocation.windspeed = dataArray!.valueForKey("windSpeed") as! Int
            
            self.location.append(self.currentLocation)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.currentTemperature.text = "Temperature: \(self.currentLocation.temperature)℉"
                
                self.currentSummary.text = "Summary: \(self.currentLocation.summary)"
                self.currentHumidity.text = "Humidity: \(self.currentLocation.humidity)"
                self.currentVisibility.text = "Visibility: \(self.currentLocation.visibility)"
                self.currentWindSpeed.text = "Windspeed: \(self.currentLocation.windspeed)"
            })
            }.resume()
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        completionHandler(NCUpdateResult.NewData)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        print("haiii")
        let url :NSURL = NSURL(string: "awesomeweather://")!
        self.extensionContext!.openURL(url, completionHandler: nil)

    
    }
    
    
    
    
}