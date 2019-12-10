//
//  SideMenuTableViewController.swift
//  CloneBlackboard
//
//  Created by 平良悠貴 on 2019/11/15.
//  Copyright © 2019 平良悠貴. All rights reserved.
//

import SideMenu


class SideMenuTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // refresh cell blur effect in case it changed
        tableView.reloadData()
        
        guard let menu = navigationController as? SideMenuNavigationController, menu.blurEffectStyle == nil else {
            return
        }
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! UITableViewVibrantCell

        if let menu = navigationController as? SideMenuNavigationController {
            cell.blurEffectStyle = menu.blurEffectStyle
        }
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
