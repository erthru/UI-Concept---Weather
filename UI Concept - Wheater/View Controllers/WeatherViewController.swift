//
//  ViewController.swift
//  UI Concept - Wheater
//
//  Created by Suprianto Djamalu on 20/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let viewWeather = UIView()
    private let lbCelcius = UILabel()
    private let imgWeather = UIImageView()
    private let idc = UIActivityIndicatorView(style: .whiteLarge)
    private let lbDate = UILabel()
    private let lbC = UILabel()
    private let lbName = UILabel()
    private let lbWeather = UILabel()
    private let tableDetail = UITableView()
    private let refreshControl = UIRefreshControl()
    
    private let locationManager = CLLocationManager()
    private var locationLoaded = false
    private var details = [Detail]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        loadCurrentLocation()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func loadCurrentLocation(){
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func loadWeather(lat: String, lng: String){
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lng)&appid=YOUR_KEY"
        
        HttpRequest<WeatherResponse>(url: url).get{ (response, err) in
            self.idc.isHidden = true
            self.viewWeather.isHidden = false
            self.refreshControl.endRefreshing()
            
            if !err {
                let celciusTemp = (response?.main.temp)! - 273.15
                let pressureTemp = response?.main.pressure
                let humidity = response?.main.humidity
                let tempMin = (response?.main.tempMin)! - 273.15
                let tempMax = (response?.main.tempMax)! - 273.15
                let windSpeed = response?.wind.speed
                let windDeg = response?.wind.deg
                let sunrise = Date(timeIntervalSince1970: (response?.sys.sunrise)!)
                let sunset = Date(timeIntervalSince1970: (response?.sys.sunset)!)
                
                self.lbName.text = response?.name != nil ? response!.name : "Undefinied"
                self.lbWeather.text = response!.weather[0].description
                self.lbCelcius.text = String(format: "%.0f", celciusTemp)
                
                self.details.removeAll()
                
                self.details.append(Detail(name: "Presure", value: String(format: "%.0f", pressureTemp!)))
                self.details.append(Detail(name: "Humidity", value: String(format: "%.0f", humidity!)))
                self.details.append(Detail(name: "Temp Min", value: "\(String(format: "%.0f", tempMin)) c"))
                self.details.append(Detail(name: "Temp Max", value: "\(String(format: "%.0f", tempMax)) c"))
                self.details.append(Detail(name: "Wind Speed", value: String(format: "%.0f", windSpeed!)))
                self.details.append(Detail(name: "Wind Deg", value: String(format: "%.0f", windDeg!)))
                self.details.append(Detail(name: "Sunrise", value: sunrise.toString(dateFormat: "HH:mm")))
                self.details.append(Detail(name: "Sunset", value: sunset.toString(dateFormat: "HH:mm")))
                
                self.tableDetail.reloadData()
                self.scrollView.contentSize.height = self.tableDetail.contentSize.height + 375
                
                if response?.weather[0].condition == .clear {
                    self.imgWeather.image = UIImage(weather: .clear)
                }
                
                if response?.weather[0].condition == .clouds {
                    self.imgWeather.image = UIImage(weather: .cloud)
                }
                
                if response?.weather[0].condition == .snow {
                    self.imgWeather.image = UIImage(weather: .snow)
                }
                
                if response?.weather[0].condition == .rain {
                    self.imgWeather.image = UIImage(weather: .rain)
                }
                
                if response?.weather[0].condition == .drizzle {
                    self.imgWeather.image = UIImage(weather: .drizzle)
                }
                
                if response?.weather[0].condition == .thunderstorm {
                    self.imgWeather.image = UIImage(weather: .storm)
                }
            }
        }
    }
    
    @objc fileprivate func refreshControlOnRefresh(){
        locationLoaded = false
        locationManager.startUpdatingLocation()
    }
    
    private func setupUI(){
        // view
        view.backgroundColor = .lightBlue
        view.addSubview(idc)
        view.addSubview(scrollView)
        
        // scrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.refreshControl = refreshControl
        scrollView.addSubview(viewWeather)
        
        // viewWeather
        viewWeather.translatesAutoresizingMaskIntoConstraints = false
        viewWeather.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        viewWeather.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        viewWeather.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        viewWeather.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        viewWeather.isHidden = true
        viewWeather.addSubview(lbDate)
        viewWeather.addSubview(lbCelcius)
        viewWeather.addSubview(lbC)
        viewWeather.addSubview(imgWeather)
        viewWeather.addSubview(lbName)
        viewWeather.addSubview(lbWeather)
        viewWeather.addSubview(tableDetail)
        
        // lbCelcius
        lbCelcius.translatesAutoresizingMaskIntoConstraints = false
        lbCelcius.topAnchor.constraint(equalTo: viewWeather.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        lbCelcius.leadingAnchor.constraint(equalTo: viewWeather.leadingAnchor, constant: 26).isActive = true
        lbCelcius.text = "31"
        lbCelcius.textColor = .white
        lbCelcius.font = UIFont.boldSystemFont(ofSize: 96)
        
        // lbC
        lbC.translatesAutoresizingMaskIntoConstraints = false
        lbC.topAnchor.constraint(equalTo: viewWeather.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        lbC.leadingAnchor.constraint(equalTo: lbCelcius.trailingAnchor, constant: 10).isActive = true
        lbC.text = "C"
        lbC.textColor = .white
        lbC.font = UIFont.boldSystemFont(ofSize: 37)
        idc.isHidden = false
        
        // lbDate
        lbDate.translatesAutoresizingMaskIntoConstraints = false
        lbDate.topAnchor.constraint(equalTo: lbCelcius.bottomAnchor, constant: 4).isActive = true
        lbDate.leadingAnchor.constraint(equalTo: viewWeather.leadingAnchor, constant: 26).isActive = true
        lbDate.text = Date().toString(dateFormat: "MMMM dd yyyy")
        lbDate.textColor = .white
        lbDate.font = UIFont.boldSystemFont(ofSize: 21)
        
        // imgWeather
        imgWeather.translatesAutoresizingMaskIntoConstraints = false
        imgWeather.topAnchor.constraint(equalTo: viewWeather.safeAreaLayoutGuide.topAnchor, constant: 46).isActive = true
        imgWeather.trailingAnchor.constraint(equalTo: viewWeather.trailingAnchor, constant: -26).isActive = true
        imgWeather.heightAnchor.constraint(equalToConstant: 140).isActive = true
        imgWeather.widthAnchor.constraint(equalToConstant: 140).isActive = true
        imgWeather.image = UIImage(weather: .clear)
        
        // lbName
        lbName.translatesAutoresizingMaskIntoConstraints = false
        lbName.topAnchor.constraint(equalTo: lbDate.bottomAnchor, constant: 35).isActive = true
        lbName.centerXAnchor.constraint(equalTo: viewWeather.centerXAnchor).isActive = true
        lbName.text = "Undefinied"
        lbName.font = UIFont.systemFont(ofSize: 41)
        lbName.textColor = .white
        
        // lbWeather
        lbWeather.translatesAutoresizingMaskIntoConstraints = false
        lbWeather.topAnchor.constraint(equalTo: lbName.bottomAnchor, constant: 10).isActive = true
        lbWeather.centerXAnchor.constraint(equalTo: viewWeather.centerXAnchor).isActive = true
        lbWeather.text = "Clear"
        lbWeather.font = UIFont.systemFont(ofSize: 21)
        lbWeather.textColor = .white
        
        // tableDetail
        tableDetail.translatesAutoresizingMaskIntoConstraints = false
        tableDetail.topAnchor.constraint(equalTo: lbWeather.bottomAnchor, constant: 16).isActive = true
        tableDetail.leadingAnchor.constraint(equalTo: viewWeather.leadingAnchor, constant: 14).isActive = true
        tableDetail.trailingAnchor.constraint(equalTo: viewWeather.trailingAnchor, constant: -14).isActive = true
        tableDetail.bottomAnchor.constraint(equalTo: viewWeather.bottomAnchor).isActive = true
        tableDetail.tableFooterView = UIView()
        tableDetail.isScrollEnabled = false
        tableDetail.register(UITableViewCell.self, forCellReuseIdentifier: "DetailCell")
        tableDetail.backgroundColor = .lightBlue
        tableDetail.delegate = self
        tableDetail.dataSource = self
        
        // idc
        idc.translatesAutoresizingMaskIntoConstraints = false
        idc.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        idc.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        idc.startAnimating()
        
        // refreshControl
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshControlOnRefresh), for: .valueChanged)
    }

}

extension WeatherViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue = manager.location?.coordinate else { return }
        
        if !locationLoaded{
            locationLoaded = true
            locationManager.stopUpdatingLocation()
            loadWeather(lat: String(locValue.latitude), lng: String(locValue.longitude))
        }
    }
    
}

extension WeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "DetailCell")
        
        cell.backgroundColor = .lightBlue
        cell.selectionStyle = .none
        
        cell.textLabel?.text = details[indexPath.row].name
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.text = details[indexPath.row].value
        cell.detailTextLabel?.textColor = .almostWhite
        return cell
    }
    
}

extension WeatherViewController: UITableViewDelegate {}
