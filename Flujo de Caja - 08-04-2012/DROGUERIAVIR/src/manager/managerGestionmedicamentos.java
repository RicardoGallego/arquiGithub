package manager;

import java.util.List;

import javax.faces.event.ActionEvent;
import javax.faces.event.ValueChangeEvent;

import persistencia.EntityManagerHelper;
import persistencia.Gestionmedicammento;
import persistencia.GestionmedicammentoDAO;

public class managerGestionmedicamentos {
	private Gestionmedicammento gestmedic;
	private GestionmedicammentoDAO gestmedicDAO;
	private List<Gestionmedicammento> listGestmedic;
	private boolean renderEdit;
	private boolean renderDelete;
	private int paginacion;
	
	public void init(){
		gestmedic = new Gestionmedicammento();
		
		gestmedicDAO = new GestionmedicammentoDAO();
		listGestmedic = gestmedicDAO.findAll(0);
	}
	
	//constructor
	
	public managerGestionmedicamentos()
	{
		super();
		init();
		renderEdit = false;
		renderDelete = false;
		paginacion = 5;
	}
    //getters and setters
	
	public Gestionmedicammento getGestmedic() {
		return gestmedic;
	}

	public void setGestmedic(Gestionmedicammento gestmedic) {
		this.gestmedic = gestmedic;
	}

	public GestionmedicammentoDAO getGestmedicDAO() {
		return gestmedicDAO;
	}

	public void setGestmedicDAO(GestionmedicammentoDAO gestmedicDAO) {
		this.gestmedicDAO = gestmedicDAO;
	}

	public List<Gestionmedicammento> getListGestmedic() {
		return listGestmedic;
	}

	public void setListGestmedic(List<Gestionmedicammento> listGestmedic) {
		this.listGestmedic = listGestmedic;
	}

	public boolean isRenderEdit() {
		return renderEdit;
	}

	public void setRenderEdit(boolean renderEdit) {
		this.renderEdit = renderEdit;
	}

	public boolean isRenderDelete() {
		return renderDelete;
	}

	public void setRenderDelete(boolean renderDelete) {
		this.renderDelete = renderDelete;
	}

	public int getPaginacion() {
		return paginacion;
	}

	public void setPaginacion(int paginacion) {
		this.paginacion = paginacion;
	}
	
	//efectos de interfaz
	/*
	 * Cambiar estado (visibilidad) de la columna de edición en la tabla desplegada del jspx "ejemploAreas",
	 * el parámetro recibido tipo ValueChangeEdit sirve para cambiar dicho estado con el método getNewValue().  
	 */
	public void effectChangeEdit(ValueChangeEvent event) {
		renderEdit = (Boolean) event.getNewValue();
	}
	
	/**
	*Cambiar estado (visibilidad) de la columna borrar en la tabla desplegada del jspx "ejemploAreas",
	*el parámetro recibido tipo ValueChangeEdit sirve para cambiar dicho estado con el método getNewValue(). 
	*/
	public void effectChangeDelete(ValueChangeEvent event) {
		renderDelete = (Boolean) event.getNewValue();
	}
	
	/**
	*Cambiar estado (número de items que se despliegan) de la tabla desplegada en el jspx "ejemploElementos",
	*el parámetro recibido tipo ValueChangeEdit sirve para cambiar dicho estado con el método getNewValue(). 
	*/
	public void effectChangePaginator(ValueChangeEvent event) {
		paginacion = (Integer) event.getNewValue();
	}
	
	
	/***********************************************
	* 
	* Metodos de Gestión de Datos
	* 
	************************************************/
	
	public String guardar() 
	{
		gestmedicDAO = new GestionmedicammentoDAO();
		EntityManagerHelper.beginTransaction();
		if (gestmedic.getIdGestmedic() != null)
			gestmedicDAO.save(gestmedic);
		else
			gestmedicDAO.update(gestmedic);
		EntityManagerHelper.commit();
		EntityManagerHelper.closeEntityManager();
		
		init();
				
		return null;
	}
	
	public void Update(ActionEvent event) {
       Gestionmedicammento gestmedT = new Gestionmedicammento();
       gestmedT = (Gestionmedicammento) event.getComponent().getAttributes().get("facturaT");
       if (gestmedT != null) {
      	gestmedicDAO = new GestionmedicammentoDAO();
   		EntityManagerHelper.beginTransaction();
   		gestmedicDAO.update(gestmedT);
   		EntityManagerHelper.commit();
   		EntityManagerHelper.closeEntityManager();
   		init();
       }
  }
	
	public void Delete(ActionEvent event) {
       Gestionmedicammento gestmedT = new Gestionmedicammento();
       gestmedT = (Gestionmedicammento) event.getComponent().getAttributes().get("facturaT");
       if (gestmedT != null) {
    	   gestmedicDAO = new GestionmedicammentoDAO();
   		EntityManagerHelper.beginTransaction();
   		gestmedicDAO.delete(gestmedT);
   		EntityManagerHelper.commit();
   		EntityManagerHelper.closeEntityManager();
   		init();
       }
  }
	
}
