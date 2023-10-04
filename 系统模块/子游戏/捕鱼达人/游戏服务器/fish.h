
#ifndef FISH_H_
#define FISH_H_

#include "entity.h"

class Fish : public Entity {
public:
	Fish() : fish_kind_(FISH_DAYANYU), fish_mulriple_(0), path_id_(0) {}
	virtual ~Fish() {}

	FishKind fish_kind() const { return fish_kind_; }
	void set_fish_kind(FishKind fish_kind) { fish_kind_ = fish_kind; }
	int fish_mulriple() const { return fish_mulriple_; }
	void set_fish_mulriple(int fish_mulriple) { fish_mulriple_ = fish_mulriple; }
	int path_id() const { return path_id_; }
	void set_path_id(int id) { path_id_ = id; }
	void SetSteps(WORD wStep) { m_wStep = wStep; }
	WORD GetSteps() { return m_wStep; }

private:
	FishKind fish_kind_;
	int fish_mulriple_;
	int path_id_;
	WORD	m_wStep;
};

#endif  // FISH_H_
