package ar.edu.dds.observer.inscripcion

import ar.edu.dds.model.Jugador
import ar.edu.dds.model.Partido
import ar.edu.dds.model.MailSender

class HayDiezJugadoresObserver implements InscripcionDeJugadorObserver{
	
	@Property MailSender mailSender
	
	new(MailSender sender){
		this.mailSender = sender
	}
	
	override jugadorInscripto (Jugador jugador, Partido partido){
				
		var admin = partido.administrador
		if (partido.cantidadDeJugadoresEnLista.equals(10)){
			mailSender.mandarMailDiezJugadores(admin)
		}
	}
	
}