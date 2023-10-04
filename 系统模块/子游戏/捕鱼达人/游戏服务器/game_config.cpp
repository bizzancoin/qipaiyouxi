
#include "stdafx.h"
#include "game_config.h"

#include "pugixml/pugixml.hpp"

GameConfig::GameConfig()
{
	min_bullet_multiple_ = 1;
	max_bullet_multiple_ = 10;
	nSceneUpdateTimes = 360;
}

GameConfig::~GameConfig() {
}

bool GameConfig::LoadGameConfig(WORD server_id) 
{
	char module_name[MAX_PATH];
	GetModuleFileNameA(NULL, module_name, MAX_PATH);
	std::string work_dir = module_name;
	std::string::size_type last_backslash = work_dir.rfind('\\', work_dir.size());
	if (last_backslash != std::string::npos)
		work_dir.erase(last_backslash + 1);

	std::string xml_path = work_dir;
	_snprintf(module_name, MAX_PATH, "GameModule\\xjcby_server_%d", server_id);
	xml_path += module_name;
	xml_path += ".xml";

	pugi::xml_document doc;
	if (!doc.load_file(xml_path.c_str())) {
		CTraceService::TraceString(_T("≈‰÷√◊ ‘¥Ω‚Œˆ ß∞‹£¨«ÎºÏ≤È"), TraceLevel_Exception);
		return false;
	}

	pugi::xml_node game_config = doc.child("GameConfig");

	pugi::xml_node cannon_mulriple = game_config.child("CannonMulriple");
	min_bullet_multiple_ = cannon_mulriple.attribute("min_multiple").as_int(1);
	max_bullet_multiple_ = cannon_mulriple.attribute("max_multiple").as_int(10);

	pugi::xml_node ExChangeScene = game_config.child("ExchangeScene");
	nSceneUpdateTimes = ExChangeScene.attribute("SceneUpdateTime").as_int(360);

	pugi::xml_node AndroidInfo = game_config.child("AndroidInfo");
	nMaxAndroidCount = AndroidInfo.attribute("MaxAndroidCount").as_int(1);

	pugi::xml_node fish_config = game_config.child("FishConfig");
	for (pugi::xml_node node = fish_config.first_child(); node; node = node.next_sibling()) 
	{
		int fish_kind = node.attribute("kind").as_int();
		fish_config_[fish_kind].mulriple = node.attribute("mulriple").as_int();
		fish_config_[fish_kind].speed = node.attribute("speed").as_float();

		const char* pro = node.attribute("capture_probability").as_string();
		char* temp = NULL;
		fish_config_[fish_kind].capture_probability = strtod(pro, &temp);


		fish_config_[fish_kind].distribute_interval = node.attribute("distribute_interval").as_float();
		fish_config_[fish_kind].distribute_count = node.attribute("distribute_count").as_int();
		fish_config_[fish_kind].nMaxAliveCount = node.attribute("maxalive_count").as_int();
	}

	return true;
}
