//
//  MovieDetailViewController.swift
//  theMovie
//
//  Created by Garpepi Aotearoa on 10/03/22.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var videoContainer: UIView!
    @IBOutlet weak var youtubeButton: UIImageView!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var reviewTable: UITableView!

    var titleName: String?
    var movie: Movie?

    var movieReview: [Review] = []
    private var request: APIRequest<MoviesReviewResource>?
    private var page: Int = 1
    private var loadMore = true
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewTable.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "reviewCell")
        setImage()
        setUI()
        fetchAPI()
    }

    func fetchAPI() {
        guard let movieId = movie?.id else {
            return
        }
        var resource = MoviesReviewResource( id: String(movieId))
        resource.id = String(movie?.id ?? 0)
        resource.page = page
        let request = APIRequest(resource: resource, apiType: .movieReview)
        self.request = request
        request.execute { [weak self] movieReview in
            self?.movieReview.append(contentsOf: movieReview ?? [])
            self?.reviewTable.reloadData()
            self?.page += 1
            self?.loadMore = true
        }
    }

    func setImage() {
        guard let imagepath = movie?.backdropPath else {
            return
        }
        let url = URL(string: "https://image.tmdb.org/t/p/w500"+imagepath)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        banner.image = UIImage(data: data!)
    }

    func setUI() {
        guard let movie = self.movie else {
            return
        }

        self.navigationItem.title = movie.title
        overviewLabel.text = movie.overview
        popularityLabel.text = String(movie.popularity ?? 0.0)
        voteAverageLabel.text = String(movie.voteAverage ?? 0.0)
        voteCountLabel.text = String(movie.voteCount ?? 0)

        if movie.video ?? false == false {
            videoContainer.isHidden = true
        } else {
            videoContainer.isHidden = false
        }
    }
}
extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource  {
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
        return movieReview.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewTableViewCell
        cell.authorLabel.text = movieReview[indexPath.row].author ?? ""
        cell.reviewLabel.text = movieReview[indexPath.row].content ?? ""
        return cell
    }


}
