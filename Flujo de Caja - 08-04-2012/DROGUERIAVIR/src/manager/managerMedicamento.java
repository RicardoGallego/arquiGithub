package manager;


import java.util.List;

import javax.faces.event.ActionEvent;
import javax.faces.event.ValueChangeEvent;


import persistencia.EntityManagerHelper;
import persistencia.Medicament;
import persistencia.MedicamentDAO;



public class managerMedicamento {

	private Medicament medicamento;
	private MedicamentDAO medicamentoDAO;
	private List<Medicament> listMedicamentos;
	
	String parametroBusqueda;
	
	
	private boolean renderEdit;
	private boolean renderDelete;
	private int paginacion;
	
	/***********************************************
	* 
	* Contructor y Funcion inicial
	* 
	************************************************/
	
	public void init(){
		medicamento = new Medicament();
		medicamentoDAO = new MedicamentDAO();
		listMedicamentos = medicamentoDAO.findAll(0);
		
	}
	
	public managerMedicamento()
	{
		super();
		init();
		renderEdit = false;
		renderDelete = false;
		paginacion = 10;
	}

	/***********************************************
	* 
	* Metodos GET y SET
	* 
	************************************************/
	public Medicament getMedicamento() {
		return medicamento;
	}

	public void setMedicamento(Medicament medicamento) {
		this.medicamento = medicamento;
	}

	public MedicamentDAO getMedicamentoDAO() {
		return medicamentoDAO;
	}

	public void setMedicamentoDAO(MedicamentDAO medicamentoDAO) {
		this.medicamentoDAO = medicamentoDAO;
	}

	public List<Medicament> getListMedicamentos() {
		return listMedicamentos;
	}

	public void setListMedicamentos(List<Medicament> listMedicamentos) {
		this.listMedicamentos = listMedicamentos;
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
	
	/***********************************************
	* 
	* Efectos de la interfaz
	* 
	************************************************/

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
	
	
	/***********************************************
	* 
	* Metodos de Gestión de Datos
	* 
	************************************************/
	public void filtar(){
		listMedicamentos = medicamentoDAO.findByNomMedic(parametroBusqueda, 0);
	}
	
	
	public String guardar() 
	{
		medicamentoDAO = new MedicamentDAO();
		EntityManagerHelper.beginTransaction();
		if (medicamento.getIdMedic() != null)
			medicamentoDAO.save(medicamento);
		else
			medicamentoDAO.update(medicamento);
		EntityManagerHelper.commit();
		EntityManagerHelper.closeEntityManager();
		
		init();
				
		return null;
	}
	
	public void Update(ActionEvent event) {
		Medicament medicamentoT = new Medicament();
        medicamentoT = (Medicament) event.getComponent().getAttributes().get("medicamentoT");
        if (medicamentoT != null) {
       	medicamentoDAO = new MedicamentDAO();
    		EntityManagerHelper.beginTransaction();
    			medicamentoDAO.update(medicamentoT);
    		EntityManagerHelper.commit();
    		EntityManagerHelper.closeEntityManager();
    		init();
        }
   }
	
	public void Delete(ActionEvent event) {
		Medicament medicamentoT = new Medicament();
        medicamentoT = (Medicament) event.getComponent().getAttributes().get("medicamentoT");
        if (medicamentoT != null) {
       	medicamentoDAO = new MedicamentDAO();
    		EntityManagerHelper.beginTransaction();
    			medicamentoDAO.delete(medicamentoT);
    		EntityManagerHelper.commit();
    		EntityManagerHelper.closeEntityManager();
    		init();
        }
   }

	public String getParametroBusqueda() {
		return parametroBusqueda;
	}

	public void setParametroBusqueda(String parametroBusqueda) {
		this.parametroBusqueda = parametroBusqueda;
	}
}
