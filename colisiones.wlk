import wollok.game.*
import instancias.*

class Colision {
    var property position

    method ocupa(unaPosicion) = position == unaPosicion

}

object colisiones {
    var solidos = []

    method cargar(nuevosSolidos){
        solidos = nuevosSolidos
    }

    method limpiar(){
        solidos = []
    }

    method hayColisionEn(unaPosicion){
        return solidos.any({
            unSolido => unSolido.ocupa(unaPosicion)
        })
    }

    // Ayudas para armar paredes sin escribir casilla por casilla
    method fila(y, desdeX, hastaX){
        return (desdeX..hastaX).map({
            x => new Colision(position = game.at(x,y))
        })
    }

    method columna(x, desdeY, hastaY){
        return (desdeY..hastaY).map({
            y => new Colision(position = game.at(x,y))
        })
    }
}