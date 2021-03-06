package ar.edu.dds.model

import ar.edu.dds.model.equipos.generador.GeneradorDeEquipos
import ar.edu.dds.model.equipos.ordenador.OrdenadorDeJugadores
import ar.edu.dds.model.equipos.ParDeEquipos
import ar.edu.dds.exception.NoHaySuficientesJugadoresException
import org.uqbar.commons.utils.Observable
import javax.persistence.Entity
import javax.persistence.ManyToOne
import javax.persistence.CascadeType
import javax.persistence.Id
import javax.persistence.GeneratedValue

@Observable
@Entity
class ArmadorEquipos {
	
	@Id
	@GeneratedValue
	@Property long Id
	
	@ManyToOne(cascade = CascadeType.ALL)
	@Property GeneradorDeEquipos generador
	
	@ManyToOne(cascade = CascadeType.ALL)
	@Property OrdenadorDeJugadores ordenador
	
	@ManyToOne(cascade = CascadeType.ALL)
	@Property ParDeEquipos equipos
	
	new(){}
	
	def void armarTentativos(Partido partido){
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
	
	def void confirmarEquipos(Partido partido){
		partido.validarEstadoDePartido(
					EstadoDePartido.ABIERTA_LA_INSCRIPCION, 
					"Imposible confirmar partido con estado: ")
					
		this.armarTentativos(partido)
		partido.equipos = this.equipos
		partido.cerrarInscripcion
		
	}
}