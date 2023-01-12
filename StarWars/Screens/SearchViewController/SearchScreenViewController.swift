//
//  SearchScreenViewController.swift
//  StarWars
//
//  Created by Aleksandr Skorotkin on 05.01.2023.
//

import Foundation
import UIKit
import Miji
import SwiftyJSON

class SearchScreenViewController: CustomViewController {
    @PersistentGlobalVariable(UserDefaultsKeys.RECENT_SEARCH_REQUESTS.rawValue, [])
    private var recentSearchRequests: [String]

    @IBOutlet private weak var searchTextFieldView: SearchScreenTextFieldView?
    @IBOutlet private weak var recentSearchResultsView: SearchScreenRecentRequestsView?
    @IBOutlet private weak var searchResultsView: SearchScreenResultsView?
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView?
    @IBOutlet private weak var noResultsView: SearchScreenNoResultsView?
    @IBOutlet private weak var statusBarView: UIView?
    @IBOutlet private weak var interfaceBlockingView: UIView?

    private let network = Network.shared
    
    private var context: Context?,
                nextPage: String?,
                previousPage: String?,
                results: [[String:Any]]?,
                state: SearchScreenViewControllerState = .noResults,
                previousSearchText = "",
                searchText = "",
                tableViewAdapter: TableViewAdapter?,
                dataFetcher: SearchScreenDataFetcher?,
                runSearchOnStart = false,
                observer: Any?,
                animatedPresentation = true
    
    static func fromStoryboard(
        context: Context,
        searchText: String,
        animatedPresentation: Bool = true
    ) -> UIViewController {
        let viewController: SearchScreenViewController = .fromStoryboard()
        viewController.context = context
        viewController.searchText = searchText
        viewController.animatedPresentation = animatedPresentation
        return viewController
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        unlockInterface()
        statusBarView?.backgroundColor = .purpleSW

        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .white

        searchTextFieldView?.delegate = self
        searchTextFieldView?.setFocus()
        searchTextFieldView?.set(text: searchText)
        searchTextFieldView?.set(backButtonIsHidden: true)

        recentSearchResultsView?.delegate = self
        searchResultsView?.delegate = self
        noResultsView?.delegate = self

        set(state: .specifyingSearchRequest)

        reloadRecentSearch()
    }

    private func blockInterfaceWhileLoading() {
        interfaceBlockingView?.show()
    }

    private func unlockInterface() {
        interfaceBlockingView?.hide()
    }

    private func reloadRecentSearch() {
        if recentSearchRequests.count < 1 {
            recentSearchResultsView?.isHidden = true
        }
        recentSearchResultsView?.set(recentRequests: recentSearchRequests)
    }

    private func saveToRecentSearchText(text _: String) {
        recentSearchRequests.insert(searchText, at: 0)
        recentSearchRequests = NSOrderedSet(array: recentSearchRequests).map { $0 as? String ?? "<UNKNOWN STRING>" }.filter { $0 != "<UNKNOWN STRING>" }
        if recentSearchRequests.count > 20 {
            recentSearchRequests = Array(recentSearchRequests.prefix(20)) as [String]
        }
        debugPrint(recentSearchRequests)
    }

    func reloadData() {
        searchResultsView?.set(
            nextPage: nextPage,
            previousPage: previousPage,
            results: results
        )
        set(state: .results)
    }

    private func performSearchText() {
        guard searchText.count > 0 else { return }
        results = [[:]]
        previousSearchText = searchText

        set(state: .fetching)

        guard let context else { return }

        dataFetcher = SearchScreenDataFetcher(
            context: context,
            delegate: self
        )
        dataFetcher?.fetch(endpointString: searchText)
    }
    
    private func proceedFutherWith(https: String?) {
        let correctText = https?.replacingOccurrences(of: "https://swapi.dev/api/", with: "") ?? ""
        searchTextFieldView?.set(text: correctText)
        searchText = correctText
        performSearchText()
    }

    private func set(state: SearchScreenViewControllerState) {
        self.state = state

        switch state {
        case .specifyingSearchRequest:
            reloadRecentSearch()
            recentSearchResultsView?.isHidden = false
            searchResultsView?.isHidden = true
            activityIndicatorView?.stop()
            noResultsView?.isHidden = true
            
        case .fetching:
            view.endEditing(true)
            recentSearchResultsView?.isHidden = true
            searchResultsView?.isHidden = results?.count ?? 0 < 1
            activityIndicatorView?.start()
            noResultsView?.isHidden = true

        case .results:
            searchTextFieldView?.resignFocus()
            recentSearchResultsView?.isHidden = true
            searchResultsView?.isHidden = false
            activityIndicatorView?.stop()
            noResultsView?.isHidden = true

        case .noResults:
            searchTextFieldView?.resignFocus()
            recentSearchResultsView?.isHidden = true
            searchResultsView?.isHidden = true
            activityIndicatorView?.stop()
            noResultsView?.isHidden = false
            reloadNoResultView()
        }
    }

