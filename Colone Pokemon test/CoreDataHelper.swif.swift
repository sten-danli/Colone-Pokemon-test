//
//  CoreDataHelper.swift
//  Pokemon Go Clone
//
//  Created by zappycode on 6/29/18.
//  Copyright © 2018 Nick Walter. All rights reserved.
//

import UIKit
import CoreData

func addAllPokemon()
{
    createPokemon(name: "zombie", imageName: "zombie")
    createPokemon(name: "Pikachu", imageName: "pikachu")
    createPokemon(name: "Psyduck", imageName: "psyduck")
    createPokemon(name: "Snorlax", imageName: "snorlax")
    createPokemon(name: "Monster", imageName: "monster")
    createPokemon(name: "Monster1", imageName: "monster1")
    createPokemon(name: "Monster2", imageName: "monster2")
    createPokemon(name: "Monster3", imageName: "monster3")
    createPokemon(name: "Monster4", imageName: "monster4")
    createPokemon(name: "Monster5", imageName: "monster5")
    createPokemon(name: "Monster6", imageName: "monster6")
    createPokemon(name: "Monster7", imageName: "monster7")
    createPokemon(name: "Monster8", imageName: "monster8")
    createPokemon(name: "Monster9", imageName: "monster9")
    createPokemon(name: "Monster10", imageName: "monster10")
    createPokemon(name: "Monster11", imageName: "monster11")
    createPokemon(name: "Monster12", imageName: "monster12")
    createPokemon(name: "Monster13", imageName: "monster13")
    createPokemon(name: "Monster14", imageName: "monster14")
    createPokemon(name: "Monster15", imageName: "monster15")
    createPokemon(name: "Monster16", imageName: "monster16")

}


func createPokemon(name:String, imageName:String)
{
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    {
        let pokemon = Pokemon(context: context)
        pokemon.imageName = imageName
        pokemon.name = name
        try? context.save()

    }
}

func getAllPokemon() -> [Pokemon]
{
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext//得到context，其实就是硬盘
    {
        if let pokemons = try? context.fetch(Pokemon.fetchRequest()) as? [Pokemon] //尝试取出context内容，并交给pokemons
        {
            
            if pokemons.count == 0
            {
                addAllPokemon()
                return getAllPokemon()
            }
            else
            {
                addAllPokemon()
                return pokemons //如果不等于0就return pokemons(就是coredata contex里面存放的内容)
            }
        }
    }
    return []
}
    


