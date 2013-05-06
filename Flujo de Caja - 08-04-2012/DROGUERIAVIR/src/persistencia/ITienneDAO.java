package persistencia;

import java.util.List;

/**
 * Interface for TienneDAO.
 * 
 * @author MyEclipse Persistence Tools
 */

public interface ITienneDAO {
	/**
	 * Perform an initial save of a previously unsaved Tienne entity. All
	 * subsequent persist actions of this entity should use the #update()
	 * method. This operation must be performed within the a database
	 * transaction context for the entity's data to be permanently saved to the
	 * persistence store, i.e., database. This method uses the
	 * {@link javax.persistence.EntityManager#persist(Object)
	 * EntityManager#persist} operation.
	 * 
	 * <pre>
	 * EntityManagerHelper.beginTransaction();
	 * ITienneDAO.save(entity);
	 * EntityManagerHelper.commit();
	 * </pre>
	 * 
	 * @param entity
	 *            Tienne entity to persist
	 * @throws RuntimeException
	 *             when the operation fails
	 */
	public void save(Tienne entity);

	/**
	 * Delete a persistent Tienne entity. This operation must be performed
	 * within the a database transaction context for the entity's data to be
	 * permanently deleted from the persistence store, i.e., database. This
	 * method uses the {@link javax.persistence.EntityManager#remove(Object)
	 * EntityManager#delete} operation.
	 * 
	 * <pre>
	 * EntityManagerHelper.beginTransaction();
	 * ITienneDAO.delete(entity);
	 * EntityManagerHelper.commit();
	 * entity = null;
	 * </pre>
	 * 
	 * @param entity
	 *            Tienne entity to delete
	 * @throws RuntimeException
	 *             when the operation fails
	 */
	public void delete(Tienne entity);

	/**
	 * Persist a previously saved Tienne entity and return it or a copy of it to
	 * the sender. A copy of the Tienne entity parameter is returned when the
	 * JPA persistence mechanism has not previously been tracking the updated
	 * entity. This operation must be performed within the a database
	 * transaction context for the entity's data to be permanently saved to the
	 * persistence store, i.e., database. This method uses the
	 * {@link javax.persistence.EntityManager#merge(Object) EntityManager#merge}
	 * operation.
	 * 
	 * <pre>
	 * EntityManagerHelper.beginTransaction();
	 * entity = ITienneDAO.update(entity);
	 * EntityManagerHelper.commit();
	 * </pre>
	 * 
	 * @param entity
	 *            Tienne entity to update
	 * @return Tienne the persisted Tienne entity instance, may not be the same
	 * @throws RuntimeException
	 *             if the operation fails
	 */
	public Tienne update(Tienne entity);

	public Tienne findById(Long id);

	/**
	 * Find all Tienne entities with a specific property value.
	 * 
	 * @param propertyName
	 *            the name of the Tienne property to query
	 * @param value
	 *            the property value to match
	 * @param rowStartIdxAndCount
	 *            Optional int varargs. rowStartIdxAndCount[0] specifies the the
	 *            row index in the query result-set to begin collecting the
	 *            results. rowStartIdxAndCount[1] specifies the the maximum
	 *            count of results to return.
	 * @return List<Tienne> found by query
	 */
	public List<Tienne> findByProperty(String propertyName, Object value,
			int... rowStartIdxAndCount);

	public List<Tienne> findByIdMedic(Object idMedic,
			int... rowStartIdxAndCount);

	public List<Tienne> findByIdGestmedic(Object idGestmedic,
			int... rowStartIdxAndCount);

	/**
	 * Find all Tienne entities.
	 * 
	 * @param rowStartIdxAndCount
	 *            Optional int varargs. rowStartIdxAndCount[0] specifies the the
	 *            row index in the query result-set to begin collecting the
	 *            results. rowStartIdxAndCount[1] specifies the the maximum
	 *            count of results to return.
	 * @return List<Tienne> all Tienne entities
	 */
	public List<Tienne> findAll(int... rowStartIdxAndCount);
}