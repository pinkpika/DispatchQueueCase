//
//  ViewController.swift
//  TestApp
//
//  Created by cm0620 on 2022/1/25.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        handleBigData()
        handleCallApi()
        handleMergeApi()
        handlePipeApi()
    }
}

extension ViewController{
    
    /// Case1: BigData
    func handleBigData(){
        DispatchQueue.global().async {
            var total = 0
            for i in 0...1000000{
                total += i
            }
            print("Done BigData \(total)")
            DispatchQueue.main.async {
                // TODO: Update UI on main thread.
            }
        }
    }
    
    /// Case2: CallApi
    func handleCallApi(){
        guard let url = URL(string: "https://httpbin.org/get") else { return }
        AF.request(url).response{
            response in
            print("Done CallApi url \(response)")
        }
    }
    
    /// Case3: MergeApi
    func handleMergeApi(){
        guard let url1 = URL(string: "https://httpbin.org/get?data=1") else { return }
        guard let url2 = URL(string: "https://httpbin.org/get?data=2") else { return }
        
        let group = DispatchGroup()
        group.enter()
        AF.request(url1).response{
            response in
            print("Done MergeApi url1 \(response)")
            group.leave()
        }
        
        group.enter()
        AF.request(url2).response{
            response in
            print("Done MergeApi url2 \(response)")
            group.leave()
        }
        
        group.notify(queue: .main) {
            print("Done MergeApi")
            // TODO: Merge Data or Update UI on main thread.
        }
    }
    
    /// Case4: PipeApi
    func handlePipeApi(){
        guard let url1 = URL(string: "https://httpbin.org/get?data=1") else { return }
        guard let url2 = URL(string: "https://httpbin.org/get?data=2") else { return }
        
        let group = DispatchGroup()
        DispatchQueue.global().async {
            group.enter()
            AF.request(url1).response{
                response in
                print("Done PipeApi url1 \(response)")
                group.leave()
            }
            group.wait()
            
            group.enter()
            AF.request(url2).response{
                response in
                print("Done PipeApi url2 \(response)")
                group.leave()
            }
            group.wait()
            
            print("Done PipeApi")
            DispatchQueue.main.async{
                // TODO: Update UI on main thread.
            }
        }
    }
}

