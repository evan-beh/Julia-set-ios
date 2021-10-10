//
//  ViewController.swift
//  Julia-set-ios
//
//  Created by Evan Beh on 04/10/2021.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {


    @IBOutlet weak var txtFieldI: UITextField!
    @IBOutlet weak var txtFieldR: UITextField!

    @IBOutlet weak var ibSlider: UISlider!
    @IBOutlet var buttonControls: [UIButton]!
    
    @IBOutlet weak var metalView: MetalView!
   
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    let apiService = CollectionAPIService()

    var collectionList : [CollectionModel] =  [CollectionModel]()

    let variation = stepVariation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()

         scrollView.delegate = self
        
//        self.scrollView.minimumZoomScale=1;
//
//        self.scrollView.maximumZoomScale=6.0;

        self.scrollView.contentSize = self.metalView.frame.size;
         
        self.metalView.drawableSize =  CGSize(width: self.metalView.frame.size.width, height: self.metalView.frame.size.height)

        
        apiService.retrieve { array in
            self.collectionList = array
        }
    }
    
    
    @IBAction func scaleChanged(sender: UISlider) {
        
        let step: Float = 1
        var currentValue = round((sender.value - sender.minimumValue) / step)
        
        
        if (currentValue < sender.minimumValue)
        {
            currentValue = sender.minimumValue
        }
        var temp = self.metalView.compute?.uniform
        temp?.scale = currentValue
        self.updateSet(temp: temp!)
      
        
    }
    
    
    func setup()
    {
        
        let slider = self.ibSlider!
        let total: Float = 50
        slider.maximumValue = total
        slider.minimumValue = scale

        //add to R
        buttonControls[0].addAction {

            self.metalView.r_delta = Float(self.variation)
            let variableR = String(format: "%.5f", self.metalView.compute?.uniform.a_r ?? 0)
            self.txtFieldR.text = variableR
        }
        
        //minus to R
        buttonControls[1].addAction {

            self.metalView.r_delta = -Float(self.variation)
            let variableR = String(format: "%.5f", self.metalView.compute?.uniform.a_r ?? 0)
            self.txtFieldR.text = variableR
        }

        //add to I
        buttonControls[2].addAction {

            self.metalView.i_delta = Float(self.variation)
            let variableI = String(format: "%.5f", self.metalView.compute?.uniform.a_i ?? 0)
            self.txtFieldI.text = variableI
          

        }
  
        //minus to I
        buttonControls[3].addAction {

            self.metalView.i_delta = -Float(self.variation)
            let variableI = String(format: "%.5f", self.metalView.compute?.uniform.a_i ?? 0)
            self.txtFieldI.text = variableI
           
        }
     
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(favouriteClicked))
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(addFavouriteClicked))


      
    }
    
    func updateSet(temp:Uniforms)
    {
        self.metalView.compute?.uniform = temp
        
        
        let variableR = String(format: "%.5f", self.metalView.compute?.uniform.a_r ?? 0)
        let variableI = String(format: "%.5f", self.metalView.compute?.uniform.a_i ?? 0)

        self.ibSlider.value = self.metalView.compute?.uniform.scale ?? scale

        self.txtFieldR.text = variableR
        self.txtFieldI.text = variableI
    

    }
    
    @objc func favouriteClicked()
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "fav_list")
        
        
        if let favVC = vc as? FavouriteListViewController
        {
            favVC.dataSource = self.collectionList
            favVC.delegate = self
        }
        
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @objc func addFavouriteClicked()
    {
        
        let ac = UIAlertController(title: "Collection Name", message: nil, preferredStyle: .alert)
           ac.addTextField()

           let submitAction = UIAlertAction(title: "DONE", style: .default) { [unowned ac] _ in
               let answer = ac.textFields![0]
               // do something interesting with "answer" here
            
            
            let uniform = self.metalView.compute?.uniform
         
            
            let collection = CollectionModel (title: answer.text ?? "default", uniform: uniform!)
            self.collectionList.append(collection)
            
            self.apiService.save(collection: collection)
            
           }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
           ac.addAction(submitAction)
            ac.addAction(cancelAction)

           present(ac, animated: true)

    }
    

    @IBAction func buttonChangeValue(_ sender: Any) {
        
        if let updates = Float(self.txtFieldR.text ?? "0")
        {
            self.metalView.compute?.uniform.a_r = updates
        

        }
        
        if let updates = Float(self.txtFieldI.text ?? "0")
        {
            self.metalView.compute?.uniform.a_i = updates

        }
      
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return self.metalView
    }
    
}


extension ViewController : ListOutput
{
    func didSelectFavourite(collection:CollectionModel)
    {
        
        self.navigationController?.popToViewController(self, animated: true)
        self.updateSet(temp: collection.uniform)
    }
    
    
}
