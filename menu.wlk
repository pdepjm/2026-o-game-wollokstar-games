import wollok.game.*
import cuadroDeTexto.*
import dialogos.*
import directorJuego.*
import instancias.*
import estados.*
import musica.*

object menu {
    const pistasEncontradas = []
    const sospechososConocidos = []
    var pantallaActual = sinPantalla

    method guardarPista(unaPista){
        pistasEncontradas.add(unaPista)
    }

    method pistas() = pistasEncontradas

    method tieneTodas(unasPistas) = unasPistas.all({ unaPista => pistasEncontradas.contains(unaPista) })

    method guardarSospechoso(unSospechoso){
        if(!sospechososConocidos.contains(unSospechoso)){
            sospechososConocidos.add(unSospechoso)
        }
    }

    method sospechosos() = sospechososConocidos

    method abrir(){
        self.irA(menuPrincipal)
    }

    method cerrar(){
        if(pantallaActual.sePuedeCerrar()){
            pantallaActual.ocultar()
            pantallaActual = sinPantalla
            estadoDelJuego.cambiarA(explorando)
        }
    }

    method irA(unaPantalla){
        pantallaActual.ocultar()
        pantallaActual = unaPantalla
        pantallaActual.mostrar()
        estadoDelJuego.cambiarA(enMenu)
    }

    method flecha(unaDireccion){ unaDireccion.enPantalla(pantallaActual) }

    method confirmar(){ pantallaActual.confirmar() }
    method volver(){ pantallaActual.volver() }

    method reiniciar(){
        pistasEncontradas.clear()
        sospechososConocidos.clear()
        pantallaActual = sinPantalla
        carpetaPistas.reiniciar()
        carpetaSospechosos.reiniciar()
    }
}

object sinPantalla {
    method mostrar(){}
    method ocultar(){}
    method sePuedeCerrar() = true
}

class Pantalla {
    var visualesEnPantalla = []

    method armarVisuales()

    method mostrar(){
        visualesEnPantalla = self.armarVisuales()
        visualesEnPantalla.forEach({ unVisual => game.addVisual(unVisual) })
    }

    method ocultar(){
        visualesEnPantalla.forEach({ unVisual => game.removeVisual(unVisual) })
        visualesEnPantalla = []
    }

    method actualizar(){
        self.ocultar()
        self.mostrar()
    }

    method confirmar(){}
    method volver(){}
    method arriba(){}
    method abajo(){}
    method izquierda(){}
    method derecha(){}

    method sePuedeCerrar() = true

    method tamanioDeLetra() = estiloDeTexto.tamanioMenu()

    method textoSobrePapel(unTexto, unaPosicion) =
        new TextoDelCuadro(texto = unTexto, position = unaPosicion, color = "222222FF", tamanioDeLetra = self.tamanioDeLetra())
}

class PantallaConOpciones inherits Pantalla {
    method cuadro()

    override method armarVisuales() = self.cuadro().visuales()
    override method arriba(){ self.cuadro().anterior() }
    override method abajo(){ self.cuadro().siguiente() }
    override method confirmar(){ self.cuadro().opcionSeleccionada().elegir() }
}

class Opcion {
    const property texto
    const accion

    method elegir(){ accion.apply() }
}

object menuPrincipal inherits PantallaConOpciones{
    const cuadro = new CuadroDeDialogo(
        texto = "MENÚ",
        etiqueta = "Z: elegir     X / C: cerrar",
        selector = new SelectorDialogo(opciones = [carpetaPistas, carpetaSospechosos]),
        tamanioDeLetra = self.tamanioDeLetra()
    )

    override method cuadro() = cuadro
    override method volver(){ menu.cerrar() }
}

object confirmacion inherits PantallaConOpciones {
    var cuadro = self.preguntaParaIncriminar()

    override method cuadro() = cuadro

    override method mostrar(){
        cuadro = self.preguntaParaIncriminar()
        super()
    }

    override method tamanioDeLetra() = estiloDeTexto.tamanioSospechosos()

    method preguntaParaIncriminar() = new CuadroDeDialogo(
        texto = "¿Querés incriminar a este sospechoso?",
        etiqueta = "Z: confirmar     X: cancelar",
        selector = new SelectorDialogo(
            opciones = [
                new Opcion(texto = "Sí", accion = { veredicto.incriminar(carpetaSospechosos.fichaActual()) }),
                new Opcion(texto = "No", accion = { self.volver() })
            ],
            indiceSeleccionado = 1
        ),
        tamanioDeLetra = self.tamanioDeLetra()
    )

