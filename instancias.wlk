import wollok.game.*
import detectives.*
import objetos.*
import interacciones.*
import restoPersonajes.*
import directorJuego.*
import dialogos.*
import controles.*
import debug.*
import habitaciones.*
import colisiones.*
import cuadroDeTexto.*
import menu.*
import musica.*
import animaciones.*

// ====================== PUERTAS ======================

const puertaEstacionamientoARecepcion = new Puerta(position = game.at(11,0), destino = recepcion, llegada = game.at(15,9))
const puertaRecepcionAEstacionamiento = new Puerta(position = game.at(15,10), destino = estacionamiento, llegada = game.at(11,1))

const puertaRecepcionAPasillo = new Puerta(position = game.at(0,5), pared = paredIzquierda, destino = pasillo, llegada = game.at(21,5), requisitos = [tarjetaTrabajador], textoCerrado = "Solo empleados.")
const puertaPasilloARecepcion = new Puerta(position = game.at(22,5), pared = paredDerecha, destino = recepcion, llegada = game.at(1,5))

const puertaRecepcionASalaDePrensa = new Puerta(position = game.at(18,4), pared = paredDerecha, destino = salaDePrensa, llegada = game.at(1,5),requisitos = [acreditacion], textoCerrado = "Sin acreditación de prensa no se puede pasar.")
const puertaSalaDePrensaARecepcion = new Puerta(position = game.at(0,5), pared = paredIzquierda, destino = recepcion, llegada = game.at(17,4))

const puertaPasilloAOficina = new Puerta(position = game.at(0,5), pared = paredIzquierda, destino = oficinaTapia, llegada = game.at(21,5))
const puertaOficinaAPasillo = new Puerta(position = game.at(22,5), pared = paredDerecha, destino = pasillo, llegada = game.at(1,5))

const puertaPasilloADescanso = new Puerta(position = game.at(5,8), destino = areaDescanso, llegada = game.at(11,1))
const puertaDescansoAPasillo = new Puerta(position = game.at(11,0), destino = pasillo, llegada = game.at(5,7))

const puertaPasilloABanios = new Puerta(position = game.at(15,8), destino = banios, llegada = game.at(11,1))
const puertaBaniosAPasillo = new Puerta(position = game.at(11,0), destino = pasillo, llegada = game.at(15,7))

const puertaPasilloAVestuarios = new Puerta(position = game.at(5,3), destino = vestuarios, llegada = game.at(11,9), requisitos = [llaveVestuario], textoCerrado = "El vestuario está cerrado con llave.")
const puertaVestuariosAPasillo = new Puerta(position = game.at(11,10), destino = pasillo, llegada = game.at(5,4))

const puertaPasilloATesorero = new Puerta(position = game.at(15,3), destino = oficinaTesorero, llegada = game.at(11,9), requisitos = [llaveTesorero], textoCerrado = "La oficina del tesorero está cerrada con llave.")
const puertaTesoreroAPasillo = new Puerta(position = game.at(11,10), destino = pasillo, llegada = game.at(15,4))

const puertaDescansoACocina = new Puerta(position = game.at(11,10), destino = cocina, llegada = game.at(11,1), requisitos = [permisoCocina], textoCerrado = "Solo personal de cocina. Capaz el chef te deja pasar.")
const puertaCocinaADescanso = new Puerta(position = game.at(11,0), destino = areaDescanso, llegada = game.at(11,9))

// ====================== ESTACIONAMIENTO ======================

const estacionamiento = new Habitacion(
    imagenDeFondo = "fondoEstacionamiento.png"  ,
    personajes = [],
    objetos = [puertaEstacionamientoARecepcion, autoPatricio, autoTapia, autoRojo],
    paredes = colisiones.fila(10, 0, 22) + colisiones.fila(0, 0, 22) + colisiones.columna(0, 1, 9) + colisiones.columna(22, 1, 9)
)

const autoPatricio = new Mueble(
    position = game.at(8,8),
    alto = 2,
    imagen = "autoNegro.png",
    descripcion = "Es mi auto."
)

const autoTapia = new MuebleConPista(
    position = game.at(14,8),
    alto = 2,
    imagen = "autoAzul.png",
    requisitos = [llaveAutoTapia],
    textoCerrado = "Creo que es el auto de Tapia.",
    pista = amenazas,
    textoHallazgo = "Adentro hay un papel con varias amenazas escritas hacia el presidente de la AFA.",
    descripcion = "Ahora es un auto sin dueño."
)

const autoRojo = new MuebleConPista(
    position = game.at(18,2),
    alto = 2,
    imagen = "autoRojo.png",
    requisitos = [llaveAutoRojo],
    textoCerrado = "Un auto rojo, parece bastante caro. Tiene algo dentro, necesito la llave",
    pista = bolsa,
    textoHallazgo = "Había una bolsa llena de guita, un arma y un papel que parece ser una denuncia. Está hasta las manos.",
    descripcion = "Ahora entiendo cómo se compró el auto."
)

const llaveAutoTapia = new Pista(imagen = "llaveAuto.png", nombre = "llave del auto de Tapia", texto = "La llave de un auto azul oscuro.")
const llaveAutoRojo = new Pista(imagen = "llaveAuto.png", nombre = "llave del auto rojo", texto = "La llave de un auto. El llavero parece de una marca carísima.")

const amenazas = new Pista(
    imagen = "papel.png", 
    nombre = "amenazas",
    texto = "Un papel con varias amenazas escritas hacia el presidente de la AFA. Estaba en el auto de Tapia."
)

const bolsa = new Pista(
    nombre = "bolsa",
    texto = "Una bolsa con mucho efectivo, un arma y una denuncia que le hizo el gobierno. Estaba en el auto rojo."
)

// ====================== RECEPCIÓN ======================

const recepcion = new Habitacion(
    imagenDeFondo = "fondoRecepcion.png",
    sonidoAlEntrar = musicaDeFondo,
    personajes = [recepcionista, hinchaRecepcion, empresarioRecepcion],
    objetos = [puertaRecepcionAEstacionamiento, puertaRecepcionAPasillo, puertaRecepcionASalaDePrensa, mostrador,
               palmeraRecepcion, sillonRecepcion, mesitaRecepcion, cuadroEstadioRecepcion, teleRecepcion, relojRecepcion,
               percheroRecepcion, pedestalRecepcion, sansevieriaRecepcion],
    paredes = colisiones.fila(10, 13, 18) + colisiones.fila(7, 0, 13) + colisiones.fila(2, 0, 18) + colisiones.columna(0, 3, 6) + colisiones.columna(13, 8, 9) + colisiones.columna(18, 3, 9)
)

