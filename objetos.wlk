import wollok.game.*
import cuadroDeTexto.*
import menu.*
import instancias.*
import musica.*


class Pista {
    var property position = game.origin()
    const nombre
    const texto
    const imagen = nombre + ".png"
    var disponible = true

    method image() = imagen

    method esSolido() = false

    method ocupa(unaPosicion) = disponible && position == unaPosicion

    method interactuar(unDetective){
        self.marcarEncontrada()
        const cuadro = new CuadroDeTexto(texto = texto)
        cuadros.abrir(cuadro,self)
    }

    method marcarEncontrada(){
        disponible = false
        menu.guardarPista(self)
    }

    method imagenParaMenu() = self.image()
    method tituloParaMenu() = nombre.toUpperCase()
    method descripcionParaMenu() = textos.envolver(texto, 40)

    method finalizarInteraccion(){
        game.removeVisual(self)
    }

    method mostrar(){
        if(disponible){
            game.addVisual(self)
        }
    }

    method ocultar(){
        if(disponible){
            game.removeVisual(self)
        }
    }

    method reiniciar(){
        disponible = true
    }
}

class Mueble {
    var property position
    const imagen
    const descripcion
    const ancho = 1
    const alto = 1
    const requisitos = []                 
    const textoCerrado = "Está cerrado."

    method image() = imagen
    method descripcion() = descripcion

    method esSolido() = true

    method ocupa(unaPosicion) = unaPosicion.x().between(position.x(), position.x() + ancho - 1) && unaPosicion.y().between(position.y(), position.y() + alto - 1)

    method interactuar(unDetective){
        if(menu.tieneTodas(requisitos)){
            self.usar(unDetective)
        }else{
            self.decir(textoCerrado)
        }
    }

   method usar(unDetective){
        self.decir(descripcion)
    }

    method decir(unTexto){
        const cuadro = new CuadroDeTexto(texto = unTexto)
        cuadros.abrir(cuadro,self)
    }

    method finalizarInteraccion(){
    }

    method mostrar(){
        game.addVisual(self)
    }

    method ocultar(){
        game.removeVisual(self)
    }

    method reiniciar(){
    }
}

class MuebleConPista inherits Mueble {
    const pista
    const textoHallazgo
    var estado = conPista

    override method usar(unDetective){
        estado.revisar(self)
    }

    method entregarPista(){
        pista.marcarEncontrada()
        estado = vacio
        self.decir(textoHallazgo)
    }

    override method reiniciar(){
        estado = conPista
        pista.reiniciar()
    }
}

class MuebleConSonido inherits Mueble {
    const audios = []

    override method usar(unDetective){
        sonidos.reproducir(audios.anyOne())
    }
}

class Escenario inherits Mueble {
    const entrada
    const escalera = new Imagen(image = "escalera.png", position = entrada.left(1))

    override method ocupa(unaPosicion) = super(unaPosicion) && self.esBorde(unaPosicion) && unaPosicion != entrada

    method esBorde(unaPosicion) =
        unaPosicion.y() == position.y()
        || unaPosicion.x() == position.x()                  
        || unaPosicion.x() == position.x() + ancho - 1        

    override method mostrar(){
        super()
        game.addVisual(escalera)
    }

    override method ocultar(){
        super()
        game.removeVisual(escalera)
    }
}

object conPista {
    method revisar(unMueble){
        unMueble.entregarPista()
    }

    method estaVacio() = false
}

object vacio {
    method revisar(unMueble){
        unMueble.decir(unMueble.descripcion())
    }

    method estaVacio() = true
}

