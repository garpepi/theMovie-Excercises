//
//  ViewController.swift
//  theMovie
//
//  Created by Garpepi Aotearoa on 10/03/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableList: UITableView!
    private var request: APIRequest<GenreResource>?
    private var genres: [Genre] = []
    private var selectedGenre: String?
    private var selectedGenreName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableList.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cellList")
        fetchAPI()
    }

    func fetchAPI() {
        let resource = GenreResource()
        let request = APIRequest(resource: resource, apiType: .genres)
        self.request = request
        request.execute { [weak self] genres in
            self?.genres = genres ?? []
            self?.tableList.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellList", for: indexPath) as! TableViewCell
        cell.titleLabel.text = genres[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedGenre = String(genres[indexPath.row].id ?? 0)
        self.selectedGenreName = genres[indexPath.row].name ?? ""
        performSegue(withIdentifier: "toMovieList", sender: self)
    }
}

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toMovieList":
            guard let destinationVC = segue.destination as? MovieListViewController else {
              fatalError("failed preparing segue")
            }
            destinationVC.genre = selectedGenre ?? ""
            destinationVC.titleName = selectedGenreName ?? ""
        default:
            return
        }
    }
}

