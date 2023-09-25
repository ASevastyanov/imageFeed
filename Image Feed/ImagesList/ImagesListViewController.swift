import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated()
    func showAlertNetworkError()
}

//MARK: - UIViewController
final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol{
    @IBOutlet weak private var tableView: UITableView!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var alertPresenter: AlertPresenterProtocol?
    var presenter: ImagesListPresenterProtocol?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ImagesListPresenter()
        presenter?.view = self
        presenter?.viewDidLoad()
        alertPresenter = AlertPresenter(viewControler: self)
    }
    
    //MARK: - Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController else { return }
            guard let indexPath = sender as? IndexPath else { return }
            let largeImageUrl = presenter?.getURLForlargeImage(indexPath: indexPath)
            viewController.imageURL = largeImageUrl
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableViewAnimated() {
        guard view != nil else { return }
        guard let (oldCount, newCount) = presenter?.photosCouneter() else { return }
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    func showAlertNetworkError() {
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
        guard let image = presenter?.photos[indexPath.row] else { return 10 }
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
        guard let presenter else { return 10 }
        return presenter.imagesListService.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imagesListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imagesListCell.delegate = self
        guard let photo = presenter?.photos[indexPath.row] else { return UITableViewCell() }
        imagesListCell.configCell(photo: photo, for: imagesListCell)
        return imagesListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows,
           visibleIndexPaths.contains(indexPath) {
            guard indexPath.row + 1 == presenter?.photos.count else { return }
            presenter?.imagesListService.fetchPhotosNextPage()
        }
    }
}

// MARK: - Configuration imageListCell like
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.likeChangeService(cell, indexPath)
    }
}