const recepcionista = new Informante(
    position = game.at(10,6),
    imagen = "recepcionista.png",
    texto = "Hola, acá tenes tu acreditación para ingresar a la conferencia de prensa",
    pista = acreditacion,
    textoDespues = "La conferencia es en la sala de prensa, por la puerta de la derecha."
)

const mostrador = new Mueble(
    position = game.at(11,6),
    ancho = 2,
    imagen = "mostrador.png",
    descripcion = "El mostrador de la recepción. La computadora está bloqueada."
)

const acreditacion = new Pista(
    nombre = "acreditación de prensa",
    imagen = "acreditacion.png",
    texto = "Una acreditación de prensa. Con esto te dejan entrar a la sala de prensa."
)

const hinchaRecepcion = new Persona(position = game.at(3,4), imagen = "hincha.png", texto = "A este no lo dejan pasar por lo de Nico Paz")
const empresarioRecepcion = new Persona(position = game.at(7,5), imagen = "empresario.png", texto = "Soy de TN, no me dejan pasar a la conferencia")
const palmeraRecepcion = new Mueble(position = game.at(1,6), imagen = "palmeraMaceta.png", descripcion = "Una palmera en una maceta gigante.")
const sillonRecepcion = new Mueble(position = game.at(3,6), ancho = 2, imagen = "sillonDoble.png", descripcion = "Un sillón para las visitas. Parece cómodo.")
const mesitaRecepcion = new Mueble(position = game.at(5,6), imagen = "mesitaRevistas.png", descripcion = "Una mesita con revistas viejas.")
const cuadroEstadioRecepcion = new Mueble(position = game.at(2,7), imagen = "cuadroEstadio.png", descripcion = "Un cuadro de un estadio lleno.")
const teleRecepcion = new Mueble(position = game.at(6,7), ancho = 2, imagen = "televisorPared.png", descripcion = "Están pasando Luzu contra 412.")
const relojRecepcion = new Mueble(position = game.at(8,7), imagen = "relojPared.png", descripcion = "Un reloj de pared.")
const percheroRecepcion = new Mueble(position = game.at(14,9), imagen = "perchero.png", descripcion = "Un perchero con un piloto, una bufanda y un sombrero.")
const pedestalRecepcion = new Mueble(position = game.at(17,9), imagen = "pedestalPelota.png", descripcion = "Un balón de oro en una vitrina, grande enano.")
const sansevieriaRecepcion = new Mueble(position = game.at(17,3), imagen = "sansevieria.png", descripcion = "Una planta con hojas largas y puntiagudas.")

// ====================== SALA DE PRENSA ======================

const salaDePrensa = new Habitacion(
    imagenDeFondo = "fondoSalaPrensa.png",
    personajes = [camarografo, empleadoAfa, periodista, presidenteFifa,
                  periodistaMicrofonoSala, periodistaLibretaSala, fotografoSala, periodistaEspalda1Sala, periodistaEspalda2Sala],
    objetos = [puertaSalaDePrensaARecepcion, escenario, estrado, camaraTV1, camaraTV2,
               camaraTripodeSala, camaraFotoSala, reflector1Sala, reflector2Sala],
    paredes = colisiones.fila(9, 0, 22) + colisiones.fila(0, 0, 22) + colisiones.columna(0, 1, 8) + colisiones.columna(22, 1, 8)
)

const escenario = new Escenario(
    position = game.at(8,5), ancho = 7, alto = 4,
    entrada = game.at(8,8),
    imagen = "escenario.png",
    descripcion = "El escenario de las conferencias. Se sube por la escalera."
)

const estrado = new MuebleConPista(
    position = game.at(11,7),
    imagen = "estrado.png",
    pista = tarjetaTrabajador,
    textoHallazgo = "Adentro del estrado había una tarjeta de trabajador de la AFA.",
    descripcion = "El estrado está vacío."
)

const tarjetaTrabajador = new Pista(
    nombre = "tarjeta de trabajador",
    imagen = "tarjetaTrabajador.png",
    texto = "Una tarjeta de trabajador de la AFA. Estaba escondida en el estrado de la sala de prensa."
)

const periodista = new Persona(
    position = game.at(10,3),
    imagen = "periodista.png",
    texto = "¿Usted es el detective? ¿Es verdad lo que se dice del Chiqui?"
)

const camarografo = new Persona(
    position = game.at(12,3),
    imagen = "camarografo.png",
    texto = "Estamos en vivo, no se me cruce adelante de la cámara."
)

const empleadoAfa = new Persona(
    position = game.at(18,5),
    imagen = "empleado.png",
    texto = "La conferencia se suspendió. Desde la mañana nadie sabe nada del Chiqui."
)

const camaraTV1 = new Mueble(position = game.at(6,3), imagen = "camaraTV.png", descripcion = "Una cámara de televisión. Está grabando.")
const camaraTV2 = new Mueble(position = game.at(16,3), imagen = "camaraTV.png", descripcion = "Una cámara de televisión. Está grabando.")

const presidenteFifa = new Sospechoso(
    position = game.at(16,6),
    nombre = "Presidente de la FIFA",
    esCulpable = true,
    pistasNecesarias = [termo, conversacionesWhatsapp, informeForense],
    descripcion = "Es el presidente de la FIFA y tiene un gran poder de influencia.",
    nombreBaseImagen = "pelado",
    imagen = "pelado.png",
    texto = "No tengo nada más para decirte. Estoy ocupado.",
    preguntas = [preguntaPresidente1, preguntaPresidente2]
)

const preguntaPresidente1 = new Pregunta(
    texto = "¿Qué queres pancho? No ves que estoy ocupado.",
    opciones = [opcionPresidente1, opcionPresidente2, opcionPresidente3]
)

const opcionPresidente1 = new OpcionDialogo(
    texto = "Ehh, relaja pelado, ¿no viste algo fuera de lo normal hoy?",
    tono = gentil,
    respuestaNormal = "Que voy a ver yo. Tengo mucho laburo como para ver boludeces.",
    respuestaEnojada = "¡No me rompas las pelotas, no vi un carajo. Tomatela!"
)

const opcionPresidente2 = new OpcionDialogo(
    texto = "Pero mira la cara de zapallo que tenes, sos re culpable!.",
    tono = provocador,
    respuestaNormal = "¿Qué decís? ¡No hable con la victima en todo el dia!",
    respuestaEnojada = "¡ZAPALLO QUIEN, YO NO FUI ESTUPIDO!"
)

