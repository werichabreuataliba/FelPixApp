//
//  CenaJogo.swift
//  FelPixApp
//
//  Created by Macbook on 16/03/17.
//  Copyright © 2017 Werich. All rights reserved.
//

import UIKit
import  SpriteKit

var numeroItensSementes:UInt = 0
var numeroItensEstrelas:UInt = 0
var recordePontos:UInt = 0
var recordeDistancia:UInt = 0

class CenaJogo: SKScene, SKPhysicsContactDelegate {
    var _comecou:Bool = false
    var felpudo = SKSpriteNode()
    let objetoDummyMovCena = SKNode()
    let grupoFelpudo:UInt32 = 1
    let grupoCano:UInt32 = 2
    let grupoMarcadores:UInt32 = 0
    var acabou:Bool = false
    var score:UInt=0
    var imagemFundo:SKSpriteNode = SKSpriteNode()
    let labelScore = SKLabelNode(fontNamed: "True Crimes")
    let labelDistancia = SKLabelNode(fontNamed: "True Crimes")
    var distancia:UInt = 0
    var scoreSeed:UInt = 100
    var scoreStar:UInt = 100
    let labelScoreStar = SKLabelNode(fontNamed: "True Crimes")
    let labelScoreSeed = SKLabelNode(fontNamed: "True Crimes")
    let textoInicio = SKLabelNode(fontNamed: "True Crimes")
    let imagemEstrela = SKSpriteNode(imageNamed:"estrela")
    let imagemSemente = SKSpriteNode(imageNamed:"semente1")
    var estadoInvencivel:Bool = false
    var estadoInvisivel:Bool = false
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.lightGray
        
        self.physicsWorld.contactDelegate = self
        
        carregarJogo()
        
        let moveFundo = SKAction.moveBy(x: -self.size.width, y: 0, duration: 9)
        let reposicionaFundo = SKAction.moveBy(x: self.size.width, y: 0, duration: 0)
        let moveFuncoSempre = SKAction.repeatForever(SKAction.sequence([moveFundo, reposicionaFundo]))
        
        var i:CGFloat = 0
        while i < 3
        {
            imagemFundo = SKSpriteNode(imageNamed: "bgGame")
            imagemFundo.size.width = self.size.width
            imagemFundo.size.height = self.size.height
            imagemFundo.position = CGPoint(x: self.size.width/2 + self.size.width * i, y: self.size.height/2)
            imagemFundo.run(moveFuncoSempre)
            imagemFundo.zPosition = -1
            imagemFundo.alpha = 0.85
            imagemFundo.texture?.filteringMode = .nearest
            objetoDummyMovCena.addChild(imagemFundo)
            i += 1
        }
        
        self.addChild(objetoDummyMovCena)
        
        
        var arrayImagensFelpudo:[SKTexture] = []
        var animacoesFelpudo = SKAction()
        
        var j:Int = 1
        while j < 6
        {
            let imagem = SKTexture(imageNamed: "felpudoVoa\(j)")
            imagem.filteringMode = .nearest
            arrayImagensFelpudo.append(imagem)
            j+=1
        }
        
        animacoesFelpudo = SKAction.animate(with: arrayImagensFelpudo, timePerFrame: 0.07, resize: false, restore: true)
        felpudo = SKSpriteNode(texture: arrayImagensFelpudo[1])
        felpudo.setScale(2.3)
        felpudo.position = CGPoint(x: self.size.width/3, y: self.size.height/2)
        felpudo.zPosition = 10
        felpudo.run(SKAction.repeatForever(animacoesFelpudo))
        self.addChild(felpudo)
        
        labelScore.fontSize = 150
        labelScore.text = "0"
        labelScore.position = CGPoint(x: self.size.width/2, y: self.size.height - 200)
        labelScore.zPosition = 2
        
        labelDistancia.fontSize = 17
        labelDistancia.text = "Distancia: 0 Metros"
        labelDistancia.position = CGPoint(x: (self.size.width/2)/3, y: self.size.height - 20)
        labelDistancia.zPosition = 2
        self.addChild(labelDistancia)
        
