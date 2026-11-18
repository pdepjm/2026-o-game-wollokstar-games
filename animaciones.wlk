import wollok.game.*
import directorJuego.*
import controles.*
import debug.*
import cuadroDeTexto.*
import musica.*
import estados.*
import objetos.*

object cinematicas {
    const escenas = [pantallaDeCarga, intro, pantallaCreditos, pantallaTitulo, pantallaControles, historieta, pantallaObjetivo, transicionAlJuego]    var indice = 0

    method comenzar(){
        indice = 0
        keyboard.z().onPressDo({ if(self.enCurso()) self.escenaActual().apretarZ() })
        self.escenaActual().empezar()
    }

    method enCurso() = indice < escenas.size()

    method escenaActual() = escenas.get(indice)

    method siguiente(){
        self.escenaActual().terminar()
        indice = indice + 1
        if(self.enCurso()){
            self.escenaActual().empezar()
        }else{
            self.empezarJuego()
        }
    }

    method empezarJuego(){
        configuracion.configurarTeclado()
    }
}

class Escena {
    const visuales = []

    method visualesIniciales()

    method empezar(){
        self.visualesIniciales().forEach({ unVisual => self.mostrar(unVisual) })
    }

    method mostrar(unVisual){
        visuales.add(unVisual)
        game.addVisual(unVisual)
    }

    method terminar(){
        self.sacarTodo()
    }

    method sacarTodo(){
        visuales.forEach({ unVisual => game.removeVisual(unVisual) })
        visuales.clear()
    }

    method apretarZ(){
        cinematicas.siguiente()
    }
}

class EscenaConDuracion inherits Escena {
    const cantidadDeFrames
    const duracionDeFrame
    const nombreDelTick
    var framesMostrados = 0

    override method empezar(){
        super()
        framesMostrados = 0
        game.onTick(duracionDeFrame, nombreDelTick, { self.pasoUnFrame() })
    }

    method pasoUnFrame(){
        framesMostrados = framesMostrados + 1
        if(framesMostrados == cantidadDeFrames){
            cinematicas.siguiente()
        }
    }

    override method terminar(){
        game.removeTickEvent(nombreDelTick)
        super()
    }
}

object pantallaDeCarga inherits EscenaConDuracion(
    cantidadDeFrames = 32,
    duracionDeFrame = 100,
    nombreDelTick = "esperaDeCarga"
) {
    override method visualesIniciales() = [new Imagen(image = "fondoNegro.png")]
}

class EscenaGifUnaVez inherits EscenaConDuracion {
    const fondo
    const gif
    const posicionDelGif

    override method visualesIniciales() = [new Imagen(image = fondo), new Imagen(image = gif, position = posicionDelGif)]
}

object intro inherits EscenaGifUnaVez(
    fondo = "fondoNegro.png",
    gif = "intro.gif",
    posicionDelGif = game.at(5,3),
    cantidadDeFrames = 45,
    duracionDeFrame = 100,
    nombreDelTick = "framesDeLaIntro"
) {}

object pantallaCreditos inherits Escena {
    override method visualesIniciales() = [new Imagen(image = "creditos.png")]
}

object pantallaTitulo inherits Escena {
    override method visualesIniciales() = [
        new Imagen(image = "fondoTitulo.png"),
        new Imagen(image = "tituloJuego.gif", position = game.at(4,9)),
        new Imagen(image = "pulsaZParaJugar.gif", position = game.at(6,1))
    ]

    override method empezar(){
        super()
        flashes.empezar()
        musicaDelMenu.reproducir()
    }

    override method terminar(){
        flashes.terminar()
        super()
    }
}

object flashes {
    const camaras = [camaraIzquierda, camaraDerecha]
    var disparos = 0
    const cadaTanto = new CadaTanto(esperas = [2500, 4200, 3300, 5000], accion = { self.disparar() })

    method empezar(){ cadaTanto.empezar() }
    method terminar(){ cadaTanto.terminar() }

    method disparar(){
        camaras.get(disparos % camaras.size()).sacarFoto()
        disparos = disparos + 1
    }
}

class Camara {
    const destelloFuerte
    const destelloSuave
    const posicionDelDestello

    method sacarFoto(){
        sonidos.reproducir("foto.mp3")
        const fuerte = [new Imagen(image = "flashFuerte.png"), new Imagen(image = destelloFuerte, position = posicionDelDestello)]
        self.mostrarUnRato(fuerte, 70, {
            const suave = [new Imagen(image = "flashSuave.png"), new Imagen(image = destelloSuave, position = posicionDelDestello)]
            self.mostrarUnRato(suave, 120, {})
        })
    }

    method mostrarUnRato(unosVisuales, milisegundos, despues){
        unosVisuales.forEach({ unVisual => game.addVisual(unVisual) })
        game.schedule(milisegundos, {
            unosVisuales.forEach({ unVisual => if(game.hasVisual(unVisual)) game.removeVisual(unVisual) })
            despues.apply()
        })
    }
}

