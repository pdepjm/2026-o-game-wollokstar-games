import wollok.game.*
import colisiones.*
import detectives.*
import restoPersonajes.*
import objetos.*
import cuadroDeTexto.*
import menu.*
import instancias.*
import musica.*

object fondo {
    var property image = "fondoOficina.png"

    method position() = game.origin()
}

class Habitacion {
    const imagenDeFondo
    const personajes = []
    const objetos = []
    const paredes = []
    const sonidoAlEntrar = silencio

    method entrar(){
        fondo.image(imagenDeFondo)

        personajes.forEach({
            unPersonaje => game.addVisual(unPersonaje)
        })

        objetos.forEach({
            unObjeto => unObjeto.mostrar()
        })

        colisiones.cargar(self.solidos())

        sonidoAlEntrar.reproducir()
    }

    method salir(){
        personajes.forEach({
            unPersonaje => game.removeVisual(unPersonaje)
        })

        objetos.forEach({
            unObjeto => unObjeto.ocultar()
        })

        colisiones.limpiar()
    }

    method solidos(){
        return paredes + personajes + objetos.filter({
            unObjeto => unObjeto.esSolido()
        })
    }

    method elementosEn(unaPosicion) = (personajes + objetos).filter({ unElemento => unElemento.ocupa(unaPosicion) })

    method reiniciar(){
        personajes.forEach({ unPersonaje => unPersonaje.reiniciar() })
        objetos.forEach({ unObjeto => unObjeto.reiniciar() })
    }
}

class Puerta {
    var property position
    const destino
    const llegada
    const pared = paredDeFrente
    const requisitos = []
    const textoCerrado = "La puerta está cerrada."

    method image() = pared.imagenDePuerta()

    method esSolido() = true

    method interactuar(unDetective){
        if(menu.tieneTodas(requisitos)){
            mapa.irA(destino, llegada)
        }else{
            cuadros.abrir(new CuadroDeTexto(texto = textoCerrado), self)
        }
    }

    method finalizarInteraccion(){
    }

    method ocupa(unaPosicion) = position == unaPosicion

    method mostrar(){
        game.addVisual(self)
    }

    method ocultar(){
        game.removeVisual(self)
    }

    method reiniciar(){
    }
}

object paredDeFrente {
    method imagenDePuerta() = "puerta.png"
}

object paredIzquierda {
    method imagenDePuerta() = "puertaIzquierda.png"
}

object paredDerecha {
    method imagenDePuerta() = "puertaDerecha.png"
}


object mapa {
    const habitaciones = [estacionamiento, salaDePrensa, oficinaTapia, pasillo, recepcion, banios, oficinaTesorero, areaDescanso, vestuarios, cocina]    const habitacionInicial = estacionamiento
    var habitacionActual = habitacionInicial

    method habitacionActual() = habitacionActual

    method iniciar(){
        game.addVisual(fondo)
        habitacionActual.entrar()
    }

    method irA(unaHabitacion, unaPosicion){
        habitacionActual.salir()
        habitacionActual = unaHabitacion
        habitacionActual.entrar()

        patricioJuan.ubicarEn(unaPosicion)
        self.traerAlFrente(patricioJuan)
    }

    method traerAlFrente(unVisual){
        game.removeVisual(unVisual)
        game.addVisual(unVisual)
    }

    method reiniciar(){
        habitaciones.forEach({
            unaHabitacion => unaHabitacion.reiniciar()
        })
        habitacionActual = habitacionInicial
        colisiones.limpiar()
    }
}