        self.addChild(labelScore)
        
        imagemSemente.setScale(15)
        imagemSemente.texture?.filteringMode = .nearest
        imagemSemente.position = CGPoint(x: self.size.width/5
            , y: self.size.height - self.size.height + 70 )
        
        imagemEstrela.setScale(15)
        imagemEstrela.texture?.filteringMode = .nearest
        imagemEstrela.position = CGPoint(x: self.size.width  - (self.size.width * 0.2)
            , y: self.size.height - self.size.height + 70 )
        
        imagemEstrela.name = "botaoEstrela"
        imagemSemente.name = "botaoSemente"
        
        labelScoreStar.fontSize = 70
        labelScoreStar.text = "0"
        labelScoreStar.position = CGPoint(x: self.size.width - (self.size.width * 0.2), y: self.size.height - self.size.height + 40 )
        labelScoreStar.zPosition = 2
        
        if(numeroItensEstrelas > 0)
        {
            labelScoreStar.text = "\(numeroItensEstrelas)"
        }
        
        labelScoreSeed.fontSize = 70
        labelScoreSeed.fontColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        labelScoreSeed.text = "0"
        labelScoreSeed.position = CGPoint(x: self.size.width - (self.size.width * 0.8), y: self.size.height - self.size.height + 40 )
        labelScoreSeed.zPosition = 2
        
        textoInicio.fontSize = 25
        textoInicio.text = "Toque para iniciar"
        textoInicio.position = CGPoint(x: self.size.width/2, y: self.frame.size.height/2 + 50)
        textoInicio.alpha = 0.65
        textoInicio.zPosition = 11
        
        self.addChild(textoInicio)
        self.addChild(labelScoreSeed)
        self.addChild(labelScoreStar)
        self.addChild(imagemSemente)
        self.addChild(imagemEstrela)
        
