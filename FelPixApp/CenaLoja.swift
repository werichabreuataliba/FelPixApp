//
//  CenaLoja.swift
//  FelPixApp
//
//  Created by Macbook on 16/03/17.
//  Copyright © 2017 Werich. All rights reserved.
//

import UIKit
import  SpriteKit

class CenaLoja: SKScene {
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.lightGray
        
        
        
        let imagemFundo = SKSpriteNode(imageNamed: "bgAbout")
        imagemFundo.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        imagemFundo.size.width = self.size.width
        imagemFundo.size.height = self.size.height
        
        let botaoLojaTitulo = SKSpriteNode(imageNamed: "botaoLoja")
        let botaoSair = SKSpriteNode(imageNamed: "botaoSair")
        
        imagemFundo.texture?.filteringMode = .nearest
        botaoLojaTitulo.texture?.filteringMode = .nearest
        botaoSair.texture?.filteringMode = .nearest
        
        
        let botaoLojaSemente = SKSpriteNode(imageNamed: "botaoLojaSemente")
        let botaoLojaEstrela = SKSpriteNode(imageNamed: "botaoLojaEstrela")
        let botaoLojaSombra = SKSpriteNode(imageNamed: "botaoLojaSombra")
        let botaoLojaRestaura = SKSpriteNode(imageNamed: "botaoLojaRestaura")
        
        botaoLojaSemente.texture?.filteringMode = .nearest
        botaoLojaEstrela.texture?.filteringMode = .nearest
        botaoLojaSombra.texture?.filteringMode = .nearest
        botaoLojaRestaura.texture?.filteringMode = .nearest
        
        
        self.addChild(imagemFundo)
       
        botaoLojaSemente.setScale(0.85)
        botaoLojaEstrela.setScale(0.85)
        botaoLojaSombra.setScale(0.85)
        botaoLojaRestaura.setScale(0.85)
        botaoSair.setScale(2.3)
        botaoLojaTitulo.setScale(2.3)
        
        botaoLojaTitulo.position = CGPoint(x: self.size.width/2
            , y: self.size.height - botaoLojaTitulo.size.height/2 - 10)
        
        botaoLojaSemente.position = CGPoint(x: self.size.width/2
            , y: botaoLojaTitulo.position.y -  botaoLojaSemente.size.height/2 - 30 )
        
        botaoLojaEstrela.position = CGPoint(x: self.size.width/2
           , y: botaoLojaSemente.position.y - botaoLojaEstrela.size.height - 10 )
        
        botaoLojaSombra.position = CGPoint(x: self.size.width/2
            , y: botaoLojaEstrela.position.y -  botaoLojaEstrela.size.height/2  - botaoLojaSombra.size.height/2 - 10  )
        
       botaoLojaRestaura.position = CGPoint(x: self.size.width/2
           , y: botaoLojaSombra.position.y - botaoLojaSombra.size.height/2 - botaoLojaRestaura.size.height/2 - 10 )
        
       botaoSair.position = CGPoint(x: self.size.width/2
           , y: botaoLojaRestaura.position.y - botaoLojaRestaura.size.height/2 - botaoSair.size.height/2 - 10 )
 
        
        imagemFundo.zPosition = 0
        botaoLojaTitulo.zPosition = 1
        botaoLojaEstrela.zPosition = 2
        botaoLojaSombra.zPosition = 2
        botaoLojaRestaura.zPosition = 2
        botaoLojaSemente.zPosition = 2
        botaoSair.zPosition = 1
        
        botaoSair.name = "Botao Sair"
        
        self.addChild(botaoLojaTitulo)
        self.addChild(botaoSair)
        self.addChild(botaoLojaEstrela)
        self.addChild(botaoLojaSemente)
        self.addChild(botaoLojaSombra)
        self.addChild(botaoLojaRestaura)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch : AnyObject in touches{
            
            let posicaoTocada: CGPoint = touch.location(in: self)
            let objectTocado =  self.nodes(at: posicaoTocada)
            
            if objectTocado.count > 1
            {
                let nome =  objectTocado[0].name
                if nome != "" {
                    if nome == "Botao Sair"
                    {
                        //print("Tocou o \(nome)")
                        let transicao = SKTransition.reveal(with: SKTransitionDirection.left, duration: 1)
                        let cena = MenuInicio(size: self.size)
                        self.view?.presentScene(cena, transition: transicao)
                    }
                }
            }
    }
    }
}
