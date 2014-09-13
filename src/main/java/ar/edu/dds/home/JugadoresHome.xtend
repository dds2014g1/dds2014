package ar.edu.dds.home

import java.util.List
import ar.edu.dds.model.Jugador
import java.util.ArrayList
import ar.edu.dds.model.Rechazo
import org.uqbar.commons.utils.Observable
import ar.edu.dds.model.inscripcion.Estandar
import ar.edu.dds.model.Calificacion
import ar.edu.dds.model.Partido
import ar.edu.dds.model.Admin
import org.joda.time.DateTime

@Observable
class JugadoresHome {

	static JugadoresHome INSTANCE

	List<Jugador> jugadoresAprobados
	List<Jugador> jugadoresPendientesDeAprobacion
	
	List<Rechazo> rechazos
	
	def List<Jugador> buscarPorNombre(String s) {
		todosLosJugadores.filter[ j | j.nombre.contains(s) ].toList
	}

	def void recomendarNuevoJugador(Jugador jugador) {
		this.jugadoresPendientesDeAprobacion.add(jugador)
	}

	def void aprobarJugador(Jugador jugador) {
		this.jugadoresPendientesDeAprobacion.remove(jugador)
		this.jugadoresAprobados.add(jugador)
	}

	def void rechazarJugador(Jugador jugador, String motivoDeRechazo) {
		this.jugadoresPendientesDeAprobacion.remove(jugador)
		this.rechazos.add(new Rechazo(jugador, motivoDeRechazo))
	}

	def boolean estaRechazado(Jugador jugador) {
		this.jugadoresRechazados().contains(jugador)
	}

	def boolean estaAprobado(Jugador jugador) {
		this.jugadoresAprobados.contains(jugador)

	}

	def boolean estaPendiente(Jugador jugador) {
		this.jugadoresPendientesDeAprobacion.contains(jugador)
	}

	// Singleton
	new() {
		this.jugadoresAprobados = new ArrayList
		this.jugadoresPendientesDeAprobacion = new ArrayList
		this.rechazos = new ArrayList
		inicializarStub
	}

	def static JugadoresHome getInstance() {
		if (INSTANCE == null) {
			INSTANCE = new JugadoresHome
		}
		INSTANCE
	}
	
	def static void reset() {
		INSTANCE = new JugadoresHome
	}

	// Getters
	def List<Jugador> jugadoresAprobados() {
		this.jugadoresAprobados
	}

	def List<Jugador> jugadoresPendientesDeAprobacion() {
		this.jugadoresPendientesDeAprobacion
	}

	def List<Jugador> jugadoresRechazados() {
		this.rechazos.map[r|r.jugador]
	}

	def List<Rechazo> rechazos() {
		this.rechazos
	}
	
		def List<Jugador> todosLosJugadores() {
		val result = new ArrayList<Jugador>
		result.addAll(jugadoresAprobados)
		result.addAll(jugadoresPendientesDeAprobacion)
		result.addAll(jugadoresRechazados)
		
		result
	}
	

	def inicializarStub() {
		
		val matias = new Jugador("Matias", 30, new Estandar, "mail@ejemplo.com")
		val jorge = new Jugador("Jorge", 30, new Estandar, "mail@ejemplo.com")
		val carlos = new Jugador("Carlos", 30, new Estandar, "mail@ejemplo.com")
		val pablo = new Jugador("Pablo", 30, new Estandar, "mail@ejemplo.com")
		val pedro = new Jugador("Pedro", 30, new Estandar, "mail@ejemplo.com")
		val franco = new Jugador("Franco", 30, new Estandar, "mail@ejemplo.com")
		val lucas = new Jugador("lucas", 30, new Estandar, "mail@ejemplo.com")
		val adrian = new Jugador("adrian", 30, new Estandar, "mail@ejemplo.com")
		val simon = new Jugador("simon", 30, new Estandar, "mail@ejemplo.com")
		val patricio = new Jugador("patricio", 30, new Estandar, "mail@ejemplo.com")

		//handicaps
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
		
		val admin = new Admin("Enrique", 25, new Estandar, "mail@ejemplo.com")
		val algunPartidoYaJugado = new Partido(DateTime.now.minusDays(20), "Parque Patricios", admin)

		//Calificaciones jugadores
		val calificacion1 = new Calificacion
		calificacion1.autor = carlos
		calificacion1.nota = 1
		calificacion1.partido = algunPartidoYaJugado

		val calificacion2 = new Calificacion
		calificacion2.autor = pedro
		calificacion2.nota = 2
		calificacion2.partido = algunPartidoYaJugado

		val calificacion3 = new Calificacion
		calificacion3.autor = patricio
		calificacion3.nota = 3
		calificacion3.partido = algunPartidoYaJugado

		val calificacion4 = new Calificacion
		calificacion4.autor = simon
		calificacion4.nota = 4
		calificacion4.partido = algunPartidoYaJugado

		val calificacion5 = new Calificacion
		calificacion5.autor = franco
		calificacion5.nota = 5
		calificacion5.partido = algunPartidoYaJugado

		val calificacion6 = new Calificacion
		calificacion6.autor = lucas
		calificacion6.nota = 6
		calificacion6.partido = algunPartidoYaJugado

		val calificacion7 = new Calificacion
		calificacion7.autor = adrian
		calificacion7.nota = 7
		calificacion7.partido = algunPartidoYaJugado

		val calificacion8 = new Calificacion
		calificacion8.autor = jorge
		calificacion8.nota = 8
		calificacion8.partido = algunPartidoYaJugado

		val calificacion9 = new Calificacion
		calificacion9.autor = pablo
		calificacion9.nota = 9
		calificacion9.partido = algunPartidoYaJugado

		val calificacion10 = new Calificacion
		calificacion10.autor = adrian
		calificacion10.nota = 10
		calificacion10.partido = algunPartidoYaJugado
		
		matias.recibirCalificacion(calificacion10)
		matias.recibirCalificacion(calificacion8)

		jorge.recibirCalificacion(calificacion7)
		jorge.recibirCalificacion(calificacion3)

		carlos.recibirCalificacion(calificacion8)
		carlos.recibirCalificacion(calificacion9)

		pablo.recibirCalificacion(calificacion6)
		pablo.recibirCalificacion(calificacion7)

		pedro.recibirCalificacion(calificacion9)
		pedro.recibirCalificacion(calificacion10)

		franco.recibirCalificacion(calificacion4)
		franco.recibirCalificacion(calificacion5)

		lucas.recibirCalificacion(calificacion1)
		lucas.recibirCalificacion(calificacion2)

		adrian.recibirCalificacion(calificacion3)
		adrian.recibirCalificacion(calificacion4)

		simon.recibirCalificacion(calificacion3)
		simon.recibirCalificacion(calificacion1)

		patricio.recibirCalificacion(calificacion5)
		patricio.recibirCalificacion(calificacion6)
		
		jugadoresAprobados.addAll(matias, 
								  jorge,
								  carlos,
					     	      pablo,
								  pedro,
								  franco,
								  lucas,
								  adrian,
								  simon,
								  patricio)
	}
}
