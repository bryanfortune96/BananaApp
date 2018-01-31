//
//  ApplicationAssembly.swift
//  Banana
//
//  Created by TQM on 10/13/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import Swinject

class ApplicationAssembly : Assembly {
    func loaded(resolver: Resolver) {
        print("ALL SERVICE ASSEMBLIES LOADED 😊")
    }
    
    func assemble(container: Container) {
        container.register(BananaServiceProtocol.self, factory: { r in
            BananaServiceRest()
        }).inObjectScope(.container)
        
    }
}

class ApplicationAssembler {
    
    public static let sharedInstance = ApplicationAssembler()
    let resolver : Resolver =  {
        print("getting resolver")
        return Assembler.init([ApplicationAssembly()]).resolver
    }()
}