const opcionPresidente3 = new OpcionDialogo(
    texto = "¿Sabes que le paso al chiqui?",
    tono = neutral,
    respuestaNormal = "No hable con el, le paso algo?",
    respuestaEnojada = "No y si supiera no te diria."
)

const preguntaPresidente2 = new Pregunta(
    texto = "Que queres ahora?",
    requisitos = [informeForense],
    opciones = [opcionPresidente4, opcionPresidente5, opcionPresidente6]
)

const opcionPresidente4 = new OpcionDialogo(
    texto = "Tengo cierta informacion, el chiqui murio envenenado, sabes algo de eso?",
    tono = gentil,
    respuestaNormal = "Oh no!, my poor Chiqui, I love him so much, rest in peace",
    respuestaEnojada = "Naaaaaa no me diga posho, y bueno estaba hasta las manos el gordo"
)

const opcionPresidente5 = new OpcionDialogo(
    texto = "El chiqui fue envenado por una toxina proveniente de Europa, vos sos de por ahi, no te parece raro?",
    tono = provocador,
    respuestaNormal = "Es una falta de respeto que me quieras acusar de algo tan grave, no sabés con quién estás hablando?",
    respuestaEnojada = "Me volves a preguntar algo y te van a encontrar flotando en el río Luján, me escuchaste?"
)

const opcionPresidente6 = new OpcionDialogo(
    texto = "El chiqui fue envenenado",
    tono = neutral,
    respuestaNormal = "Jajajaj",
    respuestaEnojada = "Na re pálida"
)

const periodistaMicrofonoSala = new Persona(position = game.at(4,4), imagen = "periodistaMicrofono.png", texto = "Al fin vamos a tener un torneo como la gente")
const periodistaLibretaSala = new Persona(position = game.at(19,2), imagen = "periodistaLibreta.png", texto = "Ruggeri se cree que es ejemplo")
const fotografoSala = new Persona(position = game.at(19,7), imagen = "fotografo.png", texto = "Ahora a que le saco fotos")
const periodistaEspalda1Sala = new Persona(position = game.at(8,2), imagen = "periodistaEspalda1.png", texto = "Gracias a dios")
const periodistaEspalda2Sala = new Persona(position = game.at(14,3), imagen = "periodistaEspalda2.png", texto = "Lo mando a matar alguno de clarin seguramente")
const camaraTripodeSala = new Mueble(position = game.at(4,1), imagen = "camaraTripode.png", descripcion = "Una cámara filmando a la periodista.")
const camaraFotoSala = new Mueble(position = game.at(11,1), imagen = "camaraFotoTripode.png", descripcion = "Una cámara de fotos apuntando al estrado.")
const reflector1Sala = new Mueble(position = game.at(3,8), imagen = "reflector.png", descripcion = "Un reflector apuntando al escenario.")
const reflector2Sala = new Mueble(position = game.at(20,8), imagen = "reflector.png", descripcion = "Un reflector apuntando al escenario.")

// ====================== PASILLO ======================

const pasillo = new Habitacion(
    imagenDeFondo = "fondoPasillo.png",
    personajes = [guardia, utileroPasillo, secretariaPasillo, tecnicoPasillo],
    objetos = [puertaPasilloAOficina, puertaPasilloABanios, puertaPasilloARecepcion, puertaPasilloADescanso, puertaPasilloAVestuarios, puertaPasilloATesorero,
               ficusPasillo, sillasPasillo, dispenserPasillo, maquinaCafePasillo, cuadroCopaPasillo, carteleraPasillo, cuadroCamisetaPasillo,
               paragueroPasillo, cactusPasillo],
    paredes = colisiones.fila(8, 0, 22) + colisiones.fila(3, 0, 22) + colisiones.columna(0, 4, 7) + colisiones.columna(22, 4, 7)
)

const guardia = new Sospechoso(
    position = game.at(1,5),
    nombre = "el guardia",
    nombreBaseImagen = "guardia",
    imagen = "guardiaNormal.png",
    texto = "Estoy laburando, tomátela.",
    preguntas = [preguntaGuardiaNervioso, preguntaGuardiaPorro],
    descripcion = "Guardia de la Oficina Del Chiqui"
)

const preguntaGuardiaNervioso = new Pregunta(
    texto = "Estoy re sacado. A la oficina del Chiqui no pasa nadie.",
    opciones = [opcionGuardiaNervioso1, opcionGuardiaNervioso2, opcionGuardiaNervioso3]
)

const opcionGuardiaNervioso1 = new OpcionDialogo(
    texto = "Te voy a pedir amablemente que me dejes entrar a la oficina",
    tono = gentil,
    respuestaNormal = "Estoy laburando, tomátela que ando estresado",
    respuestaEnojada = "No escuchaste que dije que estoy re sacado, tomátela"
)

const opcionGuardiaNervioso2 = new OpcionDialogo(
    texto = "Te vas a correr maestro o te corro yo",
    tono = provocador,
    respuestaNormal = "A quién vas a correr rubiesito de Nordelta, tomátela",
    respuestaEnojada = "Que te haces el vivo, tomátela o te hago de goma"
)

const opcionGuardiaNervioso3 = new OpcionDialogo(
    texto = "Dejame entrar",
    tono = neutral,
    respuestaNormal = "No me hinches que estoy alterado",
    respuestaEnojada = "Al cielo te voy a hacer entrar si no te las tomas"
)

const preguntaGuardiaPorro = new Pregunta(
    texto = "Pensé que había quedado claro",
    requisitos = [porro],
    opciones = [opcionGuardiaPorro1, opcionGuardiaPorro2],
    alResponder = { elGuardia => elGuardia.moverseA(game.at(1,7)) }
)

const opcionGuardiaPorro1 = new OpcionDialogo(
    texto = "Noté que estabas alterado, te traje esto para desestrezar",
    tono = gentil,
    respuestaNormal = "Uhh que genio maestro alta genética, muchas gracias pasá tranquilo",
    respuestaEnojada = "Me lo voy a fumar, pero igual te quiero romper la cabeza"
)

const opcionGuardiaPorro2 = new OpcionDialogo(
    texto = "Te conseguí esto, dejame pasar y te lo doy",
    tono = neutral,
    respuestaNormal = "Uhh lo re necesitaba, dale pasá pero no digas nada",
    respuestaEnojada = "Me lo fumo y después te peleo"
)

