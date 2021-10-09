//
//  FavouriteListViewController.swift
//  Julia-set-ios
//
//  Created by Evan Beh on 07/10/2021.
//

import UIKit

protocol ListOutput : AnyObject
{
    func didSelectFavourite(collection:CollectionModel)
    
}

class FavouriteListViewController: UIViewController {

    weak var delegate : ListOutput?
    var dataSource : [CollectionModel] =  [CollectionModel]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FavouriteListViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! CustomTableViewCell
        
        let data = dataSource[indexPath.row]
        let item = data.uniform
        
        cell.lblTitle.text = data.title
        
        let variableI = String(format: "%.5f", item.a_i)
        let variableR = String(format: "%.5f", item.a_r)


        cell.lblDesc.text = ("X : \(variableR) , Y : \(variableI)")
        
        return cell

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = dataSource[indexPath.row]

        self.delegate?.didSelectFavourite(collection: data)
    }
    
    
    
}
