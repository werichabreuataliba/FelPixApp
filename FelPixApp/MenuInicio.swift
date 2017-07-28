//
//  MenuInicio.swift
//  FelPixApp
//
//  Created by Macbook on 09/03/17.
//  Copyright © 2017 Werich. All rights reserved.
//

import SpriteKit

class MenuInicio: SKScene {

    
    override func didMove(to view: SKView) {
        carregarJogo()
        self.backgroundColor = UIColor.lightGray
        
        let imagemFundo = SKSpriteNode(imageNamed: "bgIntro")
        let botaoIniciar = SKSpriteNode(imageNamed: "botaoIniciar")
         let botaoRanking = SKSpriteNode(imageNamed: "botaoRanking")
         let botaoLoja = SKSpriteNode(imageNamed: "botaoLoja")
         let botaoSobre = SKSpriteNode(imageNamed: "botaoSobre")
        
        imagemFundo.size.width = self.size.width
        imagemFundo.size.height = self.size.height
        imagemFundo.texture?.filteringMode = .nearest
        imagemFundo.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
        
        self.addChild(imagemFundo)
        
        botaoIniciar.position.y = -20
        botaoRanking.position.y = -70
        botaoLoja.position.y = -120
        botaoSobre.position.y = -170
        
        botaoIniciar.position.x = 400
        botaoRanking.position.x = 400
        botaoLoja.position.x = 400
        botaoSobre.position.x = 400
        
        botaoIniciar.zPosition = 1
        botaoRanking.zPosition = 1
        botaoLoja.zPosition = 1
        botaoSobre.zPosition = 1
        
        botaoIniciar.setScale(2)
        botaoRanking.setScale(2)
        botaoLoja.setScale(2)
        botaoSobre.setScale(2)
        
        botaoIniciar.alpha = 0.2
        botaoRanking.alpha = 0.2
        botaoLoja.alpha = 0.2
        botaoSobre.alpha = 0.2
        
        let animacaoEntra = (SKAction.moveTo(x: 0, duration: 1))
        let animacaoAlfa = (SKAction.fadeAlpha(to: 1, duration: 1))
        
        botaoIniciar.run(SKAction.sequence([animacaoEntra, animacaoAlfa]))
        botaoRanking.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),animacaoEntra, animacaoAlfa]))
        botaoLoja.run(SKAction.sequence([SKAction.wait(forDuration: 1),animacaoEntra, animacaoAlfa]))
        botaoSobre.run(SKAction.sequence([SKAction.wait(forDuration: 1.5),animacaoEntra, animacaoAlfa]))
        
        
        botaoIniciar.name = "Botao Iniciar"
        botaoRanking.name = "Botao Ranking"
        botaoLoja.name = "Botao Loja"
        botaoSobre.name = "Botao Sobre"

        
        imagemFundo.addChild(botaoIniciar)
        imagemFundo.addChild(botaoRanking)
        imagemFundo.addChild(botaoLoja)
        imagemFundo.addChild(botaoSobre)
        
        let labelRecordes = SKLabelNode(fontNamed: "True Crimes")
        labelRecordes.fontSize = 17
        labelRecordes.text = "Recordes: \(recordePontos) pontos - \(recordeDistancia) metros"
        labelRecordes.position = CGPoint(x: self.size.width/2, y: self.size.height - 20)
        labelRecordes.zPosition = 2
        self.addChild(labelRecordes)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch : AnyObject in touches{
            
            let posicaoTocada: CGPoint = touch.location(in: self)
            let objectTocado =  self.nodes(at: posicaoTocada) 
            
            if objectTocado.count > 1
            {
                let nome =  objectTocado[0].name
                if nome != "" {
                if nome == "Botao Iniciar"
                {
                    //print("Tocou o \(nome)")
                    let transicao = SKTransition.doorway(withDuration: 1)
                    let cena = CenaJogo(size: self.size)
                    self.view?.presentScene(cena, transition: transicao)
                }
                if nome == "Botao Ranking"
                {
                     print("Tocou o \(nome)")
                }
                if nome == "Botao Loja"
                {
                    // print("Tocou o \(nome)")
                    let transicao = SKTransition.reveal(with: SKTransitionDirection.right, duration: 1)
                    let cena = CenaLoja(size: self.size)
                    self.view?.presentScene(cena, transition: transicao)
                }
                if nome == "Botao Sobre"
                {
                     print("Tocou o \(nome)")
                }
            }
            
            
        }
        }
    }
}
