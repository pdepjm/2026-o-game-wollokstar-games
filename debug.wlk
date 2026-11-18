import wollok.game.*
import directorJuego.*
import controles.*
import instancias.*

object debug {
    const activo = false

    method configurar(){
        if(activo){
            keyboard.r().onPressDo({
                self.reiniciarJuego()
            })
        }
    }

    method reiniciarJuego(){

        game.clear()

        nivel.reiniciarEstado()
        nivel.iniciarPartida()

        configuracion.configurarTeclado()   
    }
}