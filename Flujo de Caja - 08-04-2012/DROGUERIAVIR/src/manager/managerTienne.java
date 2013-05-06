package manager;

import java.util.List;

import javax.faces.event.ActionEvent;
import javax.faces.event.ValueChangeEvent;
import persistencia.EntityManagerHelper;

import persistencia.TienneDAO;
import persistencia.Tienne;
public class managerTienne {

	private Tienne tiene;
	private TienneDAO tieneDAO;
	private List<Tienne> listTiene;
	private boolean renderEdit;
	private boolean renderDelete;
	private int paginacion;
	
		
	 
	/* Contructor y Funcion inicial*/
	
	public void init(){
		tiene = new Tienne();
		tieneDAO = new TienneDAO();
		listTiene = tieneDAO.findAll(0);
	}
	
	public managerTienne() {
		super();
		init();
		renderEdit = false;
		renderDelete = false;
		paginacion = 10;
	}

	/* Metodos GET y SET*/ 


	public Tienne getTiene() {
		return tiene;
	}

	public void setTiene(Tienne tiene) {
		this.tiene = tiene;
	}
	
	public TienneDAO getTieneDAO() {
		return tieneDAO;
	}

	public void setTieneDAO(TienneDAO tieneDAO) {
		this.tieneDAO = tieneDAO;
	}

	public List<Tienne> getListTiene() {
		return listTiene;
	}

	public void setListTiene(List<Tienne> listTiene) {
		this.listTiene = listTiene;
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

	
	/* Efectos de  interfaz
	

	/**
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
	
	
	
	 // Metodos de Gestión de Datos

	
	public String guardar() 
	{
		tieneDAO = new TienneDAO();
		EntityManagerHelper.beginTransaction();
		if (tiene.getIdTienne() != null && tiene.getIdMedic() != null)
			tieneDAO.save(tiene);
		else
			tieneDAO.update(tiene);
		EntityManagerHelper.commit();
		EntityManagerHelper.closeEntityManager();
		
		init();
				
		return null;
	}
	
	public void Update(ActionEvent event) {
        Tienne tieneT = new Tienne();
        tieneT = (Tienne) event.getComponent().getAttributes().get("tieneT");
        if (tieneT != null) {
       	tieneDAO = new TienneDAO();
    		EntityManagerHelper.beginTransaction();
    			tieneDAO.update(tieneT);
    		EntityManagerHelper.commit();
    		EntityManagerHelper.closeEntityManager();
    		init();
        }
   }
	
	public void Delete(ActionEvent event) {
        Tienne tieneT = new Tienne();
        tieneT = (Tienne) event.getComponent().getAttributes().get("tieneT");
        if (tieneT != null) {
       	tieneDAO = new TienneDAO();
    		EntityManagerHelper.beginTransaction();
    			tieneDAO.delete(tieneT);
    		EntityManagerHelper.commit();
    		EntityManagerHelper.closeEntityManager();
    		init();
        }
   }
	
}