const utileroPasillo = new Persona(position = game.at(13,6), imagen = "utilero.png", texto = "Que pena lo del chiqui, hacia buenos mates")
const secretariaPasillo = new Persona(position = game.at(19,7), imagen = "secretaria.png", texto = "Hay un olor raro en el baño, nose que sera")
const tecnicoPasillo = new Persona(position = game.at(11,4), imagen = "tecnico.png", texto = "Me llamaron porque se habia roto algo y ahora no me dejan irme")
const ficusPasillo = new Mueble(position = game.at(3,7), imagen = "ficusAlto.png", descripcion = "Un arbol bastante grande.")
const sillasPasillo = new Mueble(position = game.at(7,7), ancho = 2, imagen = "sillasEspera.png", descripcion = "Sillas de espera. Alguien se olvidó un diario.")
const dispenserPasillo = new Mueble(position = game.at(17,7), imagen = "dispenserAgua.png", descripcion = "Refrescante")
const maquinaCafePasillo = new Mueble(position = game.at(18,7), imagen = "maquinaCafe.png", descripcion = "Una máquina de café.")
const cuadroCopaPasillo = new Mueble(position = game.at(10,8), imagen = "cuadroCopa.png", descripcion = "Un cuadro con una copa dorada.")
const carteleraPasillo = new Mueble(position = game.at(12,8), imagen = "cartelera.png", descripcion = "Una cartelera llena de papelitos.")
const cuadroCamisetaPasillo = new Mueble(position = game.at(20,8), imagen = "cuadroCamiseta.png", descripcion = "Una camiseta enmarcada con el número 10.")
const paragueroPasillo = new Mueble(position = game.at(3,4), imagen = "paraguero.png", descripcion = "Un paragüero con dos paraguas.")
const cactusPasillo = new Mueble(position = game.at(19,4), imagen = "cactusMaceta.png", descripcion = "Un cactus con una flor rosa.")

// ====================== BAÑOS ======================

const banios = new Habitacion(
    imagenDeFondo = "fondoBanios.png",
    personajes = [senoraLimpieza, tuca],
    objetos = [puertaBaniosAPasillo, inodoro1, inodoro2, inodoro3, lavamanos1, lavamanos2, lavamanos3, ducha1, ducha2, ventanaBanio, cuadroGenio],
    paredes = colisiones.fila(10, 0, 22) + colisiones.fila(0, 0, 22) + colisiones.columna(0, 1, 9) + colisiones.columna(22, 1, 9)
)

const inodoro1 = new Mueble(position = game.at(2,9), imagen = "inodoro.png", descripcion = "Un inodoro. Por suerte está limpio.")
const inodoro2 = new Mueble(position = game.at(4,9), imagen = "inodoro.png", descripcion = "Un inodoro. Por suerte está limpio.")
const inodoro3 = new Mueble(position = game.at(6,9), imagen = "inodoro.png", descripcion = "Un inodoro. Por suerte está limpio.")

const lavamanos1 = new Mueble(position = game.at(9,9), imagen = "lavamanos.png", descripcion = "Un lavamanos.")
const lavamanos2 = new Mueble(position = game.at(11,9), imagen = "lavamanos.png", descripcion = "Todavía quedan unas manchitas rojas en la pileta.")
const lavamanos3 = new Mueble(position = game.at(13,9), imagen = "lavamanos.png", descripcion = "Un lavamanos.")

const ducha1 = new Mueble(position = game.at(15,9), imagen = "ducha.png", descripcion = "Una ducha. Está seca, hoy nadie la usó.")
const ducha2 = new Mueble(position = game.at(17,9), imagen = "ducha.png", descripcion = "Una ducha. Está seca, hoy nadie la usó.")

const ventanaBanio = new Mueble(
    position = game.at(20,10),
    imagen = "ventanaBanio.png",
    descripcion = "Una ventanita abierta. Sale un olor raro."
)

const senoraLimpieza = new Persona(
    position = game.at(7,5),
    imagen = "senoraLimpieza.png",
    texto = "Hoy vi a alguien lavándose las manos llenas de sangre acá. No le llegué a ver la cara."
)

const tuca = new Informante(
    position = game.at(21,9),
    imagen = "tuca.png",
    texto = "Shh, no le digas a nadie que vine a fumar al baño. Te doy esto para comprar tu silencio.",
    pista = porro,
    textoDespues = "No le digas a nadie, eh."
)

const porro = new Pista(
    nombre = "porro",
    texto = "Un porro que te dio Tuca para que no digas nada. Al guardia le puede interesar."
)

const cuadroGenio = new MuebleConSonido(
    position = game.at(7,10),
    imagen = "cuadroGenio.png",
    descripcion = "Un cuadro que dice GENIO.",
    audios = ["genio1.mp3", "genio2.mp3", "genio3.mp3"]
)

// ====================== OFICINA DE TAPIA ======================

const oficinaTapia = new Habitacion(
    imagenDeFondo = "fondoOficinaTapia.png",
    personajes = [forense, peritoOficina],
    objetos = [escritorioTapia, cuerpo, termo, puertaOficinaAPasillo,
               monsteraOficina1, estanteOficina, globoOficina, banderaOficina, lamparaOficina, sofaOficina, bonsaiOficina,
               mapaOficina, ventanalOficina, placasOficina, monsteraOficina2, evidencia1Oficina, evidencia2Oficina],
    paredes = colisiones.fila(10, 0, 22) + colisiones.fila(0, 0, 22) + colisiones.columna(0, 1, 9) + colisiones.columna(22, 1, 9)
)

const escritorioTapia = new MuebleConPista(
    position = game.at(11,6),
    ancho = 2,
    alto = 2,
    imagen = "escritorioTapia.png",
    pista = conversacionesWhatsapp,
    textoHallazgo = "En la computadora del escritorio había varias conversaciones fuertes con gente presente en el predio.",
    descripcion = "El escritorio del Chiqui. El mate está frío y la computadora sigue prendida."
)

const cuerpo = new MuebleConPista(
    position = game.at(11,4),
    ancho = 2,
    imagen = "cuerpo.png",
    pista = llaveAutoTapia,
    textoHallazgo = "Está muerto. En el bolsillo del saco tenía la llave de un auto.",
    descripcion = "Ya revisé el cuerpo. No tiene nada más."
)

const termo = new Pista(
    position = game.at(9,4),
    nombre = "termo",
    imagen = "termoTirado.png",
    texto = "El termo del Chiqui, tirado en el piso. Tiene un olor raro."
)

