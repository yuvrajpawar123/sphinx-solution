//
//  UserViewController.swift
//  Sphinx_solution_MachineTest
//
//  Created by Mac on 04/03/23.
//


import UIKit

class UserViewController: UIViewController {
    @IBOutlet weak var Userview: UICollectionView!
    @IBOutlet weak var PopulationTableView: UITableView!
    var jsonDecoder:JSONDecoder?
    var url:URL?
    var urlString:String?
    var urlRequest:URLRequest?
    var urlSession:URLSession?
    var popluations = [Data]()
    var users = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        Userview.dataSource = self
        Userview.delegate = self
        PopulationTableView.dataSource = self
        PopulationTableView.delegate = self
        let uinibname = UINib(nibName: "UserCollectionViewCell", bundle: nil)
        self.Userview.register(uinibname, forCellWithReuseIdentifier: "UserCollectionViewCell")
        let nibname = UINib(nibName: "PopulationApiTableViewCell", bundle: nil)
        self.PopulationTableView.register(nibname, forCellReuseIdentifier: "PopulationApiTableViewCell")
        jsonserialisation()
        jsonDecoderin()
    }
    func jsonserialisation(){
        urlString = "https://gorest.co.in/public/v2/users"
       url = URL(string: urlString!)
        urlRequest=URLRequest(url: url!)
        urlRequest?.httpMethod = "GET"
        urlSession = URLSession(configuration: .default)
        var dataTask = urlSession?.dataTask(with: urlRequest!) { data, responce ,error in
            let jsonObject = try! JSONSerialization.jsonObject(with: data!) as! [[String:Any]]
            for eachUser in jsonObject{
                let userId = eachUser["id"] as! Int
                let userName = eachUser["name"] as! String
                let userGender = eachUser["gender"] as! String
                let newUser = User(Id: userId, Name: userName, Gender: userGender)
                self.users.append(newUser)
            }
            DispatchQueue.main.async {
                self.Userview.reloadData()
            }
        }
        .resume()
    }
    func jsonDecoderin(){
        var url:URL?
        var urlString:String?
        var urlRequest:URLRequest?
        var urlSession:URLSession?
        urlString="https://datausa.io/api/data?drilldowns=Nation&measures=Population"
        url=URL(string: urlString!)
            urlRequest=URLRequest(url: url!)
            urlRequest?.httpMethod="GET"
            urlSession = URLSession(configuration: .default)
            URLSession.shared.dataTask(with: urlRequest!) { data ,response ,error in
               if(error == nil){
                    do{
                    self.jsonDecoder=JSONDecoder()
                        let jsonResponce = try self.jsonDecoder?.decode(Data.self, from: data! )
                    }catch{
                        print(error)
                    }
                }
                DispatchQueue.main.async {
                    self.PopulationTableView.reloadData()
                }
            }.resume()
    }
    }

extension UserViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewhight = view.frame.size.height
        let viewwidth = view.frame.size.width
        return CGSize(width: viewwidth, height: viewhight)
    }
}

extension UserViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let UserCollectionViewCell = self.Userview.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as! UserCollectionViewCell
        let eachUsers = users[indexPath.row]
        UserCollectionViewCell.IdLabal.text = String(eachUsers.Id)
        UserCollectionViewCell.NameLabal.text = eachUsers.Name
        UserCollectionViewCell.GenderLabal.text = eachUsers.Gender
        
        return UserCollectionViewCell
    }
}

extension UserViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popluations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let PopulationApiTableViewCell = self.PopulationTableView?.dequeueReusableCell(withIdentifier: "PopulationApiTableViewCell", for: indexPath) as! PopulationApiTableViewCell
        
        let eachyear = popluations[indexPath.row]
        PopulationApiTableViewCell.yearlabal.text = eachyear.year
        PopulationApiTableViewCell.PoppulationLabal.text = String(eachyear.Population)
        
        return PopulationApiTableViewCell
    }
}
extension UserViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200.0
    }
}
