//
//  GameViewController.swift
//  OneTapGame
//
//  Created by Túlio Bazan da Silva on 08/01/16.
//  Copyright © 2016 TulioBZ. All rights reserved.
//

import UIKit

//Tipos de Imagens - Image Types
enum itemType : Int {
    case Apple = 1
    case Shell
    case Firefox
    case Bking
}

extension UIView {
    
    //Seta uma image no objeto dado um tipo - Set a image to the Object given a type
    func setImageForType(newtype: itemType){
        if self is UIImageView{
            (self as! UIImageView).image = self.imageForType(newtype)
        }
        if self is UIButton{
            (self as! UIButton).setImage(self.imageForType(newtype), forState: .Normal)
            (self as! UIButton).setImage(self.imageForType(newtype), forState: .Selected)
        }
        
        self.tag = newtype.rawValue //Setar um tipo de Item como tag - Set a type as a tag
    }
    
    //Devolve uma imagem para um dado tipo - Match a image for a Type
    func imageForType(type: itemType) -> UIImage{
        var image : UIImage?
        
        switch type{
        case .Apple:
            image = UIImage(named: "apple")
            break
        case .Shell:
            image = UIImage(named: "shell")
            break
        case .Firefox:
            image = UIImage(named: "firefox")
            break
        case .Bking:
            image = UIImage(named: "bking")
            break
        default:
            break
        }
        
        return image!
    }
    
}

extension Array {
    /** This returns a random element from the Array
     */
    func random() -> Element? {
        if (self.count > 0) {
            return self[Int(arc4random_uniform(UInt32(self.count)))]
        }
        return nil
    }
    
    //Remove e devolve o primeiro elemento - Remove and get the first object at the list
    mutating func getFirst() -> Element? {
        if (self.count > 0) {
            let first = self[0]
            self.removeAtIndex(0)
            return first
        }
        return nil
    }
}


class GameViewController: UIViewController {

    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var imageDisplay: UIImageView!
    @IBOutlet var collectionOfButtons: Array<UIButton>? //Coleção de botões;
    @IBOutlet weak var newGame: UIButton!
   
    
    //Todos os tipos que tenho - All types I have
    let types = [itemType.Apple,itemType.Bking,itemType.Firefox,itemType.Shell]
    
    var points = 0
    
    var timer : NSTimer?
    
    //Devolve um item diferente de dados elementos - Give a Random type different than the two others
    func randomTypeDifferentOf(list: Array<itemType>, item1: itemType, item2: itemType) -> itemType {
        let different = list.random()
        
        if different != item1 && different != item2 {
            return different!
        }
        
        return randomTypeDifferentOf(list, item1: item1, item2: item2)
    }
    
    //Seta novas imagens aos elementos visuais - Set new Images to the Visual Elements
    func setNewTypeToElements(){
        
        //Invalido o Tempo
        timer?.invalidate()
        
        //Reseto as tags dos botões - Reset all Tags of Buttons
        for button in collectionOfButtons!{
            button.tag = 0
        }
        
        //Proximo item - Next item
        var nextItem : itemType?
        if imageDisplay.tag != 0 {
           nextItem = self.randomTypeDifferentOf(types, item1: itemType(rawValue: imageDisplay.tag)!, item2: itemType(rawValue: imageDisplay.tag)!)
        } else {
            nextItem = types.random()
        }
        
        
        //Proximas respostas - Next answers
        let secondAnswer = self.randomTypeDifferentOf(types, item1: nextItem!, item2: nextItem!)
        let thirdAnswer = self.randomTypeDifferentOf(types, item1: secondAnswer, item2: nextItem!)
        var nextAnswers = [secondAnswer,thirdAnswer]
        
        //Seta uma imagem na ImageView - Set image to ImageView
        imageDisplay.setImageForType(nextItem!)
        //E no Botão random de resposta - And to the Random Button
        collectionOfButtons?.random()?.setImageForType(nextItem!)
        
        //Seta as próximas respostas - Set the next Answers
        for button in collectionOfButtons!{
            if imageDisplay.tag != button.tag {
                
                button.setImageForType(nextAnswers.getFirst()!)
                
            }
        }
        
        //Depois de 1 seg. chama está função denovo - After 1 sec Call it again
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("setNewTypeToElements"), userInfo: nil, repeats: false)
        
    }
    
    //Checa se o botão combina com a imagem - Check if the button matches the image
    @IBAction func checkPress(sender: AnyObject) {
        
        //Testa o match - Test the Match
        if sender.tag == self.imageDisplay.tag {
            points++
        } else {
            points--
        }
        
        //Pontos não ficam negativos - Make points no possible to go negative
        if points < 0 {points = 0}
        
        //Checa vitoria - Check the Victory
        if points == 10 {
            //Para o timer - Stop timer
            timer?.invalidate()
            //Vitória - Victory
            pointsLabel.text = "Congrats! You make \(points) Points"
            
            //Mostra Novo Jogo - Show New Game
            imageDisplay.hidden = true
            for button in collectionOfButtons!{
                button.hidden = true
            }
            newGame.hidden = false
            
        } else {
            //Muda os pontos - Change Points Label
            pointsLabel.text = "Points \(points)"
            //Próxima Combinação - Next combination
            self.setNewTypeToElements()
        }

    }
    
    //Começa um jogo novo - Start a NewGame
    @IBAction func startGame(sender: AnyObject){
        
        //Mostra o jogo - Show Game
        imageDisplay.hidden = false
        for button in collectionOfButtons!{
            button.hidden = false
        }
        newGame.hidden = true
        
        //Reset Points
        points = 0
        pointsLabel.text = "Points \(points)"
        
        //Começa o Loop de elementos - Start Loop of Elements
        self.setNewTypeToElements()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mostra Novo Jogo - Show New Game
        imageDisplay.hidden = true
        for button in collectionOfButtons!{
            button.hidden = true
        }
        newGame.hidden = false
        
        //Text info
        pointsLabel.text = "New Game To Start"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
