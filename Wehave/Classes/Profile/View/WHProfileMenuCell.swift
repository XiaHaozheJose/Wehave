//
//  WHProfileMenuCell.swift
//  Wehave
//
//  Created by JS_Coder on 2018/5/11.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class WHProfileMenuCell: UICollectionViewCell {
    enum MenuName: String {
        case Colección = "Colección"
        case Descarga = "Descarga"
        case Pedido = "Pedido"
        case Diario = "Diario"
        case Preguntas = "Preguntas"
        case Comentarios = "Comentarios"
        case Cupónes = "Cupónes"
        case Cartera = "Cartera"
        case Festivos = "Festivos"
    }
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
    
    var title: String?{
        didSet{
            var name = ""
            switch title! {
            case MenuName.Colección.rawValue:
                name = MenuName.Colección.rawValue.localized
            case MenuName.Descarga.rawValue:
                name = MenuName.Descarga.rawValue.localized
            case MenuName.Pedido.rawValue:
                name = MenuName.Pedido.rawValue.localized
            case MenuName.Diario.rawValue:
                name = MenuName.Diario.rawValue.localized
            case MenuName.Preguntas.rawValue:
                name = MenuName.Preguntas.rawValue.localized
            case MenuName.Comentarios.rawValue:
                name = MenuName.Comentarios.rawValue.localized
            case MenuName.Cupónes.rawValue:
                name = MenuName.Cupónes.rawValue.localized
            case MenuName.Cartera.rawValue:
                name = MenuName.Cartera.rawValue.localized
            case MenuName.Festivos.rawValue:
                name = MenuName.Festivos.rawValue.localized
            default: break
            }
            menuLabel.text = name
        }}
    
    var image: UIImage?{
        didSet{
            menuImage.image = image!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

}
