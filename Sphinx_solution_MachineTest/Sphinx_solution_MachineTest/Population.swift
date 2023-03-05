//
//  Population.swift
//  Sphinx_solution_MachineTest
//
//  Created by Mac on 04/03/23.
//

import Foundation
struct Data: Decodable{
    
    var Population:Int
    var year:String
    
    enum maincontenarkey:CodingKey{
        case Population,year
    }
    init(from decoder: Decoder) throws {
        let mainContenar = try decoder.container(keyedBy: maincontenarkey.self)
        Population = try! mainContenar.decode(Int.self, forKey: .Population)
        year = try! mainContenar.decode(String.self, forKey: .year)    }
}
