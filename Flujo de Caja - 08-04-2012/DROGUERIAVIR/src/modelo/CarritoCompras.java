package modelo;

import persistencia.Medicament;

public class CarritoCompras {
   Medicament medic;
   int cantMedic;
   int totCar;
   public CarritoCompras(Medicament medT, int i){
	   medic = medT;
	   cantMedic = i;
   }
   //getters and setters
	public Medicament getMedic() {
		return medic;
	}
	public void setMedic(Medicament medic) {
		this.medic = medic;
	}
	public int getCantMedic() {
		return cantMedic;
	}
	public void setCantMedic(int cantMedic) {
		this.cantMedic = cantMedic;
	}
	public int getTotCar() {
		return totCar;
	}
	public void setTotCar(int totCar) {
		this.totCar = totCar;
	}
   
}
