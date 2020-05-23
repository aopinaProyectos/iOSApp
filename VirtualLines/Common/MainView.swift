//
//  MainView.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/30/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//
import Foundation
import UIKit
import PureLayout

class MainView: UIView {
    
    private var searchBar: UISearchBar!
    private var searchButton: UIButton!
    private var resultsTable: UITableView!
    
    private let searchButtonHeight: CGFloat = 60
    private let searchButtonWidth: CGFloat = 200
    
    private let searchBarStartingAlpha: CGFloat = 0
    private let searchButtonStartingAlpha: CGFloat = 1
    private let tableStartingAlpha: CGFloat = 0
    private let searchBarEndingAlpha: CGFloat = 1
    private let searchButtonEndingAlpha: CGFloat = 0
    private let tableEndingAlpha: CGFloat = 1
    
    private let searchButtonStartingCornerRadius: CGFloat = 20
    private let searchButtonEndingCornerRadius: CGFloat = 0
    
    private var searchBarTop = false
    private var searchButtonWidthConstraint: NSLayoutConstraint?
    private var searchButtonEdgeConstraint: NSLayoutConstraint?
    private var didSetupConstraints = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    // MARK: - Initialization
    
    func setupViews() {
        setupSearchBar()
        setupSearchButton()
        setupResultsTable()
    }
    
    func setupSearchBar() {
        searchBar = UISearchBar.newAutoLayout()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.alpha = searchBarStartingAlpha
        addSubview(searchBar)
    }
    
    func setupSearchButton() {
        searchButton = UIButton(type: .custom)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.addTarget(self, action: Selector(("searchClicked:")), for: .touchUpInside)
        searchButton.setTitle("Search", for: .normal)
        searchButton.backgroundColor = .blue
        searchButton.layer.cornerRadius = searchButtonStartingCornerRadius
        addSubview(searchButton)
    }
    
    func setupResultsTable() {
        resultsTable = UITableView.newAutoLayout()
        resultsTable.alpha = tableStartingAlpha
        addSubview(resultsTable)
    }
    
    // MARK: - Layout
    
    override func updateConstraints() {
        if !didSetupConstraints {
            searchBar.autoAlignAxis(toSuperviewAxis: .vertical)
            searchBar.autoMatch(.width, to: .width, of: self)
            searchBar.autoPinEdge(toSuperviewEdge: .top)
            
            searchButton.autoSetDimension(.height, toSize: searchButtonHeight)
            searchButton.autoAlignAxis(toSuperviewAxis: .vertical)
            
            resultsTable.autoAlignAxis(toSuperviewAxis: .vertical)
            resultsTable.autoPinEdge(toSuperviewEdge: .leading)
            resultsTable.autoPinEdge(toSuperviewEdge: .trailing)
            resultsTable.autoPinEdge(toSuperviewEdge: .bottom)
            resultsTable.autoPinEdge(.top, to: .bottom, of: searchBar)
            
            didSetupConstraints = true
        }
        
        searchButtonWidthConstraint?.autoRemove()
        searchButtonEdgeConstraint?.autoRemove()
        
        if searchBarTop {
            searchButtonWidthConstraint = searchButton.autoMatch(.width, to: .width, of: self)
            searchButtonEdgeConstraint = searchButton.autoPinEdge(toSuperviewEdge: .top)
        } else {
            searchButtonWidthConstraint = searchButton.autoSetDimension(.width, toSize: searchButtonWidth)
            searchButtonEdgeConstraint = searchButton.autoAlignAxis(toSuperviewAxis: .horizontal)
        }
        
        super.updateConstraints()
    }
    
    // MARK: - User Interaction
    
    func searchClicked(sender: UIButton!) {
        showSearchBar(searchBar: searchBar)
    }
    
    // MARK: - Helpers
    
    func showSearchBar(searchBar: UISearchBar) {
        searchBarTop = true
        
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
        
        UIView.animate(withDuration: 0.3,
                                   animations: {
                                    searchBar.becomeFirstResponder()
                                    self.layoutIfNeeded()
        }, completion: { finished in
            UIView.animate(withDuration: 0.2,
                                       animations: {
                                        searchBar.alpha = self.searchBarEndingAlpha
                                        self.resultsTable.alpha = self.tableEndingAlpha
                                        self.searchButton.alpha = self.searchButtonEndingAlpha
                                        self.searchButton.layer.cornerRadius = self.searchButtonEndingCornerRadius
            }
            )
        }
        )
    }
    
    func dismissSearchBar(searchBar: UISearchBar) {
        searchBarTop = false
        
        UIView.animate(withDuration: 0.2,
                                   animations: {
                                    searchBar.alpha = self.searchBarStartingAlpha
                                    self.resultsTable.alpha = self.tableStartingAlpha
                                    self.searchButton.alpha = self.searchButtonStartingAlpha
                                    self.searchButton.layer.cornerRadius = self.searchButtonStartingCornerRadius
        }, completion:  { finished in
            self.setNeedsUpdateConstraints()
            self.updateConstraintsIfNeeded()
            UIView.animate(withDuration: 0.3,
                                       animations: {
                                        searchBar.resignFirstResponder()
                                        self.layoutIfNeeded()
            }
            )
        }
        )
    }
}

extension MainView: UISearchBarDelegate {
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        dismissSearchBar(searchBar: searchBar)
    }
}
