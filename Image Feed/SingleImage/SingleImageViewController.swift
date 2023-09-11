import UIKit
import Kingfisher

//MARK: - UIViewController
final class SingleImageViewController: UIViewController {
    private var alertPresenter: AlertPresenterProtocol?
    var imageURL: URL! {
        didSet {
            guard isViewLoaded else { return }
            setImage()
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewControler: self)
        setImage()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    // MARK: - Actions
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func sharingButton() {
        let shere = UIActivityViewController(
            activityItems: [imageView.image!],
            applicationActivities: nil
        )
        present(shere, animated: true, completion: nil)
    }
    
    //MARK: - Methods
    private func setImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageURL) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showAlertNetworkError()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func showAlertNetworkError() {
        let alert = AlertModelTwoAction(
            title: "Что-то пошло не так(",
            massage: "Попробовать ещё раз?",
            buttonText: "Повторить",
            buttonTextCancel: "Не надо",
            completion: { [weak self] in
                guard let self else { return }
                self.setImage()
            })
        alertPresenter?.showAlertTwoAction(with: alert)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}
//MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

