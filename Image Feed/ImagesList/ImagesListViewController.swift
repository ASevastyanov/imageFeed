import UIKit
import Kingfisher

//MARK: - UIViewController
final class ImagesListViewController: UIViewController {
    @IBOutlet weak private var tableView: UITableView!
    private let imagesListService = ImagesListService.shared
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var alertPresenter: AlertPresenterProtocol?
    private var gradientLayer = GradientLayer.shared
    private var photos: [Photo] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewControler: self)
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imagesListService.fetchPhotosNextPage()
        NotificationCenter.default
            .addObserver(forName: ImagesListService.didChangeNotification,
                         object: imagesListService,
                         queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController else { return }
            guard let indexPath = sender as? IndexPath else { return }
            let photo = photos[indexPath.row].largeImageURL
            guard let largeImageUrl = URL(string: photo) else { return }
            viewController.imageURL = largeImageUrl
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func updateTableViewAnimated() {
        guard view != nil else { return }
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    private func showAlertNetworkError() {
        let alert = AlertModel(
            title: "Что-то пошло не так(",
            massage: "Не удалось войти в систему",
            buttonText: "Ок",
            completion: { [weak self] in
                guard self != nil else { return }
            })
        alertPresenter?.showAlert(with: alert)
    }
}

//MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
}

//MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesListService.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imagesListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imagesListCell.delegate = self
        let photo = photos[indexPath.row]
        imagesListCell.configCell(photo: photo, for: imagesListCell)
        return imagesListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows,
           visibleIndexPaths.contains(indexPath) {
            guard indexPath.row + 1 == photos.count else { return }
            imagesListService.fetchPhotosNextPage()
        }
    }
}

// MARK: - Configuration imageListCell like
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        gradientLayer.animateLikeButton(cell.likeButton)
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(!photo.isLiked)
            case .failure(let error):
                showAlertNetworkError()
                assertionFailure("Error to change like info \(error)")
            }
            gradientLayer.stopLikeButton(cell, photo: photo)
            UIBlockingProgressHUD.dismiss()
        }
    }
}
