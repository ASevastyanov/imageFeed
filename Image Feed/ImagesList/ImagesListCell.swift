import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

//MARK: - UITableViewCell
final class ImagesListCell: UITableViewCell {
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    weak var delegate: ImagesListCellDelegate?
    static let reuseIdentifier = "ImagesListCell"
    private let imagesListService = ImagesListService.shared
    var photos = [Photo]()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    @IBAction private func likeButtonClicked(_ sender: UIButton) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        isLiked ? (likeButton.setImage(UIImage(named: "like_button_on"), for: .normal)) : (likeButton.setImage(UIImage(named: "like_button_off"), for: .normal))
    }
    
}

//MARK: - UITableViewCell
extension ImagesListCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let image = photos[indexPath.row].thumbImageURL
        let imageURL = URL(string: image)
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "Stub"),
                                   options: [.transition(.fade(2))]) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                cell.cellImage.contentMode = .scaleToFill
                cell.cellImage.image = image.image
            case .failure(let error):
                print("Error of loading image: \(error)")
                self.cellImage.image = UIImage(named: "imagePlaceholder")
            }
        }
        
        guard let date = photos[indexPath.row].createdAt else { return }
        cell.dateLabel.text = dateFormatter.string(from: date)
        let isLiked = photos[indexPath.row].isLiked
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}