    override method armarVisuales() = carpetaSospechosos.armarVisuales() + super()

    override method volver(){ menu.irA(carpetaSospechosos) }
}

class Carpeta inherits Pantalla {
    const property texto
    const imagenCarpeta
    const nombreFicha
    const textoSinFichas
    var indice = 0

    method fichas()

    method elegir(){
        menu.irA(self)
        sonidos.cambioDePantalla()
    }

    method hayFichas() = !self.fichas().isEmpty()

    method fichaActual() = self.fichas().get(indice)

    override method armarVisuales(){
        const carpeta = new Imagen(image = imagenCarpeta, position = game.at(3,1))
        if(!self.hayFichas()){
            return [carpeta, self.textoSobrePapel(textoSinFichas, game.at(14,6))]
        }
        const ficha = self.fichaActual()
        const numeroDeFicha = nombreFicha + " " + (indice + 1).toString() + " de " + self.fichas().size().toString()
        return [
            carpeta,
            new Imagen(image = ficha.imagenParaMenu(), position = game.at(6,5)),
            self.textoSobrePapel(numeroDeFicha, game.at(6,3)),
            self.textoSobrePapel(ficha.tituloParaMenu(), game.at(14,8)),
            self.textoSobrePapel(ficha.descripcionParaMenu(), game.at(14,6))
        ]
    }

    override method izquierda(){ self.pasarFicha(-1) }
    override method derecha(){ self.pasarFicha(1) }

    method hayVariasFichas() = self.fichas().size() > 1

    method pasarFicha(cuanto){
        if(self.hayVariasFichas()){
            const cantidad = self.fichas().size()
            indice = (indice + cuanto + cantidad) % cantidad
            self.actualizar()
            sonidos.cambioDePantalla()
        }
    }
    override method volver(){ menu.irA(menuPrincipal) }

    method reiniciar(){ indice = 0 }
}

object carpetaPistas inherits Carpeta(
    texto = "Pistas",
    imagenCarpeta = "carpetaPistas.png",
    nombreFicha = "Pista",
    textoSinFichas = "Todavía no encontraste pistas."
) {
    override method fichas() = menu.pistas()

    override method tamanioDeLetra() = estiloDeTexto.tamanioPistas()
}

object carpetaSospechosos inherits Carpeta(
    texto = "Sospechosos",
    imagenCarpeta = "carpetaSospechosos.png",
    nombreFicha = "Sospechoso",
    textoSinFichas = "Todavía no hablaste con ningún sospechoso."
) {
    override method fichas() = menu.sospechosos()

    override method confirmar(){
        if(self.hayFichas()){
            menu.irA(confirmacion)
        }
    }

    override method tamanioDeLetra() = estiloDeTexto.tamanioSospechosos()
}

object veredicto inherits Pantalla {
    var resultado = casoFallido
    var texto = ""

    method incriminar(unSospechoso){
        if(unSospechoso.puedeIrPreso()){
            resultado = casoResuelto
            texto = unSospechoso.nombre() + " era el culpable."
        }else if(unSospechoso.esCulpable()){
            resultado = casoFallido
            texto = unSospechoso.nombre() + " era el culpable, pero no tenías pistas suficientes."
        }else{
            resultado = casoFallido
            texto = unSospechoso.nombre() + " no era el culpable."
        }
        self.terminarPartida()
    }

    method terminarPartida(){
        musicaDeFondo.detener()
        sonidos.reproducir(resultado.musica())
        menu.irA(self)
        game.schedule(600000, { game.stop() })
    }

    override method armarVisuales() = [
        new Imagen(image = resultado.imagen(), position = game.at(5,3)),
        self.textoSobrePapel(texto, game.at(11,5))
    ]

    override method sePuedeCerrar() = false

    override method tamanioDeLetra() = estiloDeTexto.tamanioVeredicto()
}

object casoResuelto {
    method imagen() = "casoResuelto.png"
    method musica() = "musicaVictoria.mp3"
}

object casoFallido {
    method imagen() = "casoFallido.png"
    method musica() = "musicaDerrota.mp3"
}

object textos {
    method envolver(unTexto, ancho){
        const renglones = []
        var renglon = ""
        unTexto.words().forEach({ palabra =>
            if(renglon.isEmpty()){
                renglon = palabra
            }else if((renglon + " " + palabra).size() <= ancho){
                renglon = renglon + " " + palabra
            }else{
                renglones.add(renglon)
                renglon = palabra
            }
        })
        renglones.add(renglon)
        return renglones.join("\n")
    }
}