const conversacionesWhatsapp = new Pista(
    imagen = "papel.png", 
    nombre = "conversaciones de whatsapp",
    texto = "Hay amenazas de jugadores de la seleccion y alguien agendado como `Pela` le reclama plata."
)

const forense = new InformanteConPedido(
    position = game.at(14,4),
    imagen = "forense.png",
    pedido = [bolsa],
    textoPedido = "Así que vos sos el detective, yo te puedo dar algo que te podría servir, pero viste que está difícil llegar a fin de mes...",
    texto = "No te voy a preguntar de dónde sacaste esto, acá tenés el informe preeliminar",
    pista = informeForense,
    textoDespues = "Ya te dí el informe, no te voy a devolver la guita"
)

const informeForense = new Pista(
    imagen = "papel.png", 
    nombre = "informe del forense",
    texto = "Según el informe del forense, a Tapia lo envenenaron con una toxina proveniente de Europa.
    Despues no se encontro ni un pelo"
)

const peritoOficina = new Persona(position = game.at(10,2), imagen = "perito.png", texto = "Le saque una foto al fiambre de tapia, esta va para un museo")
const monsteraOficina1 = new Mueble(position = game.at(1,9), imagen = "monstera.png", descripcion = "Una planta enorme. Las hojas tienen agujeros.")
const estanteOficina = new Mueble(position = game.at(3,9), ancho = 2, imagen = "estanteTrofeos.png", descripcion = "Un estante con copas, libros y una pelota.")
const globoOficina = new Mueble(position = game.at(8,9), imagen = "globoTerraqueo.png", descripcion = "Un globo terráqueo, Tapia lo usaba para elegir al azar un amistoso")
const banderaOficina = new Mueble(position = game.at(10,9), imagen = "banderaArgentina.png", descripcion = "La bandera argentina.")
const lamparaOficina = new Mueble(position = game.at(16,9), imagen = "lamparaPie.png", descripcion = "Una lámpara de pie.")
const sofaOficina = new Mueble(position = game.at(17,9), ancho = 2, imagen = "sofaChester.png", descripcion = "Un sillón de cuero. Se nota que es caro.")
const bonsaiOficina = new Mueble(position = game.at(19,9), imagen = "bonsai.png", descripcion = "Un bonsái muy bien cuidado.")
const mapaOficina = new Mueble(position = game.at(6,10), imagen = "mapaArgentina.png", descripcion = "Un mapa de la Argentina con alfileres.")
const ventanalOficina = new Mueble(position = game.at(11,10), ancho = 2, imagen = "ventanal.png", descripcion = "Desde acá se ve toda la ciudad.")
const placasOficina = new Mueble(position = game.at(14,10), imagen = "placasHonor.png", descripcion = "Placas de reconocimiento a nombre del Chiqui.")
const monsteraOficina2 = new Mueble(position = game.at(1,1), imagen = "monstera.png", descripcion = "Una planta enorme. Las hojas tienen agujeros.")
const evidencia1Oficina = new Mueble(position = game.at(8,4), imagen = "marcadorEvidencia1.png", descripcion = "Un marcador de evidencia con el número 1.")
const evidencia2Oficina = new Mueble(position = game.at(13,3), imagen = "marcadorEvidencia2.png", descripcion = "Un marcador de evidencia con el número 2.")

// ====================== ÁREA DE DESCANSO (COMEDOR) ======================

const areaDescanso = new Habitacion(
    imagenDeFondo = "fondoAreaDescanso.png",
    personajes = [chef, jugador, mozo, arquero],
    objetos = [mesaLarga, buffet, heladera, planta1, planta2, tele, puertaDescansoAPasillo, puertaDescansoACocina, cuadroDiLollo],
    paredes = colisiones.fila(10, 0, 22) + colisiones.fila(0, 0, 22) + colisiones.columna(0, 1, 9) + colisiones.columna(22, 1, 9)
)

const mesaLarga = new Mueble(
    position = game.at(5,4),
    ancho = 13,
    alto = 3,
    imagen = "mesaLarga.png",
    descripcion = "La mesa del plantel. Tiene 26 sillas, una para cada jugador."
)

const buffet = new Mueble(
    position = game.at(14,9),
    ancho = 3,
    imagen = "buffet.png",
    descripcion = "El buffet del almuerzo. Hay milanesas, fideos y ensalada."
)

const heladera = new Mueble(
    position = game.at(19,9),
    imagen = "heladera.png",
    descripcion = "Una heladera llena de agua y bebidas isotónicas."
)

const planta1 = new Mueble(position = game.at(1,9), imagen = "planta.png", descripcion = "Una planta. Alguien se olvidó de regarla.")
const planta2 = new Mueble(position = game.at(21,9), imagen = "planta.png", descripcion = "Una planta. Alguien se olvidó de regarla.")

const tele = new Mueble(
    position = game.at(6,10),
    imagen = "tele.png",
    descripcion = "Descendio chicago."
)

const chef = new Informante(
    position = game.at(13,9),
    imagen = "cocinero.png",
    texto = "¿Sos el detective? A mi cocina no entra cualquiera, pero tomá este permiso y pasá.",
    pista = permisoCocina,
    textoDespues = "La cocina es por la puerta de arriba. No me toques nada, que está todo limpio."
)

const permisoCocina = new Pista(
    nombre = "permiso de cocina",
    imagen = "permisoCocina.png",
    texto = "Un permiso firmado por el chef. Con esto te dejan entrar a la cocina."
)

const jugador = new Persona(
    position = game.at(19,5),
    imagen = "jugador.png",
    texto = "El Chiqui siempre comía con nosotros antes de los partidos. Hoy no apareció."
)

const mozo = new Persona(
    position = game.at(8,2),
    imagen = "mozo.png",
    texto = "¿Le sirvo algo, detective? Hoy hay milanesas con puré."
)

const cuadroDiLollo = new MuebleConSonido(
    position = game.at(3,10),
    imagen = "cuadroDiLollo.png",
    descripcion = "Una foto de un jugador.",
    audios = ["dilollo1.mp3", "dilollo2.mp3", "dilollo3.mp3"]
)

// ====================== COCINA ======================

const cocina = new Habitacion(
    imagenDeFondo = "fondoCocina.png",
    personajes = [],
    objetos = [estanteria1, horno1, horno2, horno3, horno4, pava, mesadaPileta, heladeraCocina, estanteria2,
               mesaDeTrabajo, mesaEmplatado, hornoBarro, tacho, bolsasPapas, cajonVerduras, puertaCocinaADescanso],
    paredes = colisiones.fila(10, 0, 22) + colisiones.fila(0, 0, 22) + colisiones.columna(0, 1, 9) + colisiones.columna(22, 1, 9)
)