        let chaoDummy = SKNode()
        chaoDummy.position = CGPoint(x: self.size.width/2, y: 0)
        chaoDummy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: 1))
        chaoDummy.physicsBody?.isDynamic = false
        
        
        let tetoDummy = SKNode()
        tetoDummy.position = CGPoint(x: self.size.width/2, y: self.size.height+100)
        tetoDummy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: 1))
        tetoDummy.physicsBody?.isDynamic = false
        self.addChild(tetoDummy)
        
        chaoDummy.name = "Chao"
        tetoDummy.name = "Chao"
        
        self.addChild(chaoDummy)
        labelScore.isHidden =  true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch:AnyObject in touches{
        let posicaoTocada: CGPoint = touch.location(in: self)
        let objectTocado =  self.nodes(at: posicaoTocada)
        
        if objectTocado.count > 1
        {
            let nome =  objectTocado[0].name
            if nome != "" {
                if nome == "botaoReplay"
                {
                    self.removeAllActions()
                    let transicao = SKTransition.doorway(withDuration: 1)
                    let cena = CenaJogo(size: self.size)
                    self.view?.presentScene(cena, transition: transicao)
                }
                if nome == "botaoSair"
                {self.removeAllActions()
                    let transicao = SKTransition.doorsCloseVertical(withDuration: 1)
                    let cena = MenuInicio(size: self.size)
                    self.view?.presentScene(cena, transition: transicao)
                }
                
                if nome == "botaoSemente"
                {
                    if( (scoreSeed > 0) && !acabou){
                        scoreSeed -= 1
                        labelScoreSeed.text = String(scoreSeed)
                        self.ficaInvisivelOn()
                    }
                }
                if ((nome == "botaoEstrela" ) && !acabou) {
                    if(scoreStar > 0){
                        scoreStar -= 1
                        labelScoreStar.text = String(scoreStar)
                        self.ficaInvencivelOn()
                    }
                }
            }
            }
        
        
        if !acabou{
            self.criarParticulasPenas()
            
        if !_comecou{
        felpudo.physicsBody = SKPhysicsBody(circleOfRadius: felpudo.size.height/2)
        felpudo.physicsBody?.isDynamic = true
        felpudo.physicsBody?.allowsRotation = false
        felpudo.physicsBody?.collisionBitMask = grupoMarcadores
        felpudo.physicsBody?.categoryBitMask = grupoFelpudo
        felpudo.physicsBody?.contactTestBitMask = grupoCano
            
            labelScore.isHidden =  false
            textoInicio.isHidden =  true
            
            _comecou = true
            _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(CenaJogo.sorteiaObjects), userInfo: nil, repeats:false)
        }else{
        felpudo.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        felpudo.physicsBody?.applyImpulse(CGVector(dx: 0, dy:100))
            }
            }
    }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if _comecou
        {
            let num = (felpudo.physicsBody?.velocity.dy)! as CGFloat
            felpudo.zRotation = self.empinada(min:-1, max: 0.5, valor:num * 0.001)
        }
    }
    
    func empinada(min:CGFloat,max:CGFloat,valor:CGFloat )->CGFloat{
        if(valor > max){ return max}
        else if(valor < min){ return min }
        else{ return valor }
    }
   /*
    func sorteiaObjects(){
        let sorteio = Int(arc4random_uniform(10)+1)
        
        if(sorteio < 5 )
        { criarCanos() }
        if (sorteio > 5 &&  sorteio < 9) { criarObjSementes() }
        if sorteio == 9 { criarObjEstrela() }
        if sorteio == 4 { criarObjFlecha() }
        
        //criarCanos()
        _ = Timer.scheduledTimer(timeInterval: TimeInterval(3.5/speed)
            , target: self, selector: #selector(CenaJogo.sorteiaObjects), userInfo: nil, repeats: false)
        _ = Timer.scheduledTimer(timeInterval: 0.5
            , target: self, selector: #selector(CenaJogo.contaDistancia), userInfo: nil, repeats: true)
    }*/
    
    func sorteiaObjects(){
        let sorteio = Int(arc4random_uniform(10)+1)
        
        if(sorteio == 1 )
        { criarCanos() }
        if (sorteio == 2) { criarObjSementes() }
        if sorteio == 3 { criarObjEstrela() }
        if sorteio == 4 { criarObjFlecha() }
        
        //criarCanos()
        _ = Timer.scheduledTimer(timeInterval: TimeInterval(3.5/speed)
            , target: self, selector: #selector(CenaJogo.sorteiaObjects), userInfo: nil, repeats: false)
        _ = Timer.scheduledTimer(timeInterval: 0.5
            , target: self, selector: #selector(CenaJogo.contaDistancia), userInfo: nil, repeats: true)
    }
    
    func criarCanos(){
        
        let vao = SKNode()
        let objCanoCima = SKSpriteNode(imageNamed: "canoCima")
        let objCanoBaixo = SKSpriteNode(imageNamed: "canoBaixo")
        
        let moveCano = SKAction.moveBy(x: -self.frame.size.width * 3, y: 0, duration: TimeInterval(4/speed))
        let apagaCano = SKAction.removeFromParent()
        let sequenciaCano = SKAction.sequence([moveCano, apagaCano])
        let alturaVao = CGFloat(200)
        
        objCanoCima.setScale(3*0.75)
        objCanoBaixo.setScale(3*0.75)
        
        let numeroRandom = arc4random() % UInt32(100)
        let alturaRandom = CGFloat(numeroRandom) - 50
        
        objCanoBaixo.position = CGPoint(x: self.size.width + objCanoBaixo.size.width/2 + 10, y: alturaRandom)
        vao.position = CGPoint(x: objCanoBaixo.position.x + objCanoBaixo.size.width/2, y: objCanoBaixo.position.y + objCanoBaixo.size.height)
        objCanoCima.position = CGPoint(x: objCanoBaixo.position.x, y: objCanoBaixo.position.y + objCanoCima.size.height + alturaVao)
        
        objCanoCima.texture?.filteringMode = .nearest
        objCanoBaixo.texture?.filteringMode = .nearest
        objCanoCima.physicsBody = SKPhysicsBody(rectangleOf: objCanoCima.size)
        objCanoBaixo.physicsBody = SKPhysicsBody(rectangleOf: objCanoBaixo.size)
        
        vao.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 3, height: self.size.height*2))
        vao.physicsBody?.isDynamic = false
        objCanoCima.physicsBody?.isDynamic = false
        objCanoBaixo.physicsBody?.isDynamic = false
        objCanoCima.name = "CanoBaixo"
        objCanoBaixo.name = "CanoBaixo"
        vao.name = "Vao"
        
        vao.physicsBody?.collisionBitMask = grupoMarcadores
        vao.physicsBody?.categoryBitMask = grupoMarcadores
        vao.physicsBody?.contactTestBitMask = grupoFelpudo
        
        vao.run(sequenciaCano)
        objCanoBaixo.run(sequenciaCano)
        objCanoCima.run(sequenciaCano)
        
        objetoDummyMovCena.addChild(objCanoBaixo)
        objetoDummyMovCena.addChild(objCanoCima)
        objetoDummyMovCena.addChild(vao)
        
    }
    
    func criarObjSementes(){
        
        var itemSemente = SKSpriteNode(imageNamed:"semente1")
        let imgSeed1 = SKTexture(imageNamed: "semente1")
        let imgSeed2 = SKTexture(imageNamed: "semente2")
        let arraySemente:[SKTexture] = [imgSeed1, imgSeed2]
        
        let moveCano = SKAction.moveBy(x: -self.frame.size.width * 3, y: 0, duration: TimeInterval(4/speed))
        let apagaCano = SKAction.removeFromParent()
        let sequenciaCano = SKAction.sequence([moveCano, apagaCano])
        
        itemSemente = SKSpriteNode(texture: imgSeed1)
        
        itemSemente.setScale(3*1.3)
        itemSemente.texture?.filteringMode = .nearest
        itemSemente.physicsBody = SKPhysicsBody(rectangleOf: itemSemente.size)
        
        itemSemente.physicsBody?.isDynamic = false
        itemSemente.name = "Semente"
        itemSemente.run(SKAction.repeatForever(SKAction.animate(with: arraySemente, timePerFrame: 0.35)))
        let objPArent = SKNode()
        let randomPosicaoITem = CGFloat(arc4random_uniform(100)) - 50
        objPArent.position = CGPoint(x: self.size.width + 100, y: self.size.height/2 + randomPosicaoITem)
        objPArent.run(sequenciaCano)
        objPArent.addChild(itemSemente)
        
        itemSemente.physicsBody?.collisionBitMask = grupoMarcadores
        itemSemente.physicsBody?.categoryBitMask = grupoMarcadores
        itemSemente.physicsBody?.contactTestBitMask = grupoFelpudo
        
        itemSemente.run(sequenciaCano)
        
        objetoDummyMovCena.addChild(objPArent)
    
    }
    
    func criarObjEstrela(){
        
        let itemEstrela = SKSpriteNode(imageNamed:"estrela")
        
        let moveCano = SKAction.moveBy(x: -self.frame.size.width * 3, y: 0, duration: TimeInterval(4/speed))
        let apagaCano = SKAction.removeFromParent()
        let sequenciaCano = SKAction.sequence([moveCano, apagaCano])
        
        itemEstrela.setScale(3*1.3)
        itemEstrela.texture?.filteringMode = .nearest
        itemEstrela.physicsBody = SKPhysicsBody(rectangleOf: itemEstrela.size)
        
        itemEstrela.physicsBody?.isDynamic = false
        itemEstrela.name = "Estrela"
        let objPArent = SKNode()
        let randomPosicaoITem = CGFloat(arc4random_uniform(100)) - 50
        objPArent.position = CGPoint(x: self.size.width + 100, y: self.size.height/2 + randomPosicaoITem)
        objPArent.run(sequenciaCano)
        objPArent.addChild(itemEstrela)
        
        itemEstrela.physicsBody?.collisionBitMask = grupoMarcadores
        itemEstrela.physicsBody?.categoryBitMask = grupoMarcadores
        itemEstrela.physicsBody?.contactTestBitMask = grupoFelpudo
        
        itemEstrela.run(sequenciaCano)
        
        objetoDummyMovCena.addChild(objPArent)
        
    }
    
    func criarObjFlecha(){
        
        let itemFlecha = SKSpriteNode(imageNamed:"flecha")
        
        let moveCano = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0, duration: TimeInterval(2/speed))
        let apagaCano = SKAction.removeFromParent()
        let sequenciaCano = SKAction.sequence([moveCano, apagaCano])
        
        itemFlecha.setScale(3*1.3)
        itemFlecha.texture?.filteringMode = .nearest
        itemFlecha.physicsBody = SKPhysicsBody(rectangleOf: itemFlecha.size)
        
        itemFlecha.physicsBody?.isDynamic = false
        itemFlecha.name = "CanoBaixo"
        let objPArent = SKNode()
        let randomPosicaoITem = CGFloat(arc4random_uniform(100)) - 50
        objPArent.position = CGPoint(x: self.size.width + 100, y: self.size.height/2 + randomPosicaoITem)
        objPArent.run(sequenciaCano)
        objPArent.addChild(itemFlecha)
        
        itemFlecha.physicsBody?.collisionBitMask = grupoMarcadores
        itemFlecha.physicsBody?.categoryBitMask = grupoMarcadores
        itemFlecha.physicsBody?.contactTestBitMask = grupoFelpudo
        
        itemFlecha.run(sequenciaCano)
        
        objetoDummyMovCena.addChild(objPArent)
        
    }

    func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == grupoMarcadores || contact.bodyB.categoryBitMask == grupoMarcadores{
            if( contact.bodyA.node?.name == "Vao"){
                if(_comecou){
                   score += 1
                   labelScore.text = String(score)
                }
                contact.bodyA.node?.removeFromParent()
            }
        }
    }
    
    func botoesGameOver(){
        var botaoInicio:SKSpriteNode = SKSpriteNode()
        var botaoReplay:SKSpriteNode = SKSpriteNode()
        
        botaoInicio = SKSpriteNode(imageNamed: "botaoSair")
        botaoInicio.texture?.filteringMode = .nearest
        
        botaoInicio.position = CGPoint(x: self.size.width/2
            , y: self.size.height/2 - 30 )
        botaoInicio.setScale(3)
        botaoInicio.position.x += 400
        botaoInicio.zPosition = 12
        let acaoEntraBotao = SKAction.moveBy(x: -400, y: 0, duration: 0.5)
        botaoInicio.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), acaoEntraBotao]))
        
        botaoReplay = SKSpriteNode(imageNamed: "botaoReplay")
        botaoReplay.texture?.filteringMode = .nearest
        
        botaoReplay.position = CGPoint(x: self.size.width/2
            , y: self.size.height/2 + 50 )
        botaoReplay.setScale(3)
        botaoReplay.position.x += 400
        botaoReplay.zPosition = 12
        botaoReplay.run(SKAction.sequence([SKAction.wait(forDuration: 0.1), acaoEntraBotao]))
        
        botaoReplay.name = "botaoReplay"
        botaoInicio.name = "botaoSair"
        
        self.addChild(botaoInicio)
        self.addChild(botaoReplay)
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
            if( (contact.bodyA.node?.name == "CanoBaixo") && !estadoInvisivel && !estadoInvencivel ){
                
                acabou = true
                objetoDummyMovCena.speed = 0
                imagemFundo.speed = 0
                felpudo.physicsBody?.applyImpulse(CGVector(dx: -200, dy: 0))
                
                _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(CenaJogo.botoesGameOver), userInfo: nil, repeats: false)
                
                salvarRecordes()
                
            }
        if( contact.bodyA.node?.name == "Semente"){
            criaFumacinha(objeto: (contact.bodyA.node?.parent)!)
            scoreSeed += 1
            labelScoreSeed.text = String(scoreSeed)
           contact.bodyA.node?.removeFromParent()
            numeroItensSementes += 1
        }
        if( contact.bodyA.node?.name == "Estrela"){
            criaFumacinha(objeto: (contact.bodyA.node?.parent)!)
            scoreStar += 1
            labelScoreStar.text = String(scoreStar)
            contact.bodyA.node?.removeFromParent()
            numeroItensEstrelas += 1
        }
    }
    func criaFumacinha(objeto:SKNode){
        let fumacinha = SKSpriteNode(imageNamed: "fumacinha")
        fumacinha.position = objeto.position
        fumacinha.run(SKAction.sequence( [SKAction.scale(by: 3.5, duration: 0.15), SKAction.removeFromParent()] ))
        fumacinha.run(SKAction.fadeAlpha(to: 0, duration: 0.15))
        fumacinha.texture?.filteringMode = .nearest
        fumacinha.zPosition = 20
        objetoDummyMovCena.addChild(fumacinha)
    }
    
    func contaDistancia(){
        if(!acabou)
        {
            distancia += 1
            labelDistancia.text = "Metros \(distancia)"
        }
    }
    
    func ficaInvencivelOn(){
        if !estadoInvencivel {
            
            estadoInvencivel = true
            Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(CenaJogo.ficaInvencivelOff), userInfo: nil, repeats: false)
            felpudo.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            apagaBotoesHud()
            self.backgroundColor = UIColor.white
            physicsWorld.speed = 2
            speed = 2
            criarParticulasEstrelas()
        }
    }
    
    func ficaInvencivelOff(){
        if estadoInvencivel {
            
            
            felpudo.run(SKAction.sequence([SKAction.fadeAlpha(to: 1, duration: 0.5), SKAction.wait(forDuration: 0.5)
                ,SKAction.run {
                    
                    self.estadoInvencivel = false
                    self.acendeBotoesHud()
                }]))
            
            self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
            felpudo.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            felpudo.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0))
            
            physicsWorld.speed = 1
            speed = 1
            self.backgroundColor = UIColor.black
            
            
        }
    }
    
    func ficaInvisivelOn(){
        if !estadoInvisivel{
            estadoInvisivel = true
            _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(CenaJogo.ficaInvisivelOff), userInfo: nil, repeats: false)
            felpudo.run(SKAction.fadeAlpha(to: 0.25, duration: 0.5))
            apagaBotoesHud()
        }
    }
    
    func ficaInvisivelOff(){
        
        if estadoInvisivel {
            felpudo.run(SKAction.sequence([SKAction.fadeAlpha(to: 1, duration: 0.5), SKAction.wait(forDuration: 0.5)
                ,SKAction.run({
                    self.estadoInvisivel = false
                    self.acendeBotoesHud()
                    }
                    
                )]))
        }
    }
    
    func apagaBotoesHud()
    {
        imagemEstrela.run(SKAction.fadeAlpha(to: 0.15, duration: 0.5))
        imagemSemente.run(SKAction.fadeAlpha(to: 0.15, duration: 0.5))
        
        labelScoreStar.run(SKAction.fadeAlpha(to: 0.15, duration: 0.5))
        labelScoreSeed.run(SKAction.fadeAlpha(to: 0.15, duration: 0.5))
        
        imagemSemente.name = "xxx"
        imagemEstrela.name = "xxx"
    }
    
    func acendeBotoesHud()
    {
        imagemEstrela.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        imagemSemente.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        
        labelScoreStar.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        labelScoreSeed.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        
        imagemSemente.name = "botaoSemente"
        imagemEstrela.name = "botaoEstrela"
    }
    
    func criarParticulasPenas(){
            let peninha = SKTexture(imageNamed: "pena")
        let emissorPenas:SKEmitterNode = SKEmitterNode()
        emissorPenas.particleTexture = peninha
        emissorPenas.position = CGPoint(x: felpudo.position.x + 20, y: felpudo.position.y + felpudo.size.height/2)
        emissorPenas.particleBirthRate = 100
        emissorPenas.numParticlesToEmit = 7
        emissorPenas.particleLifetime = 1.3
        emissorPenas.particleTexture?.filteringMode = .nearest
        emissorPenas.xAcceleration = 0
        emissorPenas.yAcceleration = 0
        emissorPenas.particleSpeed = 100
        emissorPenas.particleSpeedRange = 200
        emissorPenas.particleRotationSpeed = -10
        emissorPenas.particleRotationRange = 4
        emissorPenas.emissionAngle = 3
        emissorPenas.emissionAngleRange = 3.14
        emissorPenas.particleColorAlphaSpeed = 0.1
        emissorPenas.particleColorAlphaRange = 1
        emissorPenas.particleAlphaSequence = SKKeyframeSequence(keyframeValues: [1,0], times: [0,1])
        emissorPenas.particleScaleSequence = SKKeyframeSequence(keyframeValues: [3,0.5], times: [0,1])
        
        if( estadoInvisivel || estadoInvencivel ){
            emissorPenas.alpha=0.15
        }
        self.addChild(emissorPenas)
        emissorPenas.run(SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.removeFromParent()]))
    }
    
    func criarParticulasEstrelas(){
        let estrelinha = SKTexture(imageNamed: "estrela")
        let emissorEstrelas:SKEmitterNode = SKEmitterNode()
        emissorEstrelas.particleTexture = estrelinha
        emissorEstrelas.particleBirthRate = 17
        emissorEstrelas.numParticlesToEmit = 10000
        emissorEstrelas.particleLifetime = 0.55
        emissorEstrelas.particleTexture?.filteringMode = .nearest
        emissorEstrelas.xAcceleration = 0
        emissorEstrelas.yAcceleration = 0
        emissorEstrelas.particleSpeed = 90
        emissorEstrelas.particleSpeedRange = 100
        emissorEstrelas.particleRotationSpeed = 5
        emissorEstrelas.particleRotationRange = 10
        emissorEstrelas.emissionAngleRange = 3.14
        emissorEstrelas.particleColorAlphaSpeed = CGFloat(M_PI*2)
        emissorEstrelas.particleAlphaSequence = SKKeyframeSequence(keyframeValues: [0,1,1,0], times: [0,0.15,0.75,1])
        emissorEstrelas.particleScaleSequence = SKKeyframeSequence(keyframeValues: [0.85,0.85,0], times: [0,0.75,1])
        felpudo.addChild(emissorEstrelas)
        
        emissorEstrelas.run(SKAction.sequence([SKAction.wait(forDuration: 10), SKAction.removeFromParent()]))
 
        let emiterPath = Bundle.main.path(forResource: "ParticulaVelocidade", ofType: "sks")
        let emiterNode = NSKeyedUnarchiver.unarchiveObject(withFile: emiterPath!) as! SKEmitterNode
        emiterNode.position = CGPoint(x: self.size.width+50, y: self.size.height/2)
        emiterNode.name = "emiterNode"
        emiterNode.zPosition = 10
        emiterNode.targetNode = self
        emiterNode.particleTexture?.filteringMode = .nearest
        self.addChild(emiterNode)
        emiterNode.run(SKAction.sequence([SKAction.wait(forDuration: 10), SKAction.removeFromParent()]))
        
    }
    
    func salvarRecordes(){
        if(UInt(UserDefaults.standard.integer(forKey: "Recorde Pontos")) < score){
            recordePontos = score
            UserDefaults.standard.set(recordePontos, forKey: "Recorde Pontos")
            salvarJogos()
        }
        if(UInt(UserDefaults.standard.integer(forKey: "Recorde Distancia")) < distancia)
        {
            recordeDistancia = distancia
            UserDefaults.standard.set(recordeDistancia, forKey: "Recorde Distancia")
            salvarJogos()
        }
    }
    
    func salvarJogos(){
        UserDefaults.standard.set(numeroItensSementes, forKey: "Numero Sementes")
        UserDefaults.standard.set(numeroItensEstrelas, forKey: "Numero Estrelas")
        UserDefaults.standard.synchronize()
    }
    
}
func carregarJogo()
{
    recordeDistancia = UInt(UserDefaults.standard.integer(forKey: "Recorde Distancia"))
    recordePontos = UInt(UserDefaults.standard.integer(forKey: "Recorde Pontos"))
    numeroItensSementes = UInt(UserDefaults.standard.integer(forKey: "Numero Sementes"))
    numeroItensEstrelas = UInt(UserDefaults.standard.integer(forKey: "Numero Estrelas"))
}
