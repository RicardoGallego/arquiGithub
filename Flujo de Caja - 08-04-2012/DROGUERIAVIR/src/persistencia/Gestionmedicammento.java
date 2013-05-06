package persistencia;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Gestionmedicammento entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "GESTIONMEDICAMMENTO", schema = "CLASSICCARS")
public class Gestionmedicammento implements java.io.Serializable {

	// Fields

	private Long idGestmedic;
	private Long cantGestmedic;
	private Long totalGestmedic;

	// Constructors

	/** default constructor */
	public Gestionmedicammento() {
	}

	/** minimal constructor */
	public Gestionmedicammento(Long idGestmedic) {
		this.idGestmedic = idGestmedic;
	}

	/** full constructor */
	public Gestionmedicammento(Long idGestmedic, Long cantGestmedic,
			Long totalGestmedic) {
		this.idGestmedic = idGestmedic;
		this.cantGestmedic = cantGestmedic;
		this.totalGestmedic = totalGestmedic;
	}

	// Property accessors
	@Id
	@Column(name = "ID_GESTMEDIC", unique = true, nullable = false)
	public Long getIdGestmedic() {
		return this.idGestmedic;
	}

	public void setIdGestmedic(Long idGestmedic) {
		this.idGestmedic = idGestmedic;
	}

	@Column(name = "CANT_GESTMEDIC")
	public Long getCantGestmedic() {
		return this.cantGestmedic;
	}

	public void setCantGestmedic(Long cantGestmedic) {
		this.cantGestmedic = cantGestmedic;
	}

	@Column(name = "TOTAL_GESTMEDIC")
	public Long getTotalGestmedic() {
		return this.totalGestmedic;
	}

	public void setTotalGestmedic(Long totalGestmedic) {
		this.totalGestmedic = totalGestmedic;
	}

}