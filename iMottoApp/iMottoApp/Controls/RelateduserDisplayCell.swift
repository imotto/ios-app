//
//  RelateduserDisplayCell.swift
//  iMottoApp
//
//  Created by sunht on 16/10/10.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit
import ImageLoader

class RelateduserDisplayCell: UITableViewCell {

    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnMottos: UIButton!
    @IBOutlet weak var btnMotto: UIButton!
    @IBOutlet weak var btnFollows: UIButton!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var btnFollowers: UIButton!
    @IBOutlet weak var btnFollower: UIButton!
    @IBOutlet weak var btnScore: UIButton!
    @IBOutlet weak var btnLove: UIButton!
    @IBOutlet weak var imgSex: UIImageView!
    @IBOutlet weak var btnRank: UIButton!
    
    static var thumbPlaceholder:UIImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgThumb.layer.cornerRadius = self.imgThumb.frame.size.width/2
        self.imgThumb.clipsToBounds = true
        self.imgThumb.layer.borderWidth = 0.3
        self.imgThumb.layer.borderColor = UIColor.gray.cgColor
        
        self.imgSex.contentMode = .center
        
        self.btnScore.setImage(FAKMaterialDesignIcons.pollBoxIcon(withSize: 24).image(with: CGSize(width: 24, height: 24)).withRenderingMode(.alwaysTemplate), for: UIControlState())

        self.btnRank.isHidden = true
        
        if RelateduserDisplayCell.thumbPlaceholder == nil{
            let thumbIcon = FAKIonIcons.iosPersonIcon(withSize: 64)
            thumbIcon?.addAttributes([NSForegroundColorAttributeName: COLOR_BTN_TINT])
            RelateduserDisplayCell.thumbPlaceholder = thumbIcon?.image(with: CGSize(width: 64, height: 64))
        }

    }
    
    func setModel(_ user:RelatedUserModel){
        self.lblName.text = user.displayName
        self.btnMottos.setTitle(String(user.mottos), for: UIControlState())
        self.btnFollows.setTitle(String(user.follows), for: UIControlState())
        self.btnFollowers.setTitle(String(user.followers), for: UIControlState())
        self.btnScore.setTitle(String(user.revenue), for: UIControlState())
        self.btnRank.setTitle(String(user.revenue), for: UIControlState()) //should be rank
        
        setSex(user.sex)
        
        setRelation(user.relation)
        
        if user.thumb == ""{
            self.imgThumb.image = RelateduserDisplayCell.thumbPlaceholder
        }else{
            self.imgThumb.image = RelateduserDisplayCell.thumbPlaceholder
            self.imgThumb.load.request(with: user.thumb, onCompletion: { image, error, operation in
                if operation == .network {
                    let transition = CATransition()
                    transition.duration = 0.5
                    transition.type = kCATransitionFade
                    self.imgThumb.layer.add(transition, forKey: nil)
                    self.imgThumb.image = image
                }
            })
        }
        
    }
    
    func setRelation(_ relation:Int){
        printLog("\(relation)")
        if relation == 1{
            self.btnLove.setTitle("你喜欢TA", for: UIControlState())
            self.btnLove.setImage(ImgHeart, for: UIControlState())
        }else if relation == 2 {
            self.btnLove.setTitle("TA喜欢你", for: UIControlState())
            self.btnLove.setImage(ImgHeartOutLine, for: UIControlState())
        }else if relation == 3{
            self.btnLove.setTitle("互相喜欢", for: UIControlState())
            self.btnLove.setImage(ImgHeartPulse, for: UIControlState())
        }else if relation == 4{
            self.btnLove.setTitle("不喜欢TA", for: UIControlState())
            self.btnLove.setImage(ImgHeartBroken, for: UIControlState())
        }
        else if relation == 6{
            self.btnLove.setTitle("尴尬关系", for: UIControlState())
            self.btnLove.setImage(ImgHeartBroken, for: UIControlState())
        }
        else if relation == 0 {
            self.btnLove.setTitle("匆匆过客", for: UIControlState())
            self.btnLove.setImage(ImgHeartOutLine, for: UIControlState())
        }
    }
    
    func setSex(_ sex:Int){
        let imgSize:CGFloat = 14.0
        switch sex {
        case 1:
            self.imgSex.image = FAKIonIcons.femaleIcon(withSize: imgSize).image(with: CGSize(width: imgSize, height: imgSize)).withRenderingMode(.alwaysTemplate)
            self.imgSex.tintColor = UIColor.magenta
            break
        case 2:
            self.imgSex.image = FAKIonIcons.maleIcon(withSize: imgSize).image(with: CGSize(width: imgSize, height: imgSize)).withRenderingMode(.alwaysTemplate)
            self.imgSex.tintColor = COLOR_NAV_BG
            break
        default:
            self.imgSex.image = nil
            break
        }
    }


}
