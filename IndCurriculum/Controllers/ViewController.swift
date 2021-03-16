//
//  ViewController.swift
//  IndCurriculum
//
//  Created by Akmaral on 3/15/21.
//

import UIKit

final class ViewController: UIViewController {

    private var lessons = [Lesson]()
    private var disciplines = [Discipline]()
    private var semester = [Semester]()
    private var modelProvider = ModelProvider()
    private var sampleData: SampleData!
    
    @IBAction func sharePressed(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [sampleData.documentURL], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBOutlet private var gridCollectionView: UICollectionView! {
        didSet {
            gridCollectionView.bounces = false
        }
    }
    
    @IBOutlet private var gridLayout: StickyGridCollectionViewLayout!
    {
        didSet {
            gridLayout.stickyRowsCount = 1
            gridLayout.stickyColumnsCount = 1
        }
    }
    
    @IBOutlet private var titleLabel: UILabel!
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        gridCollectionView.reloadData()
        self.gridCollectionView.reloadItems(at: gridCollectionView.indexPathsForVisibleItems)
        self.gridCollectionView.reloadData()
    }
    @IBOutlet weak var segmentedOutlet: UISegmentedControl!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelProvider.fetchData { (sampleData) in self.sampleData = sampleData}
        //disciplines
         sampleData.semesters.forEach{ item in
             disciplines.append(contentsOf: item.disciplines)
         }
         //lessons
         disciplines.forEach {item in lessons.append(contentsOf: item.lesson)}
         semester.append(contentsOf: sampleData.semesters)
        titleLabel.text = sampleData.title + " " + sampleData.academicYear
        self.gridCollectionView.delegate = self
        self.gridCollectionView.dataSource = self
    }
    
    
}

// MARK: - Collection view data source and delegate methods

extension ViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch segmentedOutlet.selectedSegmentIndex {
        case 0, 1:
            return 4
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch segmentedOutlet.selectedSegmentIndex {
        case 0, 1:
            return disciplines[section].lesson.count + 1
        default:
            return 0
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        let borderWidth: CGFloat = 0.5
        let borderColor: CGColor = .init(gray: 2, alpha: 1)
        cell.layer.borderWidth = borderWidth
        cell.layer.borderColor = borderColor
        
        switch segmentedOutlet.selectedSegmentIndex {
        case 0:
        if (indexPath.row == 0) && (indexPath.section == 0) {
            cell.sectionLabel.text = "Наименование дисциплины"
            cell.sectionLabel.textColor = .gray
            cell.backgroundColor = gridLayout.isItemSticky(at: indexPath) ? .systemGroupedBackground : .white
            return cell
        
        } else if (indexPath.row == 0) &&  (indexPath.section >= 1) {
            let discipline = semester[0].disciplines[indexPath.section-1]
            cell.sectionLabel.text = discipline.disciplineName.nameRu
            cell.sectionLabel.font = UIFont.boldSystemFont(ofSize: 14)
            cell.backgroundColor = gridLayout.isItemSticky(at: indexPath) ? .systemGroupedBackground : .white
            return cell
        
        } else if (indexPath.row > 0) && (indexPath.section == 0) {
            let lessonName = semester[0].disciplines[indexPath.section].lesson[indexPath.row-1].lessonTypeID
            if lessonName == "1" {
                cell.sectionLabel.text = "Лекция"
            } else if lessonName == "2" {
                cell.sectionLabel.text = "Семинар"
            } else {
                cell.sectionLabel.text = "Лаборат."
            }
            cell.sectionLabel.textColor = .gray
            cell.backgroundColor = gridLayout.isItemSticky(at: indexPath) ? .systemGroupedBackground : .white
            return cell
       
        } else if (indexPath.row > 0) && (indexPath.section > 0) {
            let cc = semester[0].disciplines[indexPath.section-1].lesson.count
            if (indexPath.row-1 >= cc) {
                cell.backgroundColor = gridLayout.isItemSticky(at: indexPath) ? .systemGroupedBackground : .white
                return cell
            }
            let lesson = semester[0].disciplines[indexPath.section-1].lesson[indexPath.row-1]
            cell.sectionLabel.text = lesson.realHours
            cell.section1Label.text = lesson.hours
            
            if lesson.realHours == lesson.hours {
                cell.sectionLabel.textColor = .green
                cell.section1Label.textColor = .green
            } else  {
                cell.sectionLabel.textColor = .green
                cell.section1Label.textColor = .red
            }
            
            
            cell.backgroundColor = gridLayout.isItemSticky(at: indexPath) ? .systemGroupedBackground : .white
            return cell
        }
        case 1:
            cell.sectionLabel.text = " "
            cell.backgroundColor = gridLayout.isItemSticky(at: indexPath) ? .systemGroupedBackground : .white
            return cell
        default: break
        } 
        return UICollectionViewCell()
    }

}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 80)
 
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let header = gridCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as? CollectionReusableView {
        header.headerLabel.text = "Аудиторные занятия в часах"
        
        return header
        }
        return UICollectionReusableView()
    }

}
