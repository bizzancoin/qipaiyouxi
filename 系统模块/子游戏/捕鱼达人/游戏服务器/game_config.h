
#ifndef GAME_CONFIG_H_
#define GAME_CONFIG_H_

#include <string>
#include <vector>

class GameConfig {
public:
	GameConfig();
	~GameConfig();

	bool LoadGameConfig(WORD server_id);

public:
	int min_bullet_multiple_;
	int max_bullet_multiple_;

	int nSceneUpdateTimes;

	int nMaxAndroidCount;

	struct FishConfig 
	{
		int mulriple;
		float speed;
		double capture_probability;
		float distribute_interval;
		int distribute_count;
		int nMaxAliveCount;
	};
	FishConfig fish_config_[FISH_KIND_COUNT];



};

#endif  // GAME_CONFIG_H_
