package persistencia;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Medicament entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "MEDICAMENT", schema = "CLASSICCARS")
public class Medicament implements java.io.Serializable {

	// Fields

	private Long idMedic;
	private String nomMedic;
	private Double precioMedic;
	private String tipoMedic;

	// Constructors

	/** default constructor */
	public Medicament() {
	}

	/** minimal constructor */
	public Medicament(Long idMedic) {
		this.idMedic = idMedic;
	}

	/** full constructor */
	public Medicament(Long idMedic, String nomMedic, Double precioMedic,
			String tipoMedic) {
		this.idMedic = idMedic;
		this.nomMedic = nomMedic;
		this.precioMedic = precioMedic;
		this.tipoMedic = tipoMedic;
	}

	// Property accessors
	@Id
	@Column(name = "ID_MEDIC", unique = true, nullable = false)
	public Long getIdMedic() {
		return this.idMedic;
	}

	public void setIdMedic(Long idMedic) {
		this.idMedic = idMedic;
	}

	@Column(name = "NOM_MEDIC", length = 30)
	public String getNomMedic() {
		return this.nomMedic;
	}

	public void setNomMedic(String nomMedic) {
		this.nomMedic = nomMedic;
	}

	@Column(name = "PRECIO_MEDIC", precision = 52, scale = 0)
	public Double getPrecioMedic() {
		return this.precioMedic;
	}

	public void setPrecioMedic(Double precioMedic) {
		this.precioMedic = precioMedic;
	}

	@Column(name = "TIPO_MEDIC", length = 20)
	public String getTipoMedic() {
		return this.tipoMedic;
	}

	public void setTipoMedic(String tipoMedic) {
		this.tipoMedic = tipoMedic;
	}

}