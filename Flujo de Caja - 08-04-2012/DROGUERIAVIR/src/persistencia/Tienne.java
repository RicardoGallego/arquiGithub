package persistencia;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Tienne entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "TIENNE", schema = "CLASSICCARS")
public class Tienne implements java.io.Serializable {

	// Fields

	private Long idTienne;
	private Long idMedic;
	private Long idGestmedic;

	// Constructors

	/** default constructor */
	public Tienne() {
	}

	/** minimal constructor */
	public Tienne(Long idTienne) {
		this.idTienne = idTienne;
	}

	/** full constructor */
	public Tienne(Long idTienne, Long idMedic, Long idGestmedic) {
		this.idTienne = idTienne;
		this.idMedic = idMedic;
		this.idGestmedic = idGestmedic;
	}

	// Property accessors
	@Id
	@Column(name = "ID_TIENNE", unique = true, nullable = false)
	public Long getIdTienne() {
		return this.idTienne;
	}

	public void setIdTienne(Long idTienne) {
		this.idTienne = idTienne;
	}

	@Column(name = "ID_MEDIC")
	public Long getIdMedic() {
		return this.idMedic;
	}

	public void setIdMedic(Long idMedic) {
		this.idMedic = idMedic;
	}

	@Column(name = "ID_GESTMEDIC")
	public Long getIdGestmedic() {
		return this.idGestmedic;
	}

	public void setIdGestmedic(Long idGestmedic) {
		this.idGestmedic = idGestmedic;
	}

}