package ar.edu.dds.model

import ar.edu.dds.model.equipos.generador.GeneradorDeEquiposParesContraImpares
import ar.edu.dds.model.equipos.ordenador.OrdenadorPorHandicap
import ar.edu.dds.model.inscripcion.Estandar
import org.joda.time.DateTime
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import ar.edu.dds.model.equipos.ordenador.OrdenadorPorPromedioDeCalificacionesDelUltimoPartido

class Entrega4Tests {
	
	Admin admin
	Partido partido
	
	Jugador matias
	Jugador jorge
	Jugador carlos
	Jugador pablo
	Jugador pedro
	Jugador franco
	Jugador lucas
	Jugador adrian
	Jugador simon
	Jugador patricio
	
	
	@Before
	def void init() {
		
		this.admin = new Admin("Enrique", 25, new Estandar, "mail@ejemplo.com")
		this.partido = this.admin.organizarPartido(new DateTime(2014, 5, 25, 21, 0), "Avellaneda")	
		
		matias = new Jugador("Matias", 30, new Estandar, "mail@ejemplo.com")
		this.partido.agregarJugadorPartido(matias)

		jorge = new Jugador("Jorge", 30, new Estandar, "mail@ejemplo.com")
		this.partido.agregarJugadorPartido(jorge)

		carlos = new Jugador("Carlos", 30, new Estandar, "mail@ejemplo.com")
		this.partido.agregarJugadorPartido(carlos)

		pablo = new Jugador("Pablo", 30, new Estandar, "mail@ejemplo.com")
		this.partido.agregarJugadorPartido(pablo)

		pedro = new Jugador("Pedro", 30, new Estandar, "mail@ejemplo.com")
		this.partido.agregarJugadorPartido(pedro)

		franco = new Jugador("Franco", 30, new Estandar, "mail@ejemplo.com")
		this.partido.agregarJugadorPartido(franco)
		
		lucas = new Jugador("lucas", 30, new Estandar, "mail@ejemplo.com")
		this.partido.agregarJugadorPartido(lucas)
		
		adrian = new Jugador("adrian", 30, new Estandar, "mail@ejemplo.com")
		this.partido.agregarJugadorPartido(adrian)
		
		simon = new Jugador("simon", 30, new Estandar, "mail@ejemplo.com")
		this.partido.agregarJugadorPartido(simon)
		
		patricio = new Jugador("patricio", 30, new Estandar, "mail@ejemplo.com")
		this.partido.agregarJugadorPartido(patricio)
		
	
	}
	
	/* *****************************************************************************
 	*                                     Tests
	********************************************************************************/

	@Test
	def void testOrdenarPorHandicapYGenerarEquipoPorParesEImpares(){
		
		val ordenadosPorHandicap = new OrdenadorPorHandicap
		val generadosEquiposPorParesEImpares = new GeneradorDeEquiposParesContraImpares
		
		matias.handicap = 5
		jorge.handicap = 8
		carlos.handicap = 3
		pablo.handicap = 2
		pedro.handicap = 9
	 	franco.handicap = 1
	 	lucas.handicap = 4
	 	adrian.handicap = 7
	 	simon.handicap = 6
	 	patricio.handicap = 10
	 	
		this.partido.jugadores = ordenadosPorHandicap.ordenar(this.partido.jugadores)
		
		Assert.assertEquals(1, this.partido.jugadores.get(0).handicap)
		Assert.assertEquals(10, this.partido.jugadores.get(9).handicap)
		
		this.partido.equipos = generadosEquiposPorParesEImpares.generar(this.partido.jugadores)
		
		Assert.assertEquals(5, this.partido.equipos.equipo1.size)
		
	
	}
	
	@Test
	def void testOrdenarPorPromedioDeCalificacionesDelUltimoPartido(){
		
		val ordenadosDeCalificUltPart = new OrdenadorPorPromedioDeCalificacionesDelUltimoPartido
		
		val calificacion = new Calificacion
		calificacion.nota = 6
		calificacion.partido = partido
		
		val calificacion1 = new Calificacion
		calificacion1.nota = 4
		calificacion.partido = partido
	
		val calificacion2 = new Calificacion
		calificacion2.nota = 8
		calificacion.partido = partido
		
		val calificacion3 = new Calificacion
		calificacion3.nota = 2
		calificacion.partido = partido
	
		val calificacion4 = new Calificacion
		calificacion4.nota = 1
		calificacion.partido = partido
		
		
		matias.recibirCalificacion(calificacion)
		matias.recibirCalificacion(calificacion1)
		
		jorge.recibirCalificacion(calificacion4)
		jorge.recibirCalificacion(calificacion2)
		
	}
	
	
	
}