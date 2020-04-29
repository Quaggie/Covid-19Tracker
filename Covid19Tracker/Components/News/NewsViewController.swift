//
//  NewsViewController.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

final class NewsViewController: BaseViewController {
    enum State {
        case loading
        case success
        case error
    }

    // MARK: - Services
    private let newsService = NewsService()

    // MARK: - Properties
    private var state: State = .loading {
        didSet {
            changeUIFor(state: state)
        }
    }
    private var datasource: [News] = []
    private let sectionInset: UIEdgeInsets = .init(top: 24, left: 16, bottom: 16, right: 16)
    private let lineSpacing: CGFloat = 16
    private let interItemSpacing: CGFloat = 16
    
    // MARK: - Views
    private let titleLabel = UILabel(text: "News", font: Font.regular(size: 24), textColor: Color.white)
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical

        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .clear

        let bv = UIView()
        bv.backgroundColor = .clear
        cv.backgroundView = bv

        return cv
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private let loadingView = LoadingView()
    private lazy var errorView = ErrorView(delegate: self)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        registerCells()
        fetchData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tracker.screenView(name: "News")
    }

    // MARK: - Private functions
    private func registerCells() {
        collectionView.register(NewsCell.self)
    }

    private func fetchData() {
        //        state = .loading
        //
        //        countryService.fetch(country: countryName) { [weak self] (result) in
        //            guard let self = self else { return }
        //
        //            switch result {
        //            case .success(let country):
        //                self.historicalInfoService.fetch(country: country.country) { [weak self] (result) in
        //                    guard let self = self else { return }
        //
        //                    switch result {
        //                    case .success(let historicalInfo):
        //                        self.datasource = [
        //                            .totalCases(country),
        //                            .percentRate(type: .recovery, percent: Double(country.recovered) / Double(country.cases)),
        //                            .percentRate(type: .fatality, percent: Double(country.deaths) / Double(country.cases)),
        //                            .spreadOverTime(historicalInfo.timeline),
        //                            .todayCases(country)
        //                        ]
        //                        self.state = .success
        //                    case .failure:
        //                        self.state = .error
        //                    }
        //                }
        //            case .failure:
        //                self.state = .error
        //            }
        //        }

        datasource = [
            News(source: News.Source(id: "0", name: "The Washington Post"),
                 author: "Jonathan Bijos",
                 title: "Coronavirus Claims at Least 6,900 Nursing Home Deaths in U.S.",
                 description: "",
                 url: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659",
                 urlToImage: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659", publishedAt: "03/04/2020",
                 content: "asdfasdfasdfa sdf asdf a sdf as d as dfasdfasd fasdf asdfasdfa sdf a sdf asdf asdfasdfasd fa sdf as dfa sdfasdfasdfasdf as dfasdfasd fa sdfa s fda sd fa sdfasdfasdfasdfkas dfkas dfasdfjasndfjsndf aksjndfkajsndf kajsndfkjasndfkjanskfj askjdfnaskjdn akjsndfkajs fdkjansdjnaskjdfaksjdfnakjsdnf kasjndfa sjfnaks nfkasdnfajsndk ajsndkansfajsnd "),
            News(source: News.Source(id: "0", name: "The Washington Post"),
                 author: "Jonathan Bijos",
                 title: "Coronavirus Claims at Least 6,900 Nursing Home Deaths in U.S.",
                 description: "",
                 url: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659",
                 urlToImage: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659", publishedAt: "03/04/2020",
                 content: "asdfasdfasdfa sdf asdf a sdf as d as dfasdfasd fasdf asdfasdfa sdf a sdf asdf asdfasdfasd fa sdf as dfa sdfasdfasdfasdf as dfasdfasd fa sdfa s fda sd fa sdfasdfasdfasdfkas dfkas dfasdfjasndfjsndf aksjndfkajsndf kajsndfkjasndfkjanskfj askjdfnaskjdn akjsndfkajs fdkjansdjnaskjdfaksjdfnakjsdnf kasjndfa sjfnaks nfkasdnfajsndk ajsndkansfajsnd "),
            News(source: News.Source(id: "0", name: "The Washington Post"),
                 author: "Jonathan Bijos",
                 title: "Coronavirus Claims at Least 6,900 Nursing Home Deaths in U.S.",
                 description: "",
                 url: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659",
                 urlToImage: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659", publishedAt: "03/04/2020",
                 content: "asdfasdfasdfa sdf asdf a sdf as d as dfasdfasd fasdf asdfasdfa sdf a sdf asdf asdfasdfasd fa sdf as dfa sdfasdfasdfasdf as dfasdfasd fa sdfa s fda sd fa sdfasdfasdfasdfkas dfkas dfasdfjasndfjsndf aksjndfkajsndf kajsndfkjasndfkjanskfj askjdfnaskjdn akjsndfkajs fdkjansdjnaskjdfaksjdfnakjsdnf kasjndfa sjfnaks nfkasdnfajsndk ajsndkansfajsnd "),
            News(source: News.Source(id: "0", name: "The Washington Post"),
                 author: "Jonathan Bijos",
                 title: "Coronavirus Claims at Least 6,900 Nursing Home Deaths in U.S.",
                 description: "",
                 url: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659",
                 urlToImage: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659", publishedAt: "03/04/2020",
                 content: "asdfasdfasdfa sdf asdf a sdf as d as dfasdfasd fasdf asdfasdfa sdf a sdf asdf asdfasdfasd fa sdf as dfa sdfasdfasdfasdf as dfasdfasd fa sdfa s fda sd fa sdfasdfasdfasdfkas dfkas dfasdfjasndfjsndf aksjndfkajsndf kajsndfkjasndfkjanskfj askjdfnaskjdn akjsndfkajs fdkjansdjnaskjdfaksjdfnakjsdnf kasjndfa sjfnaks nfkasdnfajsndk ajsndkansfajsnd "),
            News(source: News.Source(id: "0", name: "The Washington Post"),
                 author: "Jonathan Bijos",
                 title: "Coronavirus Claims at Least 6,900 Nursing Home Deaths in U.S.",
                 description: "",
                 url: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659",
                 urlToImage: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659", publishedAt: "03/04/2020",
                 content: "asdfasdfasdfa sdf asdf a sdf as d as dfasdfasd fasdf asdfasdfa sdf a sdf asdf asdfasdfasd fa sdf as dfa sdfasdfasdfasdf as dfasdfasd fa sdfa s fda sd fa sdfasdfasdfasdfkas dfkas dfasdfjasndfjsndf aksjndfkajsndf kajsndfkjasndfkjanskfj askjdfnaskjdn akjsndfkajs fdkjansdjnaskjdfaksjdfnakjsdnf kasjndfa sjfnaks nfkasdnfajsndk ajsndkansfajsnd "),
            News(source: News.Source(id: "0", name: "The Washington Post"),
                 author: "Jonathan Bijos",
                 title: "Coronavirus Claims at Least 6,900 Nursing Home Deaths in U.S.",
                 description: "",
                 url: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659",
                 urlToImage: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659", publishedAt: "03/04/2020",
                 content: "asdfasdfasdfa sdf asdf a sdf as d as dfasdfasd fasdf asdfasdfa sdf a sdf asdf asdfasdfasd fa sdf as dfa sdfasdfasdfasdf as dfasdfasd fa sdfa s fda sd fa sdfasdfasdfasdfkas dfkas dfasdfjasndfjsndf aksjndfkajsndf kajsndfkjasndfkjanskfj askjdfnaskjdn akjsndfkajs fdkjansdjnaskjdfaksjdfnakjsdnf kasjndfa sjfnaks nfkasdnfajsndk ajsndkansfajsnd "),
            News(source: News.Source(id: "0", name: "The Washington Post"),
            author: "Jonathan Bijos",
            title: "Coronavirus Claims at Least 6,900 Nursing Home Deaths in U.S.",
            description: "",
            url: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659",
            urlToImage: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659", publishedAt: "03/04/2020",
            content: "asdfasdfasdfa sdf asdf a sdf as d as dfasdfasd fasdf asdfasdfa sdf a sdf asdf asdfasdfasd fa sdf as dfa sdfasdfasdfasdf as dfasdfasd fa sdfa s fda sd fa sdfasdfasdfasdfkas dfkas dfasdfjasndfjsndf aksjndfkajsndf kajsndfkjasndfkjanskfj askjdfnaskjdn akjsndfkajs fdkjansdjnaskjdfaksjdfnakjsdnf kasjndfa sjfnaks nfkasdnfajsndk ajsndkansfajsnd "),
            News(source: News.Source(id: "0", name: "The Washington Post"),
            author: "Jonathan Bijos",
            title: "Coronavirus Claims at Least 6,900 Nursing Home Deaths in U.S.",
            description: "",
            url: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659",
            urlToImage: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659", publishedAt: "03/04/2020",
            content: "asdfasdfasdfa sdf asdf a sdf as d as dfasdfasd fasdf asdfasdfa sdf a sdf asdf asdfasdfasd fa sdf as dfa sdfasdfasdfasdf as dfasdfasd fa sdfa s fda sd fa sdfasdfasdfasdfkas dfkas dfasdfjasndfjsndf aksjndfkajsndf kajsndfkjasndfkjanskfj askjdfnaskjdn akjsndfkajs fdkjansdjnaskjdfaksjdfnakjsdnf kasjndfa sjfnaks nfkasdnfajsndk ajsndkansfajsnd "),
            News(source: News.Source(id: "0", name: "The Washington Post"),
            author: "Jonathan Bijos",
            title: "Coronavirus Claims at Least 6,900 Nursing Home Deaths in U.S.",
            description: "",
            url: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659",
            urlToImage: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659", publishedAt: "03/04/2020",
            content: "asdfasdfasdfa sdf asdf a sdf as d as dfasdfasd fasdf asdfasdfa sdf a sdf asdf asdfasdfasd fa sdf as dfa sdfasdfasdfasdf as dfasdfasd fa sdfa s fda sd fa sdfasdfasdfasdfkas dfkas dfasdfjasndfjsndf aksjndfkajsndf kajsndfkjasndfkjanskfj askjdfnaskjdn akjsndfkajs fdkjansdjnaskjdfaksjdfnakjsdnf kasjndfa sjfnaks nfkasdnfajsndk ajsndkansfajsnd "),
            News(source: News.Source(id: "0", name: "The Washington Post"),
            author: "Jonathan Bijos",
            title: "Coronavirus Claims at Least 6,900 Nursing Home Deaths in U.S.",
            description: "",
            url: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659",
            urlToImage: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659", publishedAt: "03/04/2020",
            content: "asdfasdfasdfa sdf asdf a sdf as d as dfasdfasd fasdf asdfasdfa sdf a sdf asdf asdfasdfasd fa sdf as dfa sdfasdfasdfasdf as dfasdfasd fa sdfa s fda sd fa sdfasdfasdfasdfkas dfkas dfasdfjasndfjsndf aksjndfkajsndf kajsndfkjasndfkjanskfj askjdfnaskjdn akjsndfkajs fdkjansdjnaskjdfaksjdfnakjsdnf kasjndfa sjfnaks nfkasdnfajsndk ajsndkansfajsnd "),
            News(source: News.Source(id: "0", name: "The Washington Post"),
            author: "Jonathan Bijos",
            title: "Coronavirus Claims at Least 6,900 Nursing Home Deaths in U.S.",
            description: "",
            url: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659",
            urlToImage: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659", publishedAt: "03/04/2020",
            content: "asdfasdfasdfa sdf asdf a sdf as d as dfasdfasd fasdf asdfasdfa sdf a sdf asdf asdfasdfasd fa sdf as dfa sdfasdfasdfasdf as dfasdfasd fa sdfa s fda sd fa sdfasdfasdfasdfkas dfkas dfasdfjasndfjsndf aksjndfkajsndf kajsndfkjasndfkjanskfj askjdfnaskjdn akjsndfkajs fdkjansdjnaskjdfaksjdfnakjsdnf kasjndfa sjfnaks nfkasdnfajsndk ajsndkansfajsnd "),
            News(source: News.Source(id: "0", name: "The Washington Post"),
            author: "Jonathan Bijos",
            title: "Coronavirus Claims at Least 6,900 Nursing Home Deaths in U.S.",
            description: "",
            url: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659",
            urlToImage: "https://www.engeplus.com.br/cache/noticia/0145/0145283/santa-catarina-tem-1-235-casos-de-covid-19-confirmados.jpg?t=20200425144659", publishedAt: "03/04/2020",
            content: "asdfasdfasdfa sdf asdf a sdf as d as dfasdfasd fasdf asdfasdfa sdf a sdf asdf asdfasdfasd fa sdf as dfa sdfasdfasdfasdf as dfasdfasd fa sdfa s fda sd fa sdfasdfasdfasdfkas dfkas dfasdfjasndfjsndf aksjndfkajsndf kajsndfkjasndfkjanskfj askjdfnaskjdn akjsndfkajs fdkjansdjnaskjdfaksjdfnakjsdnf kasjndfa sjfnaks nfkasdnfajsndk ajsndkansfajsnd "),
        ]
        state = .success
    }

    private func changeUIFor(state: State) {
        switch state {
        case .loading:
            show(view: loadingView)
        case .success:
            show(view: collectionView)
            collectionView.reloadData()
        case .error:
            show(view: errorView)
        }
    }

    private func show(view: UIView) {
        [collectionView, loadingView, errorView].forEach { (v) in
            if view == v {
                v.isHidden = false
            } else {
                v.isHidden = true
            }
        }
    }
}

extension NewsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = datasource[indexPath.item]

        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as NewsCell
        cell.setup(model: model, index: indexPath.item)
        return cell
    }
}

extension NewsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.frame.width - sectionInset.left - sectionInset.right
        return .init(width: width, height: NewsCell.height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset
    }
}

extension NewsViewController: ErrorViewDelegate {
    func errorViewDidTapTryAgain() {
        fetchData()
    }
}

extension NewsViewController: CodeView {
    func buildViewHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(loadingView)
        view.addSubview(errorView)

        view.addSubview(titleLabel)
    }

    func setupConstraints() {
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          insets: .init(top: 36, left: sectionInset.left, bottom: 0, right: sectionInset.right))

        collectionView.anchor(top: titleLabel.bottomAnchor,
                              leading: view.leadingAnchor,
                              bottom: view.bottomAnchor,
                              trailing: view.trailingAnchor)

        loadingView.anchor(top: titleLabel.bottomAnchor,
                           leading: view.leadingAnchor,
                           bottom: view.bottomAnchor,
                           trailing: view.trailingAnchor)
        errorView.anchor(top: titleLabel.bottomAnchor,
                         leading: view.leadingAnchor,
                         bottom: view.bottomAnchor,
                         trailing: view.trailingAnchor)
    }

    func setupAdditionalConfiguration() {

    }
}
