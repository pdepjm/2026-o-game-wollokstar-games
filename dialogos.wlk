import wollok.game.*
import cuadroDeTexto.*
import menu.*
import instancias.*
import estados.*

class OpcionDialogo {
    const texto
    const tono
    const respuestaNormal
    const respuestaEnojada

    method texto() = texto
    method respuestaSegunEstado(unEstado) = unEstado.reaccionar(self)
    method respuestaNormal() = respuestaNormal
    method respuestaEnojada() = respuestaEnojada

    method afectarSospechoso(unSospechoso) {
        tono.afectar(unSospechoso)
    }
}

class Pregunta {
    const texto 
    const opciones
    const requisitos = []
    const alResponder = { unSospechoso => }
    method texto() = texto
    method opciones() = opciones
    method esPreguntable() = menu.tieneTodas(requisitos)
    method responder(unSospechoso){ alResponder.apply(unSospechoso) }
}

object sinPregunta {
    method responder(unSospechoso){}
}

object provocador {
    method afectar(unSospechoso) {
        unSospechoso.cambiarHumor(-2)
    }
}

object gentil {
    method afectar(unSospechoso) {
        unSospechoso.cambiarHumor(1)
    }
}

object neutral {
    method afectar(unSospechoso) {
    }
}

object relajado {
    method imagen(base) = base + "Normal.png"
    method reaccionar(unaOpcion) = unaOpcion.respuestaNormal()
    method corresponde(unHumor) = unHumor >= 0
}

object acorralado {
    method imagen(base) = base + "Nervioso.png"
    method reaccionar(unaOpcion) = unaOpcion.respuestaEnojada()
    method corresponde(unHumor) = unHumor < 0
}

object estadosDeAnimo {
    const estados = [relajado, acorralado]

    method segun(unHumor) = estados.find({ unEstado => unEstado.corresponde(unHumor) })
}

class TextoOpcionDialogo {
    const selector
    const indice
    var property position
    const tamanioDeLetra

    method text(){
        return selector.opciones().get(indice).texto()
    }

    method textColor(){
        if(selector.indiceSeleccionado() == indice){
            return "FFFF00FF"
        }else{
            return "FFFFFFFF"
        }
    }

    method textSize() = tamanioDeLetra

}

class SelectorDialogo {
    const opciones
    var indiceSeleccionado = 0

    method opciones(){
        return opciones
    }

    method indiceSeleccionado(){
        return indiceSeleccionado
    }

    method siguiente(){
        if(indiceSeleccionado == opciones.size() - 1){
            indiceSeleccionado = 0
        }else{
            indiceSeleccionado = indiceSeleccionado + 1
        }
    }

    method anterior(){
        if(indiceSeleccionado == 0){
            indiceSeleccionado = opciones.size() - 1
        }else{
            indiceSeleccionado = indiceSeleccionado - 1
        }
    }

    method opcionSeleccionada(){
        return opciones.get(indiceSeleccionado)
    }
}

class CuadroDeDialogo {
    const texto
    const selector
    const etiqueta = "Elegir dialogo:"
    const tamanioDeLetra = estiloDeTexto.tamanioInteracciones()

    var visualesAbiertos = []

    method position() = game.at(0,0)
    method image() = "fondoNegroCuadroDeTexto.png"

        method visuales(){
        const medio = estiloDeTexto.columnaDelMedio()
        const cantidadDeOpciones = selector.opciones().size()
        const visualesOpciones = (0 .. cantidadDeOpciones - 1).map({ unIndice =>
            new TextoOpcionDialogo(
                selector = selector,
                indice = unIndice,
                position = game.at(medio, 2 - unIndice),
                tamanioDeLetra = tamanioDeLetra
            )
        })
        return [
            self,
            new TextoDelCuadro(texto = texto, position = game.at(medio, 4), tamanioDeLetra = tamanioDeLetra),
            new TextoDelCuadro(texto = etiqueta, position = game.at(medio, 3), tamanioDeLetra = tamanioDeLetra)
        ] + visualesOpciones
    }

    method abrir(){
        visualesAbiertos = self.visuales()
        visualesAbiertos.forEach({
            unVisual => game.addVisual(unVisual)
        })
    }

    method cerrar(){
        visualesAbiertos.forEach({
            unVisual => game.removeVisual(unVisual)
        })
        visualesAbiertos = []
    }

    method siguiente(){
        selector.siguiente()
    }

    method anterior(){
        selector.anterior()
    }

    method opcionSeleccionada(){
        return selector.opcionSeleccionada()
    }
}

object dialogos {
    var cuadroActual = sinCuadro
    var personajeActual = sinPersonaje

    method abrir(unCuadro,unPersonaje){
        cuadroActual = unCuadro
        personajeActual = unPersonaje

        cuadroActual.abrir()
        estadoDelJuego.cambiarA(enDialogo)
    }

    method siguiente(){
        cuadroActual.siguiente()
    }

    method anterior(){
        cuadroActual.anterior()
    }

    method confirmar(){
    const opcionElegida = cuadroActual.opcionSeleccionada()
    const personaje = personajeActual
    self.cerrar()
    personaje.recibirRespuesta(opcionElegida)
    }

    method cerrar(){
        cuadroActual.cerrar()
        self.reiniciar()
        estadoDelJuego.cambiarA(explorando)
    }

    method reiniciar(){
        cuadroActual = sinCuadro
        personajeActual = sinPersonaje
    }
}

object sinPersonaje {
    method recibirRespuesta(unaOpcion){}
}