const estanteria1 = new Mueble(position = game.at(1,9), ancho = 2, imagen = "estanteria.png", descripcion = "Ollas, latas de tomate y bolsas de harina.")
const horno1 = new Mueble(position = game.at(4,9), imagen = "horno.png", descripcion = "Está apagado. Adentro no hay nada.")
const horno2 = new Mueble(position = game.at(5,9), imagen = "horno.png", descripcion = "Adentro hay una bandeja de pan quemado. Mejor no tocar.")
const horno3 = new MuebleConPista(
    position = game.at(6,9),
    imagen = "horno.png",
    pista = empanadas,
    textoHallazgo = "Adentro del horno había una bandeja de empanadas recién hechas.",
    descripcion = "El horno quedó vacío."
)

const horno4 = new Mueble(position = game.at(7,9), imagen = "horno.png", descripcion = "Está apagado. Adentro no hay nada.")
const pava = new Mueble(position = game.at(9,9), imagen = "pava.png", descripcion = "La pava con la que se calentó el agua del mate. No tiene rastros de veneno.")
const mesadaPileta = new Mueble(position = game.at(11,9), ancho = 3, imagen = "mesadaPileta.png", descripcion = "La pileta está llena de platos sin lavar.")
const heladeraCocina = new Mueble(position = game.at(15,9), ancho = 2, imagen = "heladeraCocina.png", descripcion = "Una heladera enorme. Hay carne para todo el plantel.")
const estanteria2 = new Mueble(position = game.at(18,9), ancho = 2, imagen = "estanteria.png", descripcion = "Más ollas y más latas. Acá cocinan para un ejército.")

const mesaDeTrabajo = new Mueble(
    position = game.at(4,5),
    ancho = 4,
    alto = 2,
    imagen = "mesaDeTrabajo.png",
    descripcion = "Están preparando más empanadas. La masa todavía está fresca."
)

const mesaEmplatado = new Mueble(
    position = game.at(14,5),
    ancho = 4,
    alto = 2,
    imagen = "mesaEmplatado.png",
    descripcion = "Milanesas, puré y fruta. El almuerzo del plantel."
)

const hornoBarro = new Mueble(
    position = game.at(1,1),
    ancho = 2,
    alto = 2,
    imagen = "hornoBarro.png",
    descripcion = "Un horno de barro. Está prendido, pero adentro no hay nada."
)

const tacho = new MuebleConScreamer(position = game.at(4,1), imagen = "tacho.png", descripcion = "El tacho de basura. Mejor no revolver.")
const bolsasPapas = new Mueble(position = game.at(20,1), imagen = "bolsasPapas.png", descripcion = "Bolsas de papas. Para el puré de mañana.")
const cajonVerduras = new Mueble(position = game.at(21,1), imagen = "cajonVerduras.png", descripcion = "Un cajón de tomates y lechuga.")

const llaveVestuario = new Pista(
    nombre = "llave del vestuario",
    imagen = "llaveVestuario.png",
    texto = "La llave del vestuario. Te la dio el arquero a cambio de las empanadas."
)

const arquero = new InformanteConPedido(
    position = game.at(3,5),
    imagen = "arquero.png",
    pedido = [empanadas],
    textoPedido = "Tengo un hambre que me muero. El chef dejó algo en el horno, pero a mí no me deja entrar.",
    texto = "¡Empanadas! Sos un crack. Tomá, la llave del vestuario, los chicos capaz saben algo",
    pista = llaveVestuario,
    textoDespues = "El vestuario es la puerta de abajo a la izquierda del pasillo."
)

const empanadas = new Pista(
    nombre = "empanadas",
    texto = "Una bandeja de empanadas recién hechas. Estaban en uno de los hornos de la cocina."
)

// ====================== VESTUARIO ======================

const vestuarios = new Habitacion(
    imagenDeFondo = "fondoVestuarios.png",
    personajes = [delantero, extremo],
    objetos = [casillero1, casillero2, casillero3, casillero4, casillero5, casillero6,
               casillero7, casillero8, casillero9, casillero10, casillero11, casillero12,
               pizarraTactica, conservadora, cestoRopa, banco1, banco2,
               botines, pelota, camilla, vallas, conos, bolsaPelotas, puertaVestuariosAPasillo],
    paredes = colisiones.fila(10, 0, 22) + colisiones.fila(0, 0, 22) + colisiones.columna(0, 1, 9) + colisiones.columna(22, 1, 9)
)

const casillero1 = new Mueble(position = game.at(1,9), imagen = "casilleroCamiseta.png", descripcion = "Una camiseta colgada y los botines abajo.")
const casillero2 = new Mueble(position = game.at(2,9), imagen = "casilleroBolso.png", descripcion = "Una toalla y un bolso. Nada raro.")
const casillero3 = new Mueble(position = game.at(3,9), imagen = "casilleroCamiseta.png", descripcion = "Una camiseta colgada y los botines abajo.")
const casillero4 = new Mueble(position = game.at(4,9), imagen = "casilleroBolso.png", descripcion = "Una toalla y un bolso. Nada raro.")
const casillero5 = new Mueble(position = game.at(5,9), imagen = "casilleroCamiseta.png", descripcion = "Una camiseta colgada y los botines abajo.")
const casillero6 = new Mueble(position = game.at(6,9), imagen = "casilleroBolso.png", descripcion = "Una toalla y un bolso. Nada raro.")
const casillero7 = new Mueble(position = game.at(16,9), imagen = "casilleroCamiseta.png", descripcion = "Una camiseta colgada y los botines abajo.")
const casillero8 = new Mueble(position = game.at(17,9), imagen = "casilleroBolso.png", descripcion = "Una toalla y un bolso. Nada raro.")
const casillero9 = new Mueble(position = game.at(18,9), imagen = "casilleroCamiseta.png", descripcion = "Una camiseta colgada y los botines abajo.")
const casillero10 = new Mueble(position = game.at(19,9), imagen = "casilleroBolso.png", descripcion = "Una toalla y un bolso. Nada raro.")
const casillero11 = new Mueble(position = game.at(20,9), imagen = "casilleroCamiseta.png", descripcion = "Una camiseta colgada y los botines abajo.")
const casillero12 = new Mueble(position = game.at(21,9), imagen = "casilleroBolso.png", descripcion = "Una toalla y un bolso. Nada raro.")

