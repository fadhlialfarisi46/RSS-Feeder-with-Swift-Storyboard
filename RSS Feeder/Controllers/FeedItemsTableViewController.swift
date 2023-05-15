//
//  FeedItemsTableViewController.swift
//  RSS Feeder
//
//  Created by muhammad.alfarisi on 14/05/23.
//

import UIKit

class FeedItemsTableViewController: UITableViewController, XMLParserDelegate {
    
    var feedItems = [FeedItem]()
    var parser = XMLParser()
    var entryTitle: String!
    var entryLink: String!
    var entryDesc: String!
    var currentParsedElement = String()
    var insideAnItem = false
    
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLoadingScreen()
        setDatabase()
    }
    
    func setLoadingScreen() {
        // Sets the view which contains the loading text and the spinner
//        let width: CGFloat = 120
//        let height: CGFloat = 30
//        let x = (tableView.frame.width / 2) - (width / 2)
//        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
//        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
//
//
//        // Sets spinner
        spinner.style = .medium
//        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        spinner.startAnimating()
//
//        // Adds text and spinner to the view
//        loadingView.addSubview(spinner)
        
        spinner.startAnimating()
        tableView.backgroundView = spinner
//        tableView.addSubview(loadingView)
    }
    
    func removeLoadingScreen() {
        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        tableView.backgroundView = nil
    }
    
    func setDatabase() {
        let dataStore = SQLiteDataStore.sharedIntance
        do {
            try dataStore.createTable()
        } catch _ {
            print("error")
        }
        
        do {
            let feeds = try FeedDataHelper.findAll()
            for feed in feeds! {
                
                if let url = URL(string: feed.address!) {
                    let task = URLSession.shared.dataTask(with: url ) { [self] (data, response, error) in
                        if data == nil {
                            print("dataTaskWithRequest error: \(String(describing: error?.localizedDescription))")
                            return
                        }
                        parser = XMLParser(contentsOf: url)!
                        parser.delegate = self
                        parser.parse()
                    }
                    
                    task.resume()
                }
            }
            for feedItem in feedItems {
                print(feedItem.title)
            }
        } catch let error {
            print(error)
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        print("Started parsing...")
        
        if elementName == "item" {
            insideAnItem = true
        }
        if insideAnItem {
            switch elementName {
            case "title":
                entryTitle = String()
                currentParsedElement = "title"
            case "description":
                entryDesc = String()
                currentParsedElement = "description"
            case "link":
                entryLink = String()
                currentParsedElement = "link"
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if insideAnItem {
            switch currentParsedElement {
            case "title":
                entryTitle = entryTitle + string
            case "description":
                entryDesc = entryDesc + string
            case "link":
                entryLink = entryLink + string
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("ended parsing...")
        
        if insideAnItem {
            switch elementName {
            case "title":
                currentParsedElement = ""
            case "description":
                currentParsedElement = ""
            case "link":
                currentParsedElement = ""
            case "item":
                let feedItem = FeedItem(title: entryTitle, description: entryDesc, link: entryLink)
                feedItems.append(feedItem)
                insideAnItem = false
            default:
                break
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            self.removeLoadingScreen()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feedItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "FeedItemTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FeedItemTableViewCell
        
        let feed = feedItems[indexPath.row]
        
        let firstLetter = String(feed.title.first!)
        
        let data = Data(feed.description.utf8)
        DispatchQueue.main.async {
            if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                cell.descLabel.text = attributedString.string
            }
        }
        
        cell.largeLabel.text = firstLetter
        cell.titleLabel.text = feed.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FeedItemDetailViewController") as! WebViewController
        vc.feedItem = feedItems[indexPath.row]
        self.show(vc, sender: self)
    }
}
