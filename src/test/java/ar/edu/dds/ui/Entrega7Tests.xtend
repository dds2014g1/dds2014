package ar.edu.dds.ui

import org.junit.Before
import ar.edu.dds.ui.applicationmodel.OrganizadorPartido
import org.junit.Test
import ar.edu.dds.model.equipos.ordenador.OrdenadorPorHandicap
import ar.edu.dds.model.equipos.generador.GeneradorDeEquiposParesContraImpares
import ar.edu.dds.model.Partido
import junit.framework.Assert
import ar.edu.dds.home.JugadoresHome
import java.util.Arrays
import ar.edu.dds.model.equipos.generador.GeneradorDeEquipos14589Vs236710
import ar.edu.dds.ui.filtros.TodosLosJugadores
import ar.edu.dds.ui.filtros.SoloConInfracciones
import java.util.List
import ar.edu.dds.model.Jugador
import ar.edu.dds.ui.filtros.SoloSinInfracciones
import org.joda.time.LocalDate
import java.util.ArrayList

class Entrega7Tests {
	
	@Property Partido partido
	
	var appModel = new OrganizadorPartido
	val homeJugadores = JugadoresHome.instance
	
	var List<Jugador> jugadoresEncontrados
	
	var matias = homeJugadores.buscarPorNombre("Matias").head
	var jorge = homeJugadores.buscarPorNombre("Jorge").head
	var carlos = homeJugadores.buscarPorNombre("Carlos").head
	var pablo = homeJugadores.buscarPorNombre("Pablo").head
	var pedro = homeJugadores.buscarPorNombre("Pedro").head
	var franco = homeJugadores.buscarPorNombre("Franco").head
	var lucas = homeJugadores.buscarPorNombre("Lucas").head
	var adrian = homeJugadores.buscarPorNombre("Adrian").head
	var simon = homeJugadores.buscarPorNombre("Simon").head
	var patricio = homeJugadores.buscarPorNombre("Patricio").head
	
	
	@Before
	def void init(){
		appModel.inicializar
		partido = appModel.partido
		jugadoresEncontrados = new ArrayList
		
	}
	
	@Test
	def void testOrdenarPorHandicapYGenerarPorParesEImpares(){
		
		appModel.ordenadorSeleccionado = new OrdenadorPorHandicap
		appModel.criterioSeleccionado = new GeneradorDeEquiposParesContraImpares
		
		appModel.generarEquipos
		var equipos = partido.equipos
		var equipo1 = equipos.equipo1
		var equipo2 = equipos.equipo2
		
		var appModelEquipo1 = Arrays.asList(pablo,  lucas,  simon, jorge, patricio)
		var appModelEquipo2 = Arrays.asList(franco,  carlos,  matias, adrian, pedro)
		
		Assert.assertEquals(appModelEquipo1, equipo1)
		Assert.assertEquals(appModelEquipo2, equipo2)
		
	}
	@Test
	def void testOrdenaPorHandicapYGenerarPor14589Vs236710(){
		
		appModel.ordenadorSeleccionado = new OrdenadorPorHandicap
		appModel.criterioSeleccionado = new GeneradorDeEquipos14589Vs236710
		
		appModel.generarEquipos
		
		var equipos = partido.equipos
		var equipo1 = equipos.equipo1
		var equipo2 = equipos.equipo2
		
		var appModelEquipo1 = Arrays.asList(franco,  lucas,  matias, jorge, pedro)
		var appModelEquipo2 = Arrays.asList(pablo,  carlos,  simon, adrian, patricio)
		
		Assert.assertEquals(appModelEquipo1, equipo1)
		Assert.assertEquals(appModelEquipo2, equipo2)
	}
	
	@Test
	def void testGeneraEquiposYPuedeConfirmar(){
		
		appModel.ordenadorSeleccionado = new OrdenadorPorHandicap
		appModel.criterioSeleccionado = new GeneradorDeEquiposParesContraImpares
		
		appModel.generarEquipos
		
		Assert.assertTrue(appModel.puedeConfirmar)
	}
	
	@Test
	def void testConfirmaEquiposYNoSePuedeVolverAConfirmar(){
		appModel.ordenadorSeleccionado = new OrdenadorPorHandicap
		appModel.criterioSeleccionado = new GeneradorDeEquiposParesContraImpares
		
		appModel.generarEquipos
		appModel.confirmarEquipos
				
		Assert.assertFalse(appModel.puedeConfirmar)
	}
	
	@Test
	def void testNoSeleccionoOrdenadorYNoPuedeGenerar(){
		appModel.criterioSeleccionado = new GeneradorDeEquiposParesContraImpares
		
		Assert.assertFalse(appModel.puedeGenerar)
	}
	
	@Test
	def void testNoSeleccionoCriterioYNoPuedeGenerar(){
		appModel.ordenadorSeleccionado = new OrdenadorPorHandicap
		
		Assert.assertFalse(appModel.puedeGenerar)
	}
	