const pizarraTactica = new Mueble(
    position = game.at(7,9),
    ancho = 2,
    imagen = "pizarraTactica.png",
    descripcion = "La pizarra con la táctica del próximo partido. Siempre pone 5 volantes"
)

const conservadora = new Mueble(position = game.at(13,9), imagen = "conservadora.png", descripcion = "El bidón de agua del plantel. Está casi vacío.")
const cestoRopa = new Mueble(position = game.at(14,9), imagen = "cestoRopa.png", descripcion = "Un cesto lleno de ropa sucia. Mejor no tocar.")
const banco1 = new Mueble(position = game.at(2,7), ancho = 4, imagen = "banco.png", descripcion = "Un banco con una toalla y una botella.")
const banco2 = new Mueble(position = game.at(17,7), ancho = 4, imagen = "banco.png", descripcion = "Un banco con una toalla y una botella.")
const botines = new Mueble(position = game.at(6,6), imagen = "botines.png", descripcion = "Unos botines tirados. Todavía tienen barro.")
const pelota = new Mueble(position = game.at(10,5), imagen = "pelota.png", descripcion = "Una pelota. Está un poco desinflada.")
const camilla = new Mueble(position = game.at(2,2), ancho = 2, imagen = "camilla.png", descripcion = "La camilla del kinesiólogo.")
const vallas = new Mueble(position = game.at(9,2), ancho = 2, imagen = "vallas.png", descripcion = "Vallitas para el entrenamiento.")
const conos = new Mueble(position = game.at(17,2), imagen = "conos.png", descripcion = "Una pila de conos para el entrenamiento.")
const bolsaPelotas = new Mueble(position = game.at(20,2), imagen = "bolsaPelotas.png", descripcion = "Una bolsa llena de pelotas.")

const extremo = new Informante(
    position = game.at(15,5),
    imagen = "extremo.png",
    texto = "No me puedo creer lo del Chiqui, yo lo amaba, me dió una copa en una combi y se cansó de regalarme penales.
    Tomá la llave de la oficina de Toviggino, él puede tener algo que ver",
    pista = llaveTesorero,
    textoDespues = "La tenía porque se la olvidó cuando vimos perder a Estudiante, que alegría"
)

const llaveTesorero = new Pista(
    nombre = "llave del tesorero",
    imagen = "llaveTesorero.png",
    texto = "La llave de la oficina del tesorero. Te la dio el Fideo en el vestuario."
)

const delantero = new Sospechoso(
    position = game.at(7,4),
    nombre = "Julián",
    nombreBaseImagen = "delantero",
    imagen = "delanteroNormal.png",
    texto = "No es serio que pienses que fui yo",
    preguntas = [preguntaDelantero1, preguntaDelantero2],
    descripcion = "Julián, el delantero de la selección, se llevaba mal con Tapia"
)

const preguntaDelantero1 = new Pregunta(
    texto = "Me enteré lo del Chiqui, el fideo se puso muy triste",
    opciones = [opcionDelantero1, opcionDelantero2, opcionDelantero3]
)

const opcionDelantero1 = new OpcionDialogo(
    texto = "Y a vos no te puso triste?",
    tono = gentil,
    respuestaNormal = "Obvio como no, pero la realidad es que no teníamos una buena relación",
    respuestaEnojada = "Qué te pasa chabón, vos moriste en Madrid me parece"
)

const opcionDelantero2 = new OpcionDialogo(
    texto = "La gente dice que se llevaban muy mal, sos sospechoso sabelo",
    tono = provocador,
    respuestaNormal = "Es verdad, pero nunca le desearía algo así a nadie, soy más bueno que el pan",
    respuestaEnojada = "Y la verdad que me puso contento, para qué carajo mentirte, destrozó el fútbol argentino el caradura"
)

const opcionDelantero3 = new OpcionDialogo(
    texto = "Sabes quién podría querer hacerle algo así?",
    tono = neutral,
    respuestaNormal = "No me gusta hablar sin saber, pero en este edificio hay gente con la que tuvo varios conflictos",
    respuestaEnojada = "Siempre fue un hijo de puta, estoy seguro que mucha gente estará feliz"
)

const preguntaDelantero2 = new Pregunta(
    texto = "Cómo encontraste estos chats??",
    requisitos = [conversacionesWhatsapp],
    opciones = [opcionDelantero4, opcionDelantero5, opcionDelantero6]
)

const opcionDelantero4 = new OpcionDialogo(
    texto = "Se ve que estuvieron discutiendo últimamente, querés decir algo?",
    tono = gentil,
    respuestaNormal = "Me duele que ese haya sido mi último contacto con él",
    respuestaEnojada = "Discutimos porque era un mafioso, un provocador, y más feo que bailar con tu hermana. NADIE SE METE CON RIVER"
)

const opcionDelantero5 = new OpcionDialogo(
    texto = "Creo que encontré a mi principal sospechoso",
    tono = provocador,
    respuestaNormal = "Dale hermano, date cuenta que hay gente muy poderosa que lo quería desaparecer del mapa en este lugar",
    respuestaEnojada = "YO NO LO MATÉ PERO ME ALEGRÉ MAS QUE EN EL 9 DE DICIEMBRE, A JODER CON RIVER AL CIELO SALUDOS"
)

const opcionDelantero6 = new OpcionDialogo(
    texto = "Dame una buena razón para no pensar que fuiste vos",
    tono = neutral,
    respuestaNormal = "Estuvo metido en cosas muy turbias con Toviggino, y tuvo problemas con el Presidente de la FIFA",
    respuestaEnojada = "Porque estaba ocupado agarrándome a tu hermana, te duele Qatar secanucas"
)

// ====================== OFICINA DEL TESORERO ======================

const oficinaTesorero = new Habitacion(
    imagenDeFondo = "fondoOficinaTesorero.png",
    personajes = [tesorero],
    objetos = [plantaTesorero1, bibliotecaTesorero, archivero1, archivero2, vitrinaTrofeos, cajasArchivo1, cajaFuerte, plantaTesorero2,
               sillonTesorero, escritorioTesorero, trituradora, rotafolio, sillon1, mesaRatona, sillon2, cajasArchivo2,
               puertaTesoreroAPasillo],
    paredes = colisiones.fila(10, 0, 22) + colisiones.fila(0, 0, 22) + colisiones.columna(0, 1, 9) + colisiones.columna(22, 1, 9)
)

