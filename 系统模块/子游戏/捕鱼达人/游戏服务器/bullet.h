
#ifndef BULLET_H_
#define BULLET_H_

#include "entity.h"

class Bullet : public Entity {
public:
	Bullet() : chair_id_(INVALID_CHAIR), bullet_mulriple_(0), lock_fish_id_(-1){}
	virtual ~Bullet() {}

	WORD chair_id() const { return chair_id_; }
	void set_chair_id(WORD chair_id) { chair_id_ = chair_id; }
	int bullet_mulriple() const { return bullet_mulriple_; }
	void set_bullet_mulriple(int bullet_mulriple) { bullet_mulriple_ = bullet_mulriple; }

	void set_lock_fish_id(int lock_fish_id) { lock_fish_id_ = lock_fish_id; }
	int lock_fish_id() const { return lock_fish_id_; }


private:
	WORD chair_id_;
	int bullet_mulriple_;
	int lock_fish_id_;
};

#endif  // BULLET_H_