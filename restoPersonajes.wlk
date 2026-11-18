import wollok.game.*
import cuadroDeTexto.*
import dialogos.*
import menu.*
import objetos.*
import instancias.*

class Persona {
    var property position
    const imagen
    const texto

    method image() = imagen

    method texto(){
    return texto
    }

    method interactuar(unDetective){
        const cuadro = new CuadroDeTexto(texto = texto)
        cuadros.abrir(cuadro,self)
    }

    method finalizarInteraccion(){
    }

    method reiniciar(){
    }

    method ocupa(unaPosicion) = position == unaPosicion

    method moverseA(unaPosicion){
        position = unaPosicion
    }
}

class Sospechoso inherits Persona {
    const preguntas
    var preguntasPendientes = []
    var preguntaActual = sinPregunta
    const posicionInicial = position
    const humorInicial = 0
    var humor = 0
    const nombreBaseImagen
    const nombre
    const property esCulpable = false
    const pistasNecesarias = []
    const descripcion = "Todavía no hay pruebas en su contra."

    method initialize(){
        self.reiniciar()
    }

    override method image() = self.estadoDeAnimo().imagen(nombreBaseImagen)

    method nombre() = nombre
    method puedeIrPreso() = esCulpable && menu.tieneTodas(pistasNecesarias)
    method imagenParaMenu() = self.image()
    method tituloParaMenu() = nombre.toUpperCase()
    method descripcionParaMenu() = textos.envolver(descripcion, 40)
    method cambiarHumor(cantidad){
        humor = humor + cantidad
    }
    method estadoDeAnimo() = estadosDeAnimo.segun(humor)
    method tienePreguntaDisponible() = preguntasPendientes.any({ unaPregunta => unaPregunta.esPreguntable() })
    method proximaPregunta() = preguntasPendientes.find({ unaPregunta => unaPregunta.esPreguntable() })
    override method interactuar(unDetective){
        menu.guardarSospechoso(self)
        if(self.tienePreguntaDisponible()){
            self.preguntar(self.proximaPregunta())
        }else{
            super(unDetective)
        }
    }

    method preguntar(unaPregunta){
        preguntaActual = unaPregunta
        preguntasPendientes.remove(unaPregunta)
        const cuadro = new CuadroDeDialogo(
            texto = unaPregunta.texto(),
            selector = new SelectorDialogo(opciones = unaPregunta.opciones())
        )
        dialogos.abrir(cuadro, self)
    }

    method recibirRespuesta(unaOpcion){
        unaOpcion.afectarSospechoso(self)
        const respuesta = unaOpcion.respuestaSegunEstado(self.estadoDeAnimo())
        cuadros.abrir(new CuadroDeTexto(texto = respuesta), self)
        preguntaActual.responder(self)
    }

    override method reiniciar(){
        humor = humorInicial
        preguntasPendientes = preguntas.copy()
        self.moverseA(posicionInicial)
    }
}

class Informante inherits Persona {
    const pista
    const textoDespues = "Espero que te sirva la información que te di."
    var estado = sinHablar

    override method interactuar(unDetective){
        estado.hablar(self)
    }

    override method finalizarInteraccion(){
        estado.terminoDeHablar(self)
    }

    method contarPista(){
        estado = contandoPista
        self.decir(self.texto())
    }

    method entregarPista(){
        pista.marcarEncontrada()
        estado = yaInformo
        self.decir("Se guardó " + pista.tituloParaMenu() + " como pista en el menú.")
    }

    method recordar(){
        self.decir(textoDespues)
    }

    method decir(unTexto){
        cuadros.abrir(new CuadroDeTexto(texto = unTexto), self)
    }

    override method reiniciar(){
        estado = sinHablar
    }
}

class InformanteConPedido inherits Informante {
    const pedido = []
    const textoPedido

    override method interactuar(unDetective){
        if(menu.tieneTodas(pedido)){
            super(unDetective)
        }else{
            self.decir(textoPedido)
        }
    }
}

object sinHablar {
    method hablar(unInformante){ unInformante.contarPista() }
    method terminoDeHablar(unInformante){}
}

object contandoPista {
    method hablar(unInformante){}
    method terminoDeHablar(unInformante){ unInformante.entregarPista() }
}

object yaInformo {
    method hablar(unInformante){ unInformante.recordar() }
    method terminoDeHablar(unInformante){}
}