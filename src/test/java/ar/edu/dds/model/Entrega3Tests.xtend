package ar.edu.dds.model

import ar.edu.dds.exception.JugadorYaCalificadoParaEsePartidoException
import ar.edu.dds.model.inscripcion.Estandar
import ar.edu.dds.repository.inmemory.JugadoresHome
import org.joda.time.DateTime
import org.joda.time.LocalDate
import org.junit.Assert
import org.junit.Before
import org.junit.Test

class Entrega3Tests {

	Admin admin
	Partido partido
	
	JugadoresHome jugadoresHome

	Jugador matias
	Jugador jorge
	Jugador carlos
	Jugador pablo
	Jugador pedro
	Jugador franco

	@Before
	def void init() {

		this.admin = new Admin("Enrique", new LocalDate(1989, 12, 12), new Estandar, "mail@ejemplo.com", "Quique")
		this.partido = this.admin.organizarPartido(new DateTime(2014, 5, 25, 21, 0), "Avellaneda")
		
		JugadoresHome.reset
		jugadoresHome = JugadoresHome.instance

		matias = new Jugador("Matias", new LocalDate(1989, 12, 12), new Estandar, "mail@ejemplo.com", "Matute")
		this.partido.agregarJugadorPartido(matias)

		jorge = new Jugador("Jorge", new LocalDate(1989, 12, 12), new Estandar, "mail@ejemplo.com", "Jorgito")
		this.partido.agregarJugadorPartido(jorge)

		carlos = new Jugador("Carlos", new LocalDate(1989, 12, 12), new Estandar, "mail@ejemplo.com", "Chino")
		this.partido.agregarJugadorPartido(carlos)

		pablo = new Jugador("Pablo", new LocalDate(1989, 12, 12), new Estandar, "mail@ejemplo.com", "Pablo")
		this.partido.agregarJugadorPartido(pablo)

		pedro = new Jugador("Pedro", new LocalDate(1989, 12, 12), new Estandar, "mail@ejemplo.com", "Pepe")
		this.partido.agregarJugadorPartido(pedro)

		franco = new Jugador("Franco", new LocalDate(1989, 12, 12), new Estandar, "mail@ejemplo.com", "Francho")
		this.partido.agregarJugadorPartido(franco)
	}

	@Test
	def void comprobarQueLosJugadoresEstanEnElPartido() {
		Assert.assertTrue(partido.estaEnElPartido(franco))
		Assert.assertTrue(partido.estaEnElPartido(matias))
		Assert.assertTrue(partido.estaEnElPartido(jorge))
	}

	/* *****************************************************************************
 	*                         Tests de las calificaciones
	********************************************************************************/
	@Test
	def void unJugadorCalificaAOtro() {

		val calificacion = new Calificacion
		calificacion.nota = 6
		calificacion.comentario = "Cabezeas muy mal, todo el resto OK"
		calificacion.autor = jorge
		calificacion.partido = partido

		jorge.calificarJugador(matias, calificacion)
//		matias.recibirCalificacion(calificacion)

		Assert.assertTrue(matias.tieneCalificacion(calificacion))

	}

	@Test(expected=JugadorYaCalificadoParaEsePartidoException)
	def void unJugadorTrataDeCalificarDosVecesAlMismoJugador() {

		val calificacion1 = new Calificacion
		calificacion1.nota = 6
		calificacion1.comentario = "Cabeceas muy mal, todo el resto OK"
		calificacion1.autor = jorge
		calificacion1.partido = partido

		jorge.calificarJugador(matias, calificacion1)

		val calificacion2 = new Calificacion
		calificacion2.nota = 4
		calificacion2.comentario = "no corres nada!"
		calificacion2.autor = jorge
		calificacion2.partido = partido

		jorge.calificarJugador(matias, calificacion2)

	}

	/********************************************************************************
 	*                             Tests de proponer Amigos
	*******************************************************************************/
	@Test
	def void unJugadorProponeAUnAmigoYElAdminNoHaceNada() {

		val rodrigo = new Jugador("Rodrigo", new LocalDate(1989, 12, 12), new Estandar, "mail@ejemplo.com", "Rodri")
		this.matias.recomendarAmigo(rodrigo, jugadoresHome)

		Assert.assertTrue(jugadoresHome.estaPendiente(rodrigo))
	}

	@Test
	def void unJugadorProponeUnAmigoYElAdminLoRechaza() {

		val rodrigo = new Jugador("Rodrigo", new LocalDate(1989, 12, 12), new Estandar, "mail@ejemplo.com", "Rodri")
		this.matias.recomendarAmigo(rodrigo, jugadoresHome)

		//el admin rechaza el amigo del jugador 
		admin.rechazarJugador(rodrigo, "No sabe jugar", jugadoresHome)

		Assert.assertTrue(jugadoresHome.estaRechazado(rodrigo))
		Assert.assertFalse(jugadoresHome.estaPendiente(rodrigo))

	}

	@Test
	def void unJugadorProponeAmigoYseAcepta() {

		val rodrigo = new Jugador("Rodrigo", new LocalDate(1989, 12, 12), new Estandar, "mail@ejemplo.com", "Rodri")
		this.matias.recomendarAmigo(rodrigo, jugadoresHome)

		//el admin acepta el amigo del jugador 
		admin.aprobarJugador(rodrigo, jugadoresHome)

		Assert.assertTrue(jugadoresHome.estaAprobado(rodrigo))
		Assert.assertFalse(jugadoresHome.estaPendiente(rodrigo))

	}

}