	@Test
	def void filtrarGrillaPorTodosLosJugadores(){
		
		appModel.filtroDeInfraccionesSeleccionado = new TodosLosJugadores
		appModel.buscarJugadores
		
		Assert.assertEquals(homeJugadores.todosLosJugadores ,appModel.jugadoresDeBusqueda)
		
	}
	
	@Test
	def void filtrarGrillaSoloPorJugadoresConInfracciones(){
		
		appModel.filtroDeInfraccionesSeleccionado = new SoloConInfracciones
		appModel.buscarJugadores
		
		jugadoresEncontrados = homeJugadores.todosLosJugadores
								.filter(j|!j.infracciones.nullOrEmpty).toList
		
		Assert.assertEquals(jugadoresEncontrados, appModel.jugadoresDeBusqueda)
	}
	
	@Test
	def void filtrarGrillaSoloPorJugadoresSinJugadores(){
		
		appModel.filtroDeInfraccionesSeleccionado = new SoloSinInfracciones
		appModel.buscarJugadores
		
		jugadoresEncontrados = homeJugadores.todosLosJugadores
								.filter(j|j.infracciones.nullOrEmpty).toList
		
		Assert.assertEquals(jugadoresEncontrados, appModel.jugadoresDeBusqueda)
	}
	
	
	@Test
	def void filtrarJugadoresPorNombre(){
		
		appModel.busquedaNombreJugador = "Jor"
		appModel.buscarJugadores
		
		jugadoresEncontrados = homeJugadores.buscarPorNombre("Jor")
		
		Assert.assertEquals(jugadoresEncontrados, appModel.jugadoresDeBusqueda)
	}
	
	@Test
	def void filtrarJugadoresPorApodo(){
		
		appModel.busquedaApodoJugador = "Pol"
		appModel.buscarJugadores
		
		jugadoresEncontrados = homeJugadores.buscarPorApodo("Pol")
		
		Assert.assertEquals(jugadoresEncontrados, appModel.jugadoresDeBusqueda)
	}
	
	@Test
	def void filtrarPorFechaAnterior(){
		val fecha = new LocalDate("1985-12-10")
		appModel.busquedaFechaNacimientoJugador = fecha
		appModel.buscarJugadores
		
		jugadoresEncontrados = 	homeJugadores.todosLosJugadores
								.filter [j | j.fechaDeNacimientoAnteriorA(fecha)].toList
	
		Assert.assertEquals(jugadoresEncontrados, appModel.jugadoresDeBusqueda)
	}
	
	@Test 
	def void filtrarSoloPorMinHandicap(){
		
		appModel.busquedaHandicapMinJugador = 9
		appModel.buscarJugadores
		
		jugadoresEncontrados = homeJugadores.todosLosJugadores
								.filter[j | j.estaEnRangoDeHandicap(9, null)].toList
		
		Assert.assertEquals(jugadoresEncontrados, appModel.jugadoresDeBusqueda)
	}
	
	@Test 
	def void filtrarSoloPorMaxHandicap(){
		appModel.busquedaHandicapMaxJugador = 2
		appModel.buscarJugadores
		
		jugadoresEncontrados = homeJugadores.todosLosJugadores
								.filter[j | j.estaEnRangoDeHandicap(null, 2)].toList
		
		Assert.assertEquals(jugadoresEncontrados, appModel.jugadoresDeBusqueda)
		
	}
	
	@Test
	def void filtrarPorHandicapMinYMax(){
		
		appModel.busquedaHandicapMaxJugador = 9
		appModel.busquedaHandicapMinJugador = 5
		appModel.buscarJugadores
		
		jugadoresEncontrados = homeJugadores.todosLosJugadores
								.filter [j | j.estaEnRangoDeHandicap(5,9)].toList
								
		Assert.assertEquals(jugadoresEncontrados, appModel.jugadoresDeBusqueda)
		
	}
	
	@Test 
	def void filtrarSoloPorMinPromedio(){
		appModel.busquedaPromedioMinJugador = 9
		appModel.buscarJugadores
		
		jugadoresEncontrados = homeJugadores.todosLosJugadores
								.filter[j | j.estaEnRangoDePromedio(9, null)].toList
		
		Assert.assertEquals(jugadoresEncontrados, appModel.jugadoresDeBusqueda)
	}
	
	@Test 
	def void filtrarSoloPorMaxPromedio(){
		appModel.busquedaPromedioMaxJugador = 2
		appModel.buscarJugadores
		
		jugadoresEncontrados = homeJugadores.todosLosJugadores
								.filter[j | j.estaEnRangoDePromedio(null, 2)].toList
		
		Assert.assertEquals(jugadoresEncontrados, appModel.jugadoresDeBusqueda)
		
	}
	
	@Test
	def void filtrarPorPromedioMinYMax(){
		
		appModel.busquedaPromedioMaxJugador = 9
		appModel.busquedaPromedioMinJugador = 5
		appModel.buscarJugadores
		
		jugadoresEncontrados = homeJugadores.todosLosJugadores
								.filter [j | j.estaEnRangoDePromedio(5,9)].toList
								
		Assert.assertEquals(jugadoresEncontrados, appModel.jugadoresDeBusqueda)
		
	}
	
}




