
#ifndef ENTITY_H_
#define ENTITY_H_


const DWORD kInvalidID = (DWORD)-1;

class Entity {
public:
	Entity() : id_(kInvalidID), index_(kInvalidID), tag_(0), angle_(0) {}
	virtual ~Entity() {}

	DWORD id() const { return id_; }
	void set_id(DWORD id) { id_ = id; }

	DWORD index() const { return index_; }
	void set_index(DWORD index) { index_ = index; }

	int tag() const { return tag_; }
	void set_tag(int tag) { tag_ = tag; }

	float angle() const { return angle_; }
	void set_angle(float angle) { angle_ = angle; }

	void SetCreateTicket(DWORD dwTicket){ dwCreateTicket = dwTicket; }
	DWORD GetCreateTicket(){ return dwCreateTicket; }

private:
	DWORD id_;
	DWORD index_;
	int tag_;
	float angle_;
	DWORD dwCreateTicket;
};

#endif  // ACTION_H_
