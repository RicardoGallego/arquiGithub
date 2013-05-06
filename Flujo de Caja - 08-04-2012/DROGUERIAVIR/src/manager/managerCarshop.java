package manager;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.faces.event.ActionEvent;

import persistencia.Medicament;

import modelo.CarritoCompras;

public class managerCarshop {
	private List<CarritoCompras> listCarShop;

	public managerCarshop() {
		super();
		// TODO Auto-generated constructor stub
		listCarShop = new ArrayList<CarritoCompras>();
	}
	
	public void addMedicamentos(ActionEvent event) {
		Medicament medT = new Medicament();
		medT = (Medicament) event.getComponent().getAttributes().get(
				"medT");
		boolean bandera = true;
		for (CarritoCompras medic : listCarShop) {
			if (medic.getMedic().getIdMedic() == medT.getIdMedic()) {
				medic.setCantMedic(medic.getCantMedic() + 1);
				bandera = false;
			}
		}
		if (bandera) {
			listCarShop.add(new CarritoCompras(medT, 1));
		}
	}
	
	public void removeMedicamentos(ActionEvent event) {
		Medicament medT = new Medicament();
		medT = (Medicament) event.getComponent().getAttributes().get("medT");

		if (listCarShop != null && listCarShop.size() > 0) {
			Iterator<CarritoCompras> i = listCarShop.iterator();
			while (i.hasNext()) {
				CarritoCompras med = (CarritoCompras)i.next();
			
				if (med.getMedic().getIdMedic() == medT.getIdMedic()){	
					med.setCantMedic((med.getCantMedic() - 1));
					if (med.getCantMedic() == 0)
						i.remove();
				}
            }
	    }
		
	}
    //Getter and Setter 
	public List<CarritoCompras> getLisCestaCompras() {
		return listCarShop;
	}

	public void setLisCestaCompras(List<CarritoCompras> lisCestaCompras) {
		this.listCarShop = lisCestaCompras;
	}
}
