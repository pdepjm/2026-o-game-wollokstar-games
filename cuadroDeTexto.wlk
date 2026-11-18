import wollok.game.*
import instancias.*
import estados.*
import dialogos.*

class TextoDelCuadro {
    var property texto
    var property position
    const color = "FFFFFFFF"
    const tamanioDeLetra = 36
    
    method textSize() = tamanioDeLetra
    method text() = texto
    method textColor() = color
}

class Imagen {
    const property image
    const property position = game.origin()
}

object estiloDeTexto {
    method tamanioInteracciones() = 40
    method tamanioMenu() = 40
    method tamanioPistas() = 30
    method tamanioSospechosos() = 30
    method tamanioVeredicto() = 30
    method columnaDelMedio() = game.width().div(2)
}

class CuadroDeTexto {
    var property texto
    const textoVisual = new TextoDelCuadro(
    texto = texto,
    position = self.posicionDelTexto(),
    tamanioDeLetra = estiloDeTexto.tamanioInteracciones()
    )

    method position() = game.at(0,0)
    method image() = "fondoNegroCuadroDeTexto.png"

    method abrir(){
        game.addVisual(self)
        game.addVisual(textoVisual)
    }

    method cerrar(){
        game.removeVisual(textoVisual)
        game.removeVisual(self)
    }

    method posicionDelTexto() = game.at(estiloDeTexto.columnaDelMedio(), 2)
}

object cuadros {
    var cuadroActual = sinCuadro
    var objetoActual = sinObjeto

    method abrir(unCuadro, unObjeto){
        cuadroActual = unCuadro
        objetoActual = unObjeto
        cuadroActual.abrir()
        estadoDelJuego.cambiarA(enCuadro)
    }

    method cerrar(){
        const objeto = objetoActual
        cuadroActual.cerrar()
        self.reiniciar()
        estadoDelJuego.cambiarA(explorando)
        objeto.finalizarInteraccion()
    }

    method reiniciar(){
        cuadroActual = sinCuadro
        objetoActual = sinObjeto
    }
}

object sinCuadro {
    method abrir(){}
    method cerrar(){}
    method siguiente(){}
    method anterior(){}
}

object sinObjeto {
    method finalizarInteraccion(){}
}
