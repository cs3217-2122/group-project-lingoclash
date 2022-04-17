//
//  RevisionCreateDeckViewController.swift
//  LingoClash
//
//  Created by kevin chua on 2/4/22.
//
import UIKit
import Combine

class RevisionCreateDeckViewController: UIViewController {

    @IBOutlet weak var createDeckLabel: UITextField!
    
    weak var viewModel: RevisionViewModel?
    private var cancellables: Set<AnyCancellable> = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        deckAddedNotif.isHidden = true
        setUpBinders()
    }
    
    private func setUpBinders() {

    }

    @IBOutlet weak var deckAddedNotif: UILabel!
    
    // Create deck
    @IBAction func onTapActionSave(_ sender: Any) {
        let newDeckName = FormUtilities.getTrimmedString(textField: createDeckLabel)
        let newDeckFields = CreateDeckFields(newName: newDeckName)
        
        // Add deck locally
        viewModel?.addDeck(newDeckFields)
        
        createDeckLabel.text = ""
        deckAddedNotif.isHidden = false
        
        // Send api request to add a deck
        DeckManager().addDeck(newDeckFields: newDeckFields)
    }
}
