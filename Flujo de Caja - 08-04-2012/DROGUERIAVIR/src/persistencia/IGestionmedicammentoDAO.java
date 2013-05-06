package persistencia;

import java.util.List;

/**
 * Interface for GestionmedicammentoDAO.
 * 
 * @author MyEclipse Persistence Tools
 */

public interface IGestionmedicammentoDAO {
	/**
	 * Perform an initial save of a previously unsaved Gestionmedicammento
	 * entity. All subsequent persist actions of this entity should use the
	 * #update() method. This operation must be performed within the a database
	 * transaction context for the entity's data to be permanently saved to the
	 * persistence store, i.e., database. This method uses the
	 * {@link javax.persistence.EntityManager#persist(Object)
	 * EntityManager#persist} operation.
	 * 
	 * <pre>
	 * EntityManagerHelper.beginTransaction();
	 * IGestionmedicammentoDAO.save(entity);
	 * EntityManagerHelper.commit();
	 * </pre>
	 * 
	 * @param entity
	 *            Gestionmedicammento entity to persist
	 * @throws RuntimeException
	 *             when the operation fails
	 */
	public void save(Gestionmedicammento entity);

	/**
	 * Delete a persistent Gestionmedicammento entity. This operation must be
	 * performed within the a database transaction context for the entity's data
	 * to be permanently deleted from the persistence store, i.e., database.
	 * This method uses the
	 * {@link javax.persistence.EntityManager#remove(Object)
	 * EntityManager#delete} operation.
	 * 
	 * <pre>
	 * EntityManagerHelper.beginTransaction();
	 * IGestionmedicammentoDAO.delete(entity);
	 * EntityManagerHelper.commit();
	 * entity = null;
	 * </pre>
	 * 
	 * @param entity
	 *            Gestionmedicammento entity to delete
	 * @throws RuntimeException
	 *             when the operation fails
	 */
	public void delete(Gestionmedicammento entity);

	/**
	 * Persist a previously saved Gestionmedicammento entity and return it or a
	 * copy of it to the sender. A copy of the Gestionmedicammento entity
	 * parameter is returned when the JPA persistence mechanism has not
	 * previously been tracking the updated entity. This operation must be
	 * performed within the a database transaction context for the entity's data
	 * to be permanently saved to the persistence store, i.e., database. This
	 * method uses the {@link javax.persistence.EntityManager#merge(Object)
	 * EntityManager#merge} operation.
	 * 
	 * <pre>
	 * EntityManagerHelper.beginTransaction();
	 * entity = IGestionmedicammentoDAO.update(entity);
	 * EntityManagerHelper.commit();
	 * </pre>
	 * 
	 * @param entity
	 *            Gestionmedicammento entity to update
	 * @return Gestionmedicammento the persisted Gestionmedicammento entity
	 *         instance, may not be the same
	 * @throws RuntimeException
	 *             if the operation fails
	 */
	public Gestionmedicammento update(Gestionmedicammento entity);

	public Gestionmedicammento findById(Long id);

	/**
	 * Find all Gestionmedicammento entities with a specific property value.
	 * 
	 * @param propertyName
	 *            the name of the Gestionmedicammento property to query
	 * @param value
	 *            the property value to match
	 * @param rowStartIdxAndCount
	 *            Optional int varargs. rowStartIdxAndCount[0] specifies the the
	 *            row index in the query result-set to begin collecting the
	 *            results. rowStartIdxAndCount[1] specifies the the maximum
	 *            count of results to return.
	 * @return List<Gestionmedicammento> found by query
	 */
	public List<Gestionmedicammento> findByProperty(String propertyName,
			Object value, int... rowStartIdxAndCount);

	public List<Gestionmedicammento> findByCantGestmedic(Object cantGestmedic,
			int... rowStartIdxAndCount);

	public List<Gestionmedicammento> findByTotalGestmedic(
			Object totalGestmedic, int... rowStartIdxAndCount);

	/**
	 * Find all Gestionmedicammento entities.
	 * 
	 * @param rowStartIdxAndCount
	 *            Optional int varargs. rowStartIdxAndCount[0] specifies the the
	 *            row index in the query result-set to begin collecting the
	 *            results. rowStartIdxAndCount[1] specifies the the maximum
	 *            count of results to return.
	 * @return List<Gestionmedicammento> all Gestionmedicammento entities
	 */
	public List<Gestionmedicammento> findAll(int... rowStartIdxAndCount);
}