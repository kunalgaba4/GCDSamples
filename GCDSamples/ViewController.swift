
//  ViewController.swift

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var lblCheck: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Uncomment the following method call to test
        
        //simpleQueues()
         //queuesWithQoS()
        
         //concurrentQueues()
//         if let queue = inactiveQueue {
//            queue.activate()
//         }
        
        // queueWithDelay()
         fetchImage()
        print("end")
         //useWorkItem()
    }
    
    
    func simpleQueues() {
        //Creation of serial queue
        let queue = DispatchQueue(label: "com.goodCompany.myqueue")
        
        queue.async {
            for i in 0..<10 {
                print("🔴", i)
                
                DispatchQueue.main.async {
                    self.lblCheck.text = "\(i)"
                }
                
            }
        }
        
        for i in 100..<110 {
            print("Ⓜ️", i)
        }
    }
    
    
    func queuesWithQoS() {
        let queue1 = DispatchQueue(label: "com.goodCompany.queue1", qos: DispatchQoS.userInitiated)
        // let queue1 = DispatchQueue(label: "com.goodCompany.queue1", qos: DispatchQoS.background)
        // let queue2 = DispatchQueue(label: "com.goodCompany.queue2", qos: DispatchQoS.userInitiated)
        let queue2 = DispatchQueue(label: "com.goodCompany.queue2", qos: DispatchQoS.utility)
        
        queue1.async {
            for i in 0..<10 {
                print("🔴", i)
            }
        }
        
        queue2.async {
            for i in 100..<110 {
                print("🔵", i)
            }
        }
        
        for i in 1000..<1010 {
            print("Ⓜ️", i)
        }
    }
    
    
    var inactiveQueue: DispatchQueue!
    func concurrentQueues() {
        // let anotherQueue = DispatchQueue(label: "com.goodCompany", qos: .utility)
         let anotherQueue = DispatchQueue(label: "com.goodCompany", qos: .utility, attributes: .concurrent)
        // let anotherQueue = DispatchQueue(label: "com.goodCompany", qos: .utility, attributes: .initiallyInactive)
//        let anotherQueue = DispatchQueue(label: "com.goodCompany", qos: .userInitiated, attributes: [.concurrent, .initiallyInactive])
        inactiveQueue = anotherQueue
        
        anotherQueue.async {
            for i in 0..<10 {
                print("🔴", i)
            }
        }
        
        
        anotherQueue.async {
            for i in 100..<110 {
                print("🔵", i)
            }
        }
        
        
        anotherQueue.async {
            for i in 1000..<1010 {
                print("⚫️", i)
            }
        }
    }
    
    
    func queueWithDelay() {
        let delayQueue = DispatchQueue(label: "com.goodCompany", qos: .userInitiated)
        
        print(Date())
        let additionalTime: DispatchTimeInterval = .seconds(2)
        
        delayQueue.asyncAfter(deadline: .now() + additionalTime) {
            print(Date())
        }
    }
    
    
    func fetchImage() {
        let imageURL: URL = URL(string: "http://www.appcoda.com/wp-content/uploads/2015/12/blog-logo-dark-400.png")!
        
        (URLSession(configuration: URLSessionConfiguration.default)).dataTask(with: imageURL, completionHandler: { (imageData, response, error) in
            print("IMage found")
            if let data = imageData {
                print("Did download image data")
                
                //ACCESS THE MAIN QUEUE AND UPDATE THE USER INTERFACE
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }).resume()
    }
    
    
    func useWorkItem() {
        var value = 10
        
        let workItem = DispatchWorkItem {
            value += 5
        }
        
        //will run on the main thread.
        //workItem.perform()
        
        //will run on the background thread
        let queue = DispatchQueue.global(qos: .utility)
        /*
         queue.async {
            workItem.perform()
         }
         */
        
        //method provided to execute the work item.
        queue.async(execute: workItem)
        
        
//        workItem.notify(queue: DispatchQueue.main) {
//            print("value = ", value)
//        }
    }
}