const plantaTesorero1 = new Mueble(position = game.at(1,9), imagen = "planta.png", descripcion = "Una planta. Es de plástico.")
const bibliotecaTesorero = new Mueble(position = game.at(2,9), ancho = 2, imagen = "biblioteca.png", descripcion = "Libros de contabilidad y finanzas. Ninguno parece usado.")
const archivero1 = new Mueble(position = game.at(5,9), imagen = "archivero.png", descripcion = "Carpetas con balances de la AFA.")
const archivero2 = new Mueble(position = game.at(6,9), imagen = "archivero.png", descripcion = "Facturas y más facturas.")
const vitrinaTrofeos = new Mueble(position = game.at(14,9), ancho = 2, imagen = "vitrinaTrofeos.png", descripcion = "Una vitrina llena de copas y medallas.")
const cajasArchivo1 = new Mueble(position = game.at(17,9), imagen = "cajasArchivo.png", descripcion = "Cajas de archivo. Dicen 'balances' en la etiqueta.")
const plantaTesorero2 = new Mueble(position = game.at(21,9), imagen = "planta.png", descripcion = "Una planta. Es de plástico.")
const sillonTesorero = new Mueble(position = game.at(10,6), imagen = "sillon.png", descripcion = "El sillón del tesorero. Es de cuero.")
const trituradora = new Mueble(position = game.at(13,4), imagen = "trituradora.png", descripcion = "Alguien estuvo triturando papeles hace poco.")
const rotafolio = new Mueble(position = game.at(18,5), imagen = "rotafolio.png", descripcion = "Un gráfico de ganancias. Siempre para arriba.")
const sillon1 = new Mueble(position = game.at(2,3), imagen = "sillon.png", descripcion = "Un sillón de cuero.")
const mesaRatona = new Mueble(position = game.at(3,3), imagen = "mesaRatona.png", descripcion = "Revistas viejas y un cenicero con un habano.")
const sillon2 = new Mueble(position = game.at(4,3), imagen = "sillon.png", descripcion = "Un sillón de cuero.")
const cajasArchivo2 = new Mueble(position = game.at(20,2), imagen = "cajasArchivo.png", descripcion = "Más cajas de archivo.")

const cajaFuerte = new MuebleConPista(
    position = game.at(19,9),
    imagen = "cajaFuerte.png",
    pista = llaveAutoRojo,
    textoHallazgo = "La caja fuerte quedó entreabierta. Entre los fajos de billetes había una llave de auto.",
    descripcion = "Fajos de billetes y un lingote de oro. Nada más."
)

const escritorioTesorero = new Mueble(
    position = game.at(10,4),
    ancho = 2,
    alto = 2,
    imagen = "escritorioTesorero.png",
    descripcion = "Una máquina de contar billetes, una calculadora y pilas de papeles."
)

const tesorero = new Sospechoso(
    position = game.at(11,6),
    nombre = "El tesorero",
    nombreBaseImagen = "tesorero",
    imagen = "tesoreroNormal.png",
    texto = "Seguí jodiendo y te entierro en la cancha de Central Córdoba.",
    preguntas = [preguntaTesorero1, preguntaTesorero2],
    descripcion = "Toviggino, el tesorero de la AFA, mano derecha de Tapia"
)

const preguntaTesorero1 = new Pregunta(
    texto = "Que haces pibe, quién te dio permiso para que entraras",
    opciones = [opcionTesorero1, opcionTesorero2, opcionTesorero3]
)

const opcionTesorero1 = new OpcionDialogo(
    texto = "Toviggino tengo unas preguntas que hacerle, sabe algo de la muerte de su socio?",
    tono = gentil,
    respuestaNormal = "Él no era mi socio, él era mi amigo, si habremos hecho matufias juntos!!!. Lo voy a extrañar mucho",
    respuestaEnojada = "Andate de mi oficina, no te voy a responder nada sin una órden"
)

const opcionTesorero2 = new OpcionDialogo(
    texto = "Ámbos sabemos que usted es un corrupto y el que está hecho un fiambre lo mismo. Usted tenía razones para silenciarlo",
    tono = provocador,
    respuestaNormal = "No ves que estoy pasando por un duelo. Andate ya y no revises mis cosas",
    respuestaEnojada = "USTED NO PUEDE ACUSARME DE ESTO, LLÁMESE A SILENCIO O LO MANDO A SILENCIAR"
)

const opcionTesorero3 = new OpcionDialogo(
    texto = "Vengo a revisar el balance de la tesorería de este año.",
    tono = neutral,
    respuestaNormal = "El balance da perfecto como siempre, todo en regla y blindado. A llorar a la iglesia",
    respuestaEnojada = "¿Revisar números acá? Rajá de acá antes de que te arme una causa por usurpación."
)

const preguntaTesorero2 = new Pregunta(
    texto = "Pará un poco... ¿de dónde sacaste esa bolsa? ¡Eso estaba en mi baúl!",
    requisitos = [bolsa],
    opciones = [opcionTesorero4, opcionTesorero5, opcionTesorero6]
)

const opcionTesorero4 = new OpcionDialogo(
    texto = "Encontré un dineral, un arma y una denuncia penal en su auto rojo. Explíqueme esto con calma.",
    tono = gentil,
    respuestaNormal = "Esa plata es para pagar los premios del ascenso de Santiago del Estero... y el fierro es por seguridad personal",
    respuestaEnojada = "¡No tengo que explicarte un carajo a vos! Dejá esa guita donde estaba o no salís vivo de este predio."
)

const opcionTesorero5 = new OpcionDialogo(
    texto = "Bolsos con guita negra, un revólver y una causa por lavado. Te descubrí el negocio, delincuente.",
    tono = provocador,
    respuestaNormal = "¿Guita negra? Son aportes de sponsors del interior, nene. Chiqui estaba al tanto de cada centavo.",
    respuestaEnojada = "¡A MÍ NO ME APRETÁS, DETECTIVE DE CARTÓN! ¡CON ESTO ME LIMPIO EL TRASTE Y A VOS TE DESAPAREZCO!"
)

const opcionTesorero6 = new OpcionDialogo(
    texto = "Esta bolsa lo compromete directamente con desvío de fondos y amenazas.",
    tono = neutral,
    respuestaNormal = "Mirá, te aconsejo que te guardes eso. En este país el que escarba donde no debe termina mal parado.",
    respuestaEnojada = "Hacé la denuncia que quieras en Comodoro Py. Sabés bien quién maneja la justicia deportiva acá."
)