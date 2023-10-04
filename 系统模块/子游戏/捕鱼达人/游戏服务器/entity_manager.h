
#ifndef ENTITY_MANAGER_
#define ENTITY_MANAGER_

template<class Entity>
class EntityManager 
{
public:
	EntityManager() 
	{
		ids_ = NULL;
		entitys_ = NULL;
		count_ = 0;
		position_ = 0;
		max_count_ = 0;
	}
	~EntityManager() 
	{
		Cleanup(); 
	}

	bool Initialize(DWORD max_count) 
	{
		ids_ = new DWORD[max_count];
		memset(ids_, -1, max_count * sizeof(DWORD));

		entitys_ = new Entity[max_count];
		for (DWORD i = 0; i < max_count; ++i) 
		{
			entitys_[i].set_id(i);
		}

		count_ = 0;
		position_ = 0;
		max_count_ = max_count;

		return true;
	}
	void Cleanup() 
	{
		if (ids_) 
		{
			delete []ids_;
			ids_ = NULL;
		}
		if (entitys_) 
		{
			delete []entitys_;
			entitys_ = NULL;
		}
		count_ = 0;
		position_ = 0;
		max_count_ = 0;
	}

	Entity* NewEntity(DWORD dwIndex = kInvalidID)
	{
		if (dwIndex != kInvalidID && dwIndex < max_count_)
		{
			ids_[dwIndex] = dwIndex;
			entitys_[dwIndex].set_index(dwIndex);
			++count_;
			return &(entitys_[dwIndex]);
		}

		DWORD ret = 0;
		for (DWORD i = 0; i < max_count_; ++i) 
		{
			if (entitys_[position_].index() == kInvalidID) 
			{
				ret = position_;
				if ((++position_) >= max_count_)
					position_ = 0;
				ids_[ret] = ret;
				entitys_[ret].set_index(ret);
				++count_;
				return &(entitys_[ret]);
			}

			if ((++position_) >= max_count_)
				position_ = 0;
		}

		return NULL;
	}
	void DeleteEntity(DWORD id) 
	{
		if (id == kInvalidID || id >= max_count_) 
		{
			return;
		}

		Entity* entity = GetEntityByID(id);
		DWORD index = entity->index();
		ids_[index] = kInvalidID;
		entity->set_index(kInvalidID);
		if (count_ > 0)
			--count_;
	}
	void DeleteAll() 
	{
		memset(ids_, -1, max_count_ * sizeof(DWORD));

		for (DWORD i = 0; i < max_count_; ++i) 
		{
			entitys_[i].set_index(kInvalidID);
		}

		count_ = 0;
		position_ = 0;
	}
	Entity* GetEntityByID(DWORD id) 
	{
		if (id == kInvalidID || id >= max_count_) 
		{
			return NULL;
		}
		return &(entitys_[id]);
	}
	Entity* GetEntityByIndex(DWORD index) 
	{
		if (index == kInvalidID || index >= max_count_)
		{
			return NULL;
		}
		return GetEntityByID(ids_[index]);
	}
	DWORD count() const { return count_; }

private:
	DWORD* ids_;
	Entity* entitys_;
	DWORD count_;
	DWORD position_;
	DWORD max_count_;
};

#endif  // ENTITY_MANAGER_
