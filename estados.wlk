import wollok.game.*
import detectives.*
import interacciones.*
import cuadroDeTexto.*
import dialogos.*
import menu.*

object estadoDelJuego {
    var actual = explorando

    method actual() = actual

    method cambiarA(unEstado){
        actual = unEstado
    }

    method reiniciar(){
        actual = explorando
    }
}

class Estado {
    method flecha(unaDireccion){}
    method caminar(unaDireccion){}
    method confirmar(){}
    method cancelar(){}
    method alternarMenu(){}
}

object explorando inherits Estado {
    override method flecha(unaDireccion){ patricioJuan.mover(unaDireccion) }
    override method caminar(unaDireccion){ patricioJuan.mover(unaDireccion) }
    override method confirmar(){ interacciones.interactuarConCercano() }
    override method alternarMenu(){ menu.abrir() }
}

object enCuadro inherits Estado {
    override method confirmar(){ cuadros.cerrar() }
}

object enDialogo inherits Estado {
    override method flecha(unaDireccion){ unaDireccion.enDialogo(dialogos) }
    override method confirmar(){ dialogos.confirmar() }
}

object enMenu inherits Estado {
    override method flecha(unaDireccion){ menu.flecha(unaDireccion) }
    override method confirmar(){ menu.confirmar() }
    override method cancelar(){ menu.volver() }
    override method alternarMenu(){ menu.cerrar() }
}