//
//  DataMgr.swift
//  Banana
//
//  Created by TQM on 9/22/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import Foundation
class DataMgr {
    
    static let shared = DataMgr()
    
    var districtBitMask: Int32 = 0
    
    let districts: [District] = [District.init(title: "All", id: 0,isFavorite: true), District.init(title: "Quận 1", id: 1,popArea: "193.632 người - 7,73 km2"),District.init(title: "Quận 2", id: 2,popArea: "147.168 người - 49,74 km2"),District.init(title: "Quận 3", id: 3,popArea: "196.333 người - 4,92 km2"),District.init(title: "Quận 4", id: 4,popArea: "186.727 người - 4,18 km2"),District.init(title: "Quận 5", id: 5,popArea: "178.615 người - 4,27 km2"),District.init(title: "Quận 6", id: 6,popArea: "258.945 người - 7,19 km2"), District.init(title: "Quận 7", id: 7,popArea: "310.178 người - 35,69 km2"),District.init(title: "Quận 8", id: 8,popArea: "431.969 người - 19,18 km2"), District.init(title: "Quận 9", id: 9,popArea: "290.620 người - 114 km2"), District.init(title: "Quận 10", id: 10, popArea:"238.558 người - 5,72 km2"),District.init(title: "Quận 11", id: 11,popArea: "230.596 người - 5,14 km3"), District.init(title: "Quận 12", id: 12,popArea: "510.326 người - 52,78 km2"), District.init(title: "Gò Vấp", id: 13,popArea: "634.146 người - 19,74 km2"), District.init(title: "Tân Bình", id: 14,popArea: "459.029 người - 22,38 km2"), District.init(title: "Tân Phú", id: 15,popArea: "464.493 người - 16,06 km2"), District.init(title: "Bình Thạnh", id: 16,popArea: "487.985 người - 20,76 km2"), District.init(title: "Phú Nhuận", id: 17,popArea: "182.477 người - 4,88 km2"), District.init(title: "Thủ Đức", id: 18,popArea: "528.413 người - 48 km2"), District.init(title: "Bình Tân", id: 19,popArea: "686.474 ngời - 51,89 km2"), District.init(title: "Bình Chánh", id: 20,popArea: "591.451 người - 253 km2"), District.init(title: "Củ Chi", id: 21,popArea: "403.038 người - 435 km2"), District.init(title: "Hóc Môn", id: 22,popArea: "422.471 người - 109 km2"), District.init(title: "Nhà Bè", id: 23,popArea: "139.225 người - 100 km2"), District.init(title: "Cần Giờ", id: 24,popArea: "74.960 người - 704 km2")]
    
    var density = ["Đông xe","Ùn tắc","Ùn tắc nghiêm trọng"]
    var movability = ["Nhanh","Trung bình","Chậm","Rất chậm"]
    var bool = ["Không","Có"]
    var recommendation = ["Nên di chuyển","Không nên di chuyển"]
    var area = ["Không ùn tắc","Ùn tắc cục bộ(30-100m)","Ùn tắc trung bình(100-300m)","Ùn tắc kéo dài(300-1000m)","Ùn tắc toàn bộ đường"]
    var booleanStyle = [false,true]
    
    var months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    var years = ["2018"]
    var levels = ["Beginner","Bronze","Silver","Gold","Platinum"]
    
    func getDistricts() -> [District]
    {
        return districts
    }
    
    
    func getDistrict(title: String) -> District?
    {
        for s in districts
        {
            if s.title == title
            {
                return s
            }
        }
        return nil
    }
    
    func getDistrict(index: Int) -> District
    {
        return districts[index]
    }
    
    func getDistrictsCount() -> Int
    {
        return districts.count
    }
    
    func saveDistrictsBitMask()
    {
        districtBitMask = getDistrictsBitMask()
    }
    
    func hasDistrictsBitMaskChanged() -> Bool
    {
        let mask = getDistrictsBitMask()
        return  districtBitMask != mask
    }
    
    // This can support up to 32 stations
    func getDistrictsBitMask() -> Int32
    {
        var mask: Int32 = 0
        var shift: Int32 = 0
        for s in districts
        {
            shift += 1
            if s.isFavorite
            {
                mask += (1 << shift)
            }
        }
        return mask
    }
    
    
    //function to update isChecked states based on bit mask value
    func updateDistrict(districtsBitMask: Int32)
    {
        self.districtBitMask = districtsBitMask
        var shift: Int32 = 0
        var res = districtBitMask
        for i in (0...districts.count - 1).reversed()
        {
            shift = 1 << Int32(i + 1)
            districts[i].isFavorite = (res / (1 << Int32(i + 1)) == 1)
            res = res % (1 << Int32(i + 1))
        }
    }
    
}
