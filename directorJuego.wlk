import wollok.game.*
import detectives.*
import objetos.*
import restoPersonajes.*
import cuadroDeTexto.*
import dialogos.*
import colisiones.*
import menu.*
import controles.*
import habitaciones.*
import instancias.*
import estados.*
import debug.*
import musica.*

object configuracion {
    method configurarCanvas(){
        game.title("El Ultimo Mate del Chiqui Tapia")
        game.cellSize(100)
        game.width(23)
        game.height(12)
    }

    method configurarTeclado(){
        controles.configurar()
        debug.configurar()
    }
}

object nivel {

    method iniciarPartida() {
        mapa.iniciar()
        game.addVisual(patricioJuan)
    }

    method reiniciarEstado(){
        musicaDeFondo.detener()
        patricioJuan.reiniciar()
        mapa.reiniciar()
        menu.reiniciar()
        cuadros.reiniciar()
        dialogos.reiniciar()
        estadoDelJuego.reiniciar()
    }
}
