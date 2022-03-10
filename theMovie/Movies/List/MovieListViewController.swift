//
//  MovieListViewController.swift
//  theMovie
//
//  Created by Garpepi Aotearoa on 10/03/22.
//

import UIKit

class MovieListViewController: UIViewController {

    @IBOutlet weak var tableList: UITableView!
    private var request: APIRequest<MoviesResource>?
    private var movieLocal: [Movie] = []
    private var page: Int = 1

    var genre: String = ""
    var titleName: String = ""
    var loadMore: Bool = true
    var selectedMovie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableList.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cellList")
        // Do any additional setup after loading the view.
        fetchAPI()
        self.navigationItem.title = titleName
    }

    func fetchAPI() {
        var resource = MoviesResource()
        resource.genre = genre
        resource.page = page
        let request = APIRequest(resource: resource, apiType: .movieList)
        self.request = request
        request.execute { [weak self] movieLocal in
            self?.movieLocal.append(contentsOf: movieLocal ?? [])
            self?.tableList.reloadData()
            self?.page += 1
            self?.loadMore = true
        }
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if ((distanceFromBottom / 2) < height) && self.loadMore {
            self.loadMore = false
            fetchAPI()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieLocal.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellList", for: indexPath) as! TableViewCell
        cell.titleLabel.text = movieLocal[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = movieLocal[indexPath.row]
        performSegue(withIdentifier: "toMovieDetail", sender: self)
    }

}

extension MovieListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? MovieDetailViewController else {
          fatalError("failed preparing segue")
        }
        destinationVC.movie = selectedMovie
    }
}
