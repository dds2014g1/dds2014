package ar.edu.dds.model

import java.util.ArrayList
import org.joda.time.DateTime
import ar.edu.dds.exception.EstadoDePartidoInvalidoException
import java.util.List
import ar.edu.dds.exception.NoHaySuficientesJugadoresException

class Partido {
	
	/**
	 * Lista de jugadores inscriptos con sus respectivas prioridades por orden
	 */
	private List<Pair<Jugador, Integer>> jugadoresConSusPrioridadesSegunOrden
	
	@Property 
	private DateTime fechaYHora
	
	@Property
	private String lugar
	
	@Property
	private EstadoDePartido estadoDePartido
	
	private Integer prioridadAAsignarPorOrden
	
	new(DateTime fechaYHora, String lugar) {
		this.fechaYHora = fechaYHora
		this.lugar = lugar
		this.jugadoresConSusPrioridadesSegunOrden = new ArrayList
		this.estadoDePartido = EstadoDePartido.ABIERTA_LA_INSCRIPCION
		this.prioridadAAsignarPorOrden = 200
	}
	
	def confirmar() {
		if (EstadoDePartido.ABIERTA_LA_INSCRIPCION.equals(this.estadoDePartido)) {
			this.removerALosQueNoJugarian
		
			// Me quedo con los 10 Jugadores con más prioridad
			this.jugadoresConSusPrioridadesSegunOrden = this.jugadoresConSusPrioridadesSegunOrden.sortBy[ j | j.key.prioridad(j.value) ].take(10).toList
			
			val int size = this.jugadoresInscriptos.size
			if (size.equals(10)) {
	 			this.estadoDePartido = EstadoDePartido.CONFIRMADO
			} else {
				throw new NoHaySuficientesJugadoresException("Solamente confirmaron " + size + "jugadores...")
			}		
		} else {
			throw new EstadoDePartidoInvalidoException("Imposible confirmar partido con estado: " + this.estadoDePartido)
		}
	
		// Retorna la lista con los 10 jugadores confirmados
		jugadoresInscriptos
	}
	
	def List<Jugador> jugadoresInscriptos() {
		this.jugadoresConSusPrioridadesSegunOrden.map[ par | par.key ]
	}
	
	def void agregarJugador(Jugador jugador) {
		if (EstadoDePartido.ABIERTA_LA_INSCRIPCION.equals(this.estadoDePartido)) {
			jugadoresConSusPrioridadesSegunOrden.add(new Pair(jugador, this.prioridadAAsignarPorOrden))
			prioridadAAsignarPorOrden = prioridadAAsignarPorOrden - 10
		} else {
			throw new EstadoDePartidoInvalidoException("Imposible agregar jugadores a un partido con estado: " + this.estadoDePartido)
		}
	}
	
	private def void removerALosQueNoJugarian() {
		jugadoresConSusPrioridadesSegunOrden = jugadoresConSusPrioridadesSegunOrden.filter[ j | j.key.leSirveElPartido(this) ].toList
	}
	
	
}