    private func reloadNoResultView() {
        noResultsView?.set(
            searchText: searchText,
            examples: ["people/1/", "planets/3/", "starships/9/"],
            delegate: self
        )
    }

    private func handleSearchTextDidChange(text: String) {
        
    }
}

extension SearchScreenViewController: SearchScreenTextFieldViewDelegate {
    func searchScreenTextFieldViewTextDidChange(_: SearchScreenTextFieldView, text: String) {
        handleSearchTextDidChange(text: text)
    }

    func searchScreenTextFieldViewDidBeginEditing(_: SearchScreenTextFieldView) {
        set(state: .specifyingSearchRequest)
    }

    func searchScreenTextFieldViewDidTapSearchButton(_: SearchScreenTextFieldView, text: String) {
        searchText = text
        performSearchText()
    }

    func searchScreenTextFieldViewDidTapBackButton(_: SearchScreenTextFieldView) {
//        popBack(animated: animatedPresentation)
    }
}

extension SearchScreenViewController: SearchScreenDataFetcherDelegate {
    func searchScreenDataFetcher(_ fetcher: SearchScreenDataFetcher, didFetch error: Error?) {
        guard let error else {
            show(
                CustomError(errorLocalizedDescription: "'SearchScreenDataFetcher' did fetch Error, but can't recognize it like 'Error'")
            )
            return
        }
        show(error) {
            self.set(state: .noResults)
        }
    }

    func searchScreenDataFetcher(_ fetcher: SearchScreenDataFetcher, didFetch json: JSON) {
        debugPrint(json)
        guard state == .fetching else { return }
        if self.results?.count ?? 0 < 1 {
            searchResultsView?.scrollToTop()
        }
        separate(json: json) { results, previousPage, nextPage in
            self.results = results
            self.previousPage = previousPage
            self.nextPage = nextPage
        }
        searchResultsView?.set(nextPage: nextPage, previousPage: previousPage, results: results)
        if self.results?.count ?? 0 < 1 {
            set(state: .noResults)
        }
        else {
            set(state: .results)
        }
    }
    
    private func separate(json: JSON, completion: (([[String:Any]]?, String?, String?) -> Void)?) {
        var resultDictionary: [[String:Any]] = [[:]]
        if let arrayValue = json["results"].array {
            arrayValue.forEach { jsonElement in
                resultDictionary.append(
                    jsonToCorrectDictionary(
                        json: jsonElement
                    )
                )
            }
        } else if json.dictionary != nil {
            resultDictionary.append(
                jsonToCorrectDictionary(
                    json: json
                )
            )
        }
        
        let previous = json["previous"].string
        let next = json["next"].string
        completion?(resultDictionary, previous, next)
    }
    
    func jsonToCorrectDictionary(json:JSON) -> [String:Any] {
        var resultDictionaryElement: [String:Any] = [:]
        json.dictionary?.forEach({ (key: String, value: JSON) in
            if let string = value.string {
                resultDictionaryElement[key] = string
            } else if let array = value.array {
                var outputArray: [String] = []
                array.forEach({ outputArray.append($0.stringValue) })
                resultDictionaryElement[key] = outputArray
            }
        })
        return resultDictionaryElement
    }
}

extension SearchScreenViewController: SearchScreenResultsViewDelegate {
    func SearchScreenResultsViewDidTap(_ view: SearchScreenResultsView, https: String) {
        proceedFutherWith(https: https)
    }
    
    func SearchScreenResultsViewPreviousDidTap(_ view: SearchScreenResultsView, https: String?) {
        proceedFutherWith(https: https)
    }
    
    func SearchScreenResultsViewNextDidTap(_ view: SearchScreenResultsView, https: String?) {
        proceedFutherWith(https: https)
    }
}

extension SearchScreenViewController: SearchScreenRecentRequestsViewDelegate {
    func searchScreenRecentRequestsView(_: SearchScreenRecentRequestsView, didTapOnRecentRequest text: String) {
        proceedFutherWith(https: text)
    }
}

extension SearchScreenViewController: SearchScreenNoResultsViewDelegate {
    func searchScreenNoResultsView(_ view: SearchScreenNoResultsView, didTapOn example: String) {
        proceedFutherWith(https: example)
    }
}
