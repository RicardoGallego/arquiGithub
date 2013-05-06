package persistencia;

import java.util.List;

/**
 * Interface for MedicamentDAO.
 * 
 * @author MyEclipse Persistence Tools
 */

public interface IMedicamentDAO {
	/**
	 * Perform an initial save of a previously unsaved Medicament entity. All
	 * subsequent persist actions of this entity should use the #update()
	 * method. This operation must be performed within the a database
	 * transaction context for the entity's data to be permanently saved to the
	 * persistence store, i.e., database. This method uses the
	 * {@link javax.persistence.EntityManager#persist(Object)
	 * EntityManager#persist} operation.
	 * 
	 * <pre>
	 * EntityManagerHelper.beginTransaction();
	 * IMedicamentDAO.save(entity);
	 * EntityManagerHelper.commit();
	 * </pre>
	 * 
	 * @param entity
	 *            Medicament entity to persist
	 * @throws RuntimeException
	 *             when the operation fails
	 */
	public void save(Medicament entity);

	/**
	 * Delete a persistent Medicament entity. This operation must be performed
	 * within the a database transaction context for the entity's data to be
	 * permanently deleted from the persistence store, i.e., database. This
	 * method uses the {@link javax.persistence.EntityManager#remove(Object)
	 * EntityManager#delete} operation.
	 * 
	 * <pre>
	 * EntityManagerHelper.beginTransaction();
	 * IMedicamentDAO.delete(entity);
	 * EntityManagerHelper.commit();
	 * entity = null;
	 * </pre>
	 * 
	 * @param entity
	 *            Medicament entity to delete
	 * @throws RuntimeException
	 *             when the operation fails
	 */
	public void delete(Medicament entity);

	/**
	 * Persist a previously saved Medicament entity and return it or a copy of
	 * it to the sender. A copy of the Medicament entity parameter is returned
	 * when the JPA persistence mechanism has not previously been tracking the
	 * updated entity. This operation must be performed within the a database
	 * transaction context for the entity's data to be permanently saved to the
	 * persistence store, i.e., database. This method uses the
	 * {@link javax.persistence.EntityManager#merge(Object) EntityManager#merge}
	 * operation.
	 * 
	 * <pre>
	 * EntityManagerHelper.beginTransaction();
	 * entity = IMedicamentDAO.update(entity);
	 * EntityManagerHelper.commit();
	 * </pre>
	 * 
	 * @param entity
	 *            Medicament entity to update
	 * @return Medicament the persisted Medicament entity instance, may not be
	 *         the same
	 * @throws RuntimeException
	 *             if the operation fails
	 */
	public Medicament update(Medicament entity);

	public Medicament findById(Long id);

	/**
	 * Find all Medicament entities with a specific property value.
	 * 
	 * @param propertyName
	 *            the name of the Medicament property to query
	 * @param value
	 *            the property value to match
	 * @param rowStartIdxAndCount
	 *            Optional int varargs. rowStartIdxAndCount[0] specifies the the
	 *            row index in the query result-set to begin collecting the
	 *            results. rowStartIdxAndCount[1] specifies the the maximum
	 *            count of results to return.
	 * @return List<Medicament> found by query
	 */
	public List<Medicament> findByProperty(String propertyName, Object value,
			int... rowStartIdxAndCount);

	public List<Medicament> findByNomMedic(Object nomMedic,
			int... rowStartIdxAndCount);

	public List<Medicament> findByPrecioMedic(Object precioMedic,
			int... rowStartIdxAndCount);

	public List<Medicament> findByTipoMedic(Object tipoMedic,
			int... rowStartIdxAndCount);

	/**
	 * Find all Medicament entities.
	 * 
	 * @param rowStartIdxAndCount
	 *            Optional int varargs. rowStartIdxAndCount[0] specifies the the
	 *            row index in the query result-set to begin collecting the
	 *            results. rowStartIdxAndCount[1] specifies the the maximum
	 *            count of results to return.
	 * @return List<Medicament> all Medicament entities
	 */
	public List<Medicament> findAll(int... rowStartIdxAndCount);
}