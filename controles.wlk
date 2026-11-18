import wollok.game.*
import detectives.*
import interacciones.*
import dialogos.*
import menu.*
import instancias.*
import estados.*

object controles {
    const esperaInicial = 250
    const intervalo = 200
    const flechasApretadas = []
    var pulsaciones = 0


    method configurar(){
        flechasApretadas.clear()
        self.configurarFlecha(keyboard.right(), derecha)
        self.configurarFlecha(keyboard.left(), izquierda)
        self.configurarFlecha(keyboard.up(), arriba)
        self.configurarFlecha(keyboard.down(), abajo)
        keyboard.z().onPressDo({ self.confirmar() })
        keyboard.x().onPressDo({ self.cancelar() })
        keyboard.c().onPressDo({ self.alternarMenu() })
    }

        method configurarFlecha(unaTecla, unaDireccion){
        unaTecla.onPressDo({ self.apretarFlecha(unaDireccion) })
        unaTecla.onReleaseDo({ self.soltarFlecha(unaDireccion) })
    }

    method apretarFlecha(unaDireccion){
        self.flecha(unaDireccion)
        flechasApretadas.remove(unaDireccion)
        flechasApretadas.add(unaDireccion)
        self.repetirDespuesDe(esperaInicial)
    }

    method soltarFlecha(unaDireccion){
        const eraLaQueMandaba = self.hayFlechaApretada() && flechasApretadas.last() == unaDireccion
        flechasApretadas.remove(unaDireccion)
        if(eraLaQueMandaba){
            self.dejarDeRepetir()
            if(self.hayFlechaApretada()){
                self.repetirDespuesDe(intervalo)
            }
        }
    }

    method hayFlechaApretada() = !flechasApretadas.isEmpty()

    method repetirDespuesDe(milisegundos){
        self.dejarDeRepetir()
        const estaVez = pulsaciones
        game.schedule(milisegundos, {
            if(estaVez == pulsaciones && self.hayFlechaApretada()){
                self.empezarARepetir()
            }
        })
    }

    method empezarARepetir(){
        self.darUnPaso()
        game.onTick(intervalo, "caminarConLaFlechaApretada", { self.darUnPaso() })
    }

    method dejarDeRepetir(){
        pulsaciones = pulsaciones + 1
        game.removeTickEvent("caminarConLaFlechaApretada")
    }

    method darUnPaso(){
        estadoDelJuego.actual().caminar(flechasApretadas.last())
    }

    method flecha(unaDireccion){ estadoDelJuego.actual().flecha(unaDireccion) }
    method confirmar(){ estadoDelJuego.actual().confirmar() }
    method cancelar(){ estadoDelJuego.actual().cancelar() }
    method alternarMenu(){ estadoDelJuego.actual().alternarMenu() }
}