const camaraIzquierda = new Camara(
    destelloFuerte = "destelloIzquierdaFuerte.png",
    destelloSuave = "destelloIzquierdaSuave.png",
    posicionDelDestello = game.at(0,2)
)

const camaraDerecha = new Camara(
    destelloFuerte = "destelloDerechaFuerte.png",
    destelloSuave = "destelloDerechaSuave.png",
    posicionDelDestello = game.at(14,1)
)

object pantallaControles inherits Escena {
    override method visualesIniciales() = [
        new Imagen(image = "fondoControles.png"),
        new Imagen(image = "teclas.gif", position = game.at(1,5)),
        new Imagen(image = "pulsaZParaContinuar.gif", position = game.at(9,0))
    ]

    override method empezar(){
        super()
        sonidos.cambioDePantalla()
    }    
}

object historieta inherits Escena {
    const vinetas = [
        new Imagen(image = "vineta1.png", position = game.at(0,6)),
        new Imagen(image = "vineta2.png", position = game.at(6,7)),
        new Imagen(image = "vineta3.png", position = game.at(15,7)),
        new Imagen(image = "vineta4.png", position = game.at(0,1)),
        new Imagen(image = "vineta5.png", position = game.at(6,1)),
        new Imagen(image = "vineta6.png", position = game.at(10,1))
    ]
    var mostradas = 0

    override method visualesIniciales() = [
        new Imagen(image = "historietaFondo.png"),
        new Imagen(image = "pulsaZParaContinuar.gif", position = game.at(5,0))
    ]

    override method empezar(){
        super()
        sonidos.cambioDePantalla()
        mostradas = 0
        self.mostrarSiguienteVineta()
    }

    override method apretarZ(){
        if(self.quedanVinetas()){
            self.mostrarSiguienteVineta()
        }else{
            cinematicas.siguiente()
        }
    }

    method quedanVinetas() = mostradas < vinetas.size()

    method mostrarSiguienteVineta(){
        self.mostrar(vinetas.get(mostradas))
        sonidos.reproducir("pagina.mp3")
        mostradas = mostradas + 1
    }
}

object pantallaObjetivo inherits Escena {
    override method visualesIniciales() = [
        new Imagen(image = "fondoObjetivo.png"),
        new Imagen(image = "pulsaZParaContinuar.gif", position = game.at(9,0))
    ]

    override method empezar(){
        super()
        sonidos.cambioDePantalla()
    }
}

object transicionAlJuego inherits EscenaConDuracion(
    cantidadDeFrames = 18,
    duracionDeFrame = 100,
    nombreDelTick = "framesDeLaTransicion"
) {
    const frameDeAgrandar = 12

    override method visualesIniciales() = [
        new Imagen(image = "transicionMarco.png"),
        new Imagen(image = "transicionCirculo.gif", position = game.at(6,8))
    ]

    override method empezar(){
        musicaDelMenu.detener()
        nivel.iniciarPartida()
        super()
    }

    override method pasoUnFrame(){
        super()
        if(framesMostrados == frameDeAgrandar){
            self.agrandarCirculo()
        }
    }

    method agrandarCirculo(){
        self.sacarTodo()
        self.mostrar(new Imagen(image = "transicionAgrandar.gif"))
        sonidos.reproducir("transicion.mp3")
    }
}

class CadaTanto {
    const esperas
    const accion
    var vueltas = 0
    var activo = false

    method empezar(){
        activo = true
        vueltas = 0
        self.programarSiguiente()
    }

    method terminar(){
        activo = false
    }

    method programarSiguiente(){
        game.schedule(esperas.get(vueltas % esperas.size()), { self.ejecutar() })
    }

    method ejecutar(){
        if(activo){
            accion.apply()
            vueltas = vueltas + 1
            self.programarSiguiente()
        }
    }
}


object screamer {
    const duracionMs = 2000
    const imagen = new Imagen(image = "screamer.png")   
    var ruido = sinMusica

    method asustar(){
        const estadoAnterior = estadoDelJuego.actual()
        estadoDelJuego.cambiarA(asustado)
        game.addVisual(imagen)
        ruido = game.sound("screamer.mp3")
        ruido.play()
        game.schedule(duracionMs, { self.terminar(estadoAnterior) })
    }

    method terminar(unEstado){
        game.removeVisual(imagen)
        ruido.stop()
        ruido = sinMusica
        estadoDelJuego.cambiarA(unEstado)
    }
}

object asustado inherits Estado {}

class MuebleConScreamer inherits Mueble {
    var estado = conSusto

    override method usar(unDetective){
        estado.revisar(self)
    }

    method asustar(){
        estado = yaAsusto
        screamer.asustar()
    }

    override method reiniciar(){
        estado = conSusto
    }
}

object conSusto {
    method revisar(unMueble){ unMueble.asustar() }
}

object yaAsusto {
    method revisar(unMueble){ unMueble.decir(unMueble.descripcion()) }
}