package ar.edu.dds.model

import ar.edu.dds.model.equipos.generador.GeneradorDeEquipos
import ar.edu.dds.model.equipos.ordenador.OrdenadorDeJugadores
import ar.edu.dds.model.equipos.ParDeEquipos
import ar.edu.dds.exception.NoHaySuficientesJugadoresException
import org.uqbar.commons.utils.Observable

@Observable
class ArmadorEquipos {
	
	@Property GeneradorDeEquipos generador
	@Property OrdenadorDeJugadores ordenador
	@Property ParDeEquipos equipos
	@Property Partido partido
	
	new(Partido partidoDeInteres){
		partido = partidoDeInteres
	}
	
	def void armarTentativos(){
		partido.validarEstadoDePartido(
					EstadoDePartido.ABIERTA_LA_INSCRIPCION, 
					"Imposible generar equipos para partido con estado: ")
					
		var jugadores = partido.jugadoresQueJugarian
						.sortBy[modoDeInscripcion.prioridadInscripcion].take(10).toList
		
		var cantidadConfirmados = jugadores.size
		
		if (cantidadConfirmados.equals(10)) {
			val jugadoresOrdenados = ordenador.ordenar(jugadores)
			equipos = generador.generar(jugadoresOrdenados)
		} else {
			throw new NoHaySuficientesJugadoresException("Solamente confirmaron " + cantidadConfirmados + "jugadores...")
		}
	}
	
	def void confirmarEquipos(){
		partido.validarEstadoDePartido(
					EstadoDePartido.ABIERTA_LA_INSCRIPCION, 
					"Imposible confirmar partido con estado: ")
					
		this.armarTentativos
		partido.equipos = this.equipos
		partido.cerrarInscripcion
		
	}
}