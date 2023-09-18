import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

//MARK: - UITableViewCell
final class ImagesListCell: UITableViewCell {
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    weak var delegate: ImagesListCellDelegate?
    static let reuseIdentifier = "ImagesListCell"
    private let imagesListService = ImagesListService.shared
    private var gradientLayer = GradientLayer.shared
    
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
        let image = UIImage(named: isLiked ? "like_button_on" : "like_button_off")
        self.likeButton.setImage(image, for: .normal)
    }
}

//MARK: - UITableViewCell
extension ImagesListCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func configCell(photo: Photo, for cell: ImagesListCell){
        gradientLayer.gradientLayerTableView(
            view: cell,
            width: cell.frame.width - 32.0,
            height: cell.frame.height - 4.0,
            cornerRadius: 16, origin: CGPoint(x: 16, y: 0)
        )
        
        let image = photo.thumbImageURL
        let imageURL = URL(string: image)
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "Stub"),
                              options: [.transition(.fade(2))]) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.cellImage.contentMode = .scaleToFill
                self.gradientLayer.removeFromSuperLayer(views: [cell])
            case .failure(let error):
                print("Error of loading image: \(error)")
                self.cellImage.image = UIImage(named: "imagePlaceholder")
            }
        }
        
        guard let date = photo.createdAt else { return }
        dateLabel.text = dateFormatter.string(from: date)
        setIsLiked(photo.isLiked)
    }
}
