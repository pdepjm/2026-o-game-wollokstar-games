import wollok.game.*
import detectives.*
import habitaciones.*
import instancias.*

object interacciones {

    method interactuarConCercano() {
        const detectiveActual = patricioJuan
        self.candidatos(detectiveActual)
            .take(1)
            .forEach({ elemento => elemento.interactuar(detectiveActual) })
    }

    method candidatos(unDetective) {
        return self.posicionesAInterrogar(unDetective)
                   .flatMap({ pos => mapa.habitacionActual().elementosEn(pos) })
    }

    method posicionesAInterrogar(unDetective) {
        const pos = unDetective.position()
        return [pos, unDetective.direccion().siguiente(pos)]
    }
}
