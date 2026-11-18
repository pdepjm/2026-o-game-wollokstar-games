import wollok.game.*

class Musica {
    const archivo
    const duracionMs
    const nombreDelTick
    var reproduciendo = false
    var cancion = sinMusica
    var volumen = 1

    method reproducir(){
        if(!reproduciendo){
            reproduciendo = true
            self.tocar()
            game.onTick(duracionMs, nombreDelTick, { self.tocar() })
        }
    }

    method tocar(){
        cancion = game.sound(archivo)
        cancion.volume(volumen)
        cancion.play()
    }

    method volumen(unVolumen){
        volumen = unVolumen
        cancion.volume(volumen)
    }

    method detener(){
        reproduciendo = false
        game.removeTickEvent(nombreDelTick)
        cancion.stop()
        cancion = sinMusica
    }
}

object musicaDeFondo inherits Musica(archivo = "musicaDeJuego.mp3", duracionMs = 220000, nombreDelTick = "loopMusicaFondo") {}

object musicaDelMenu inherits Musica(archivo = "musicaSimuladores.mp3", duracionMs = 331900, nombreDelTick = "loopMusicaMenu", volumen = 0.3) {}
object sinMusica {
    method stop(){}
    method volume(unVolumen){}
}

object silencio {
    method reproducir(){}
}

object sonidos {
    method reproducir(unArchivo){
        game.sound(unArchivo).play()
    }

    method cambioDePantalla(){ self.reproducir("sonidoTransicion.mp3") }
}