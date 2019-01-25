//
//  MapView.swift
//  igloo
//
//  Created by 冯奕琦 on 2019/1/25.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

import UIKit
import MapKit

class MapViewForGreatLocation: MKMapView,MKMapViewDelegate {
    
    //MARK: Init配置Delegate
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //对titile的分类创建AnnotionView 进行reuse的注册 ⚠️ 因为只展现一个所以不需要
        let data = annotation
        let view = StaticAnnotionView(annotation: data, reuseIdentifier: nil)
//        view.image = annotionImage 图片问题等等再解决🔧
        return view
    }
    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        //MKAnotationView被选中了 🔧
//    }
    
}

class AnnotionData:NSObject,MKAnnotation{//地点数据
    
    init(coordinate:CLLocationCoordinate2D,title:String) {
        self.coordinate = coordinate
        self.title = title
    }
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
}

class StaticAnnotionView:MKAnnotationView{//不可选中
    
    override func draw(_ rect: CGRect) {
        self.centerOffset = CGPoint(x: 0, y: -self.frame.size.height/2)
        super.draw(rect)
    }
    
}


class AnnotionView:StaticAnnotionView{//可以选中
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //更换Selected图片🔧
        if selected {
            //            self.image = annotionHighLightImage
        }else{
            //            self.image = annotionImage
        }
        print("Selected " + String(selected))
    }

    
}
