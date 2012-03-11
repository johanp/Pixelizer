package pixelizer {
	import pixelizer.PxEntity;
	
	/**
	 * This interface is used to define objects that can be used to contain entities.
	 * @author Johan Peitz
	 */
	public interface IPxEntityContainer {
		/**
		 * Removes an entity from the container.
		 * @param	pEntity	Entity to remove.
		 * @return	Removed entity.
		 */
		function removeEntity( pEntity : PxEntity ) : PxEntity;
		
		/**
		 * Adds an entity to the container.
		 * @param	pEntity	Entity to add.
		 * @param	pHandle	String identifier of this entity.
		 * @return	Added entity.
		 */
		function addEntity( pEntity : PxEntity, pHandle : String = "" ) : PxEntity;
	}

}