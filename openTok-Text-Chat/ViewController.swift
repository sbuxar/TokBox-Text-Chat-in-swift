//
//  ViewController.swift
//  openTok-Text-Chat
//
//  Created by MAC on 22/10/17.
//  Copyright © 2017 Sabir. All rights reserved.
//

import UIKit
import OpenTok

// Replace with your OpenTok API key
var kApiKey = ""
// Replace with your generated session ID
var kSessionId = ""
// Replace with your generated token
var kToken = ""



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, OTSessionDelegate {
    
    var session: OTSession?
    var publisher: OTPublisher?
    var subscriber: OTSubscriber?
    
    var flag = true
    
    @IBOutlet weak var messageList: UITableView!
    @IBOutlet weak var textField: UITextField!
    var messages = [String]()
    var myArray = [String] ()
    var flagArray = [Bool]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       // Adding gelegate
        
        textField.delegate = self
        messageList.delegate = self
        messageList.dataSource = self as UITableViewDataSource
        
        // Calling opentok connection here
        connectToAnOpenTokSession()
        
    }
    
    func connectToAnOpenTokSession() {
        session = OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: self as? OTSessionDelegate)
        var error: OTError?
        session?.connect(withToken: kToken, error: &error)
        if error != nil {
            print(error!)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func onSend(_ sender: Any) {
        
        if textField.text == ""  {
             print("can't send empty message")
        }else
        {
            var error:OTError?
            
            
            let connection : OTConnection? = nil
            
            session?.signal(withType: "chat", string: textField.text!, connection: connection, error: &error)
            
            if ((error) != nil) {
                print("signal error %@", error);
            } else {
                    if !textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                    flagArray.append(true)
                    messages.append(textField.text!)
                    print("Hello", textField.text!)
                    textField.text = ""
                    // Reloading table data
                    messageList.reloadData()
                }
                
            }
            
        }
        

        
    }
    
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count // Create 1 row as an example
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for:indexPath) as UITableViewCell
        cell.textLabel?.text = self.messages[indexPath.row]
        
        // setting text alignment here
        flag = self.flagArray[indexPath.row]
        
        if flag == true {
            cell.textLabel!.textAlignment = NSTextAlignment.left
            
        }else
        {
            cell.textLabel!.textAlignment = NSTextAlignment.right
            
        }
        

        // ...
        return cell
    }
    
   
    func sessionDidConnect(_ session: OTSession) {
        print("The client connected to the OpenTok session.")
        
    }
    
    func sessionDidDisconnect(_ session: OTSession) {
        print("The client disconnected from the OpenTok session.")
    }
    
    func session(_ session: OTSession, didFailWithError error: OTError) {
        print("The client failed to connect to the OpenTok session: \(error).")
    }
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print("A stream was created in the session.")
      
    }
    

    
    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        print("A stream was destroyed in the session.")
    }
    
    func session(_ session: OTSession, receivedSignalType type: String?, from connection: OTConnection?, with string: String?) {
        print("Received signal", string!)
        if(connection?.connectionId == session.connection?.connectionId)
        {
            print("signaling own message")
        }else
        {
            
            messages.append(string!)
            // Reloading table data
            messageList.reloadData()
        }
    }
    
    
}

