/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include "otpch.h"

#include "game/game.h"
#include "lua/creature/events.h"

#include "utils/pugicast.h"

#include "lua/creature/movement.h"
#include "creatures/players/imbuements/imbuements.h"

void MoveEvents::clear() {
	uniqueIdMap.clear();
	actionIdMap.clear();
	itemIdMap.clear();
	positionsMap.clear();
}

bool MoveEvents::registerLuaFunction(MoveEvent& moveEvent) {
	auto itemIdVector = moveEvent.getItemIdsVector();
	if (itemIdVector.empty()) {
		return false;
	}

	std::for_each(itemIdVector.begin(), itemIdVector.end(), [this, &moveEvent](uint32_t &itemId) {
		registerEvent(moveEvent, itemId, itemIdMap);
		if (moveEvent.getEventType() == MOVE_EVENT_EQUIP) {
			ItemType& it = Item::items.getItemType(itemId);
			it.wieldInfo = moveEvent.getWieldInfo();
			it.minReqLevel = moveEvent.getReqLevel();
			it.minReqMagicLevel = moveEvent.getReqMagLv();
			it.vocationString = moveEvent.getVocationString();
		}
		return true;
	});
	itemIdVector.clear();
	itemIdVector.shrink_to_fit();
	return true;
}

bool MoveEvents::registerLuaItemEvent(MoveEvent& moveEvent) {
	auto itemIdVector = moveEvent.getItemIdsVector();
	if (itemIdVector.empty()) {
		return false;
	}

	std::for_each(itemIdVector.begin(), itemIdVector.end(), [this, &moveEvent](uint32_t &itemId) {
		registerEvent(moveEvent, itemId, itemIdMap);
		if (moveEvent.getEventType() == MOVE_EVENT_EQUIP) {
			ItemType& it = Item::items.getItemType(itemId);
			it.wieldInfo = moveEvent.getWieldInfo();
			it.minReqLevel = moveEvent.getReqLevel();
			it.minReqMagicLevel = moveEvent.getReqMagLv();
			it.vocationString = moveEvent.getVocationString();
		}
		return true;
	});
	itemIdVector.clear();
	itemIdVector.shrink_to_fit();
	return true;
}

bool MoveEvents::registerLuaActionEvent(MoveEvent& moveEvent) {
	auto actionIdVector = moveEvent.getActionIdsVector();
	if (actionIdVector.empty()) {
		return false;
	}

	std::for_each(actionIdVector.begin(), actionIdVector.end(), [this, &moveEvent](uint32_t &actionId) {
		registerEvent(moveEvent, actionId, actionIdMap);
		return true;
	});

	actionIdVector.clear();
	actionIdVector.shrink_to_fit();
	return true;
}

bool MoveEvents::registerLuaUniqueEvent(MoveEvent& moveEvent) {
	auto uniqueIdVector = moveEvent.getUniqueIdsVector();
	if (uniqueIdVector.empty()) {
		return false;
	}

	std::for_each(uniqueIdVector.begin(), uniqueIdVector.end(), [this, &moveEvent](uint32_t &uniqueId) {
		registerEvent(moveEvent, uniqueId, uniqueIdMap);
		return true;
	});

	uniqueIdVector.clear();
	uniqueIdVector.shrink_to_fit();
	return true;
}

bool MoveEvents::registerLuaPositionEvent(MoveEvent& moveEvent) {
	auto positionVector = moveEvent.getPositionsVector();
	if (positionVector.empty()) {
		return false;
	}

	std::for_each(positionVector.begin(), positionVector.end(), [this, &moveEvent](Position &position) {
		registerEvent(moveEvent, position, positionsMap);
		return true;
	});

	positionVector.clear();
	positionVector.shrink_to_fit();
	return true;
}

bool MoveEvents::registerLuaEvent(MoveEvent& moveEvent) {
	// Check if event is correct
	if (registerLuaItemEvent(moveEvent)
	|| registerLuaUniqueEvent(moveEvent)
	|| registerLuaActionEvent(moveEvent)
	|| registerLuaPositionEvent(moveEvent))
	{
		return true;
	} else {
		SPDLOG_WARN("[MoveEvents::registerLuaEvent] - "
				"Missing id, aid, uid or position for script with name {}", moveEvent.getFileName());
		return false;
	}
	SPDLOG_DEBUG("[MoveEvents::registerLuaEvent] - Missing or incorrect event on script with name {}", moveEvent.getFileName());
	return false;
}

void MoveEvents::registerEvent(MoveEvent& moveEvent, int32_t id, MoveListMap& moveListMap) {
	auto it = moveListMap.find(id);
	if (it == moveListMap.end()) {
		MoveEventList moveEventList;
		moveEventList.moveEvent[moveEvent.getEventType()].push_back(std::move(moveEvent));
		moveListMap[id] = moveEventList;
	} else {
		std::list<MoveEvent>& moveEventList = it->second.moveEvent[moveEvent.getEventType()];
		for (MoveEvent& existingMoveEvent : moveEventList) {
			if (existingMoveEvent.getSlot() == moveEvent.getSlot()) {
				SPDLOG_WARN("[MoveEvents::registerEvent] - "
							"Duplicate move event found: {}, for script with name {}", id, moveEvent.getFileName());
			}
		}
		moveEventList.push_back(std::move(moveEvent));
	}
}

MoveEvent* MoveEvents::getEvent(Item& item, MoveEvent_t eventType, Slots_t slot) {
	uint32_t slotp;
	switch (slot) {
		case CONST_SLOT_HEAD: slotp = SLOTP_HEAD; break;
		case CONST_SLOT_NECKLACE: slotp = SLOTP_NECKLACE; break;
		case CONST_SLOT_BACKPACK: slotp = SLOTP_BACKPACK; break;
		case CONST_SLOT_ARMOR: slotp = SLOTP_ARMOR; break;
		case CONST_SLOT_RIGHT: slotp = SLOTP_RIGHT; break;
		case CONST_SLOT_LEFT: slotp = SLOTP_LEFT; break;
		case CONST_SLOT_LEGS: slotp = SLOTP_LEGS; break;
		case CONST_SLOT_FEET: slotp = SLOTP_FEET; break;
		case CONST_SLOT_AMMO: slotp = SLOTP_AMMO; break;
		case CONST_SLOT_RING: slotp = SLOTP_RING; break;
		default: slotp = 0; break;
	}

	if (item.hasAttribute(ITEM_ATTRIBUTE_ACTIONID)) {
		MoveListMap::iterator it = actionIdMap.find(item.getActionId());
		if (it != actionIdMap.end()) {
			std::list<MoveEvent>& moveEventList = it->second.moveEvent[eventType];
			for (MoveEvent& moveEvent : moveEventList) {
				if ((moveEvent.getSlot() & slotp) != 0) {
					return &moveEvent;
				}
			}
		}
	}

	auto it = itemIdMap.find(item.getID());
	if (it != itemIdMap.end()) {
		std::list<MoveEvent>& moveEventList = it->second.moveEvent[eventType];
		for (MoveEvent& moveEvent : moveEventList) {
			if ((moveEvent.getSlot() & slotp) != 0) {
				return &moveEvent;
			}
		}
	}
	return nullptr;
}

MoveEvent* MoveEvents::getEvent(Item& item, MoveEvent_t eventType) {
	MoveListMap::iterator it;
	if (item.hasAttribute(ITEM_ATTRIBUTE_UNIQUEID)) {
		it = uniqueIdMap.find(item.getUniqueId());
		if (it != uniqueIdMap.end()) {
			std::list<MoveEvent>& moveEventList = it->second.moveEvent[eventType];
			if (!moveEventList.empty()) {
				return &(*moveEventList.begin());
			}
		}
	}

	if (item.hasAttribute(ITEM_ATTRIBUTE_ACTIONID)) {
		it = actionIdMap.find(item.getActionId());
		if (it != actionIdMap.end()) {
			std::list<MoveEvent>& moveEventList = it->second.moveEvent[eventType];
			if (!moveEventList.empty()) {
				return &(*moveEventList.begin());
			}
		}
	}

	it = itemIdMap.find(item.getID());
	if (it != itemIdMap.end()) {
		std::list<MoveEvent>& moveEventList = it->second.moveEvent[eventType];
		if (!moveEventList.empty()) {
			return &(*moveEventList.begin());
		}
	}
	return nullptr;
}

void MoveEvents::registerEvent(MoveEvent& moveEvent, const Position& position, MovePosListMap& moveListMap) {
	auto it = moveListMap.find(position);
	if (it == moveListMap.end()) {
		MoveEventList moveEventList;
		moveEventList.moveEvent[moveEvent.getEventType()].push_back(std::move(moveEvent));
		moveListMap[position] = moveEventList;
	} else {
		std::list<MoveEvent>& moveEventList = it->second.moveEvent[moveEvent.getEventType()];
		if (!moveEventList.empty()) {
			SPDLOG_WARN("[MoveEvents::registerEvent] - "
						"Duplicate move event found: {}, for script with name {}", position.toString(), moveEvent.getFileName());
		}

		moveEventList.push_back(std::move(moveEvent));
	}
}

MoveEvent* MoveEvents::getEvent(Tile& tile, MoveEvent_t eventType) {
	auto it = positionsMap.find(tile.getPosition());
	if (it != positionsMap.end()) {
		std::list<MoveEvent>& moveEventList = it->second.moveEvent[eventType];
		if (!moveEventList.empty()) {
			return &(*moveEventList.begin());
		}
	}
	return nullptr;
}

uint32_t MoveEvents::onCreatureMove(Creature& creature, Tile& tile, MoveEvent_t eventType) {
	const Position& pos = tile.getPosition();

	uint32_t ret = 1;

	MoveEvent* moveEvent = getEvent(tile, eventType);
	if (moveEvent) {
		ret &= moveEvent->fireStepEvent(creature, pos);
	}

	for (size_t i = tile.getFirstIndex(), j = tile.getLastIndex(); i < j; ++i) {
		Thing* thing = tile.getThing(i);
		if (!thing) {
			continue;
		}

		Item* tileItem = thing->getItem();
		if (!tileItem) {
			continue;
		}

		moveEvent = getEvent(*tileItem, eventType);
		if (moveEvent) {
			ret &= moveEvent->fireStepEvent(creature, *tileItem, pos);
		}
	}
	return ret;
}

uint32_t MoveEvents::onPlayerEquip(Player& player, Item& item, Slots_t slot, bool isCheck) {
	MoveEvent* moveEvent = getEvent(item, MOVE_EVENT_EQUIP, slot);
	if (!moveEvent) {
		return 1;
	}

	return moveEvent->fireEquip(player, item, slot, isCheck);
}

uint32_t MoveEvents::onPlayerDeEquip(Player& player, Item& item, Slots_t slot) {
	MoveEvent* moveEvent = getEvent(item, MOVE_EVENT_DEEQUIP, slot);
	if (!moveEvent) {
		return 1;
	}
	return moveEvent->fireEquip(player, item, slot, false);
}

uint32_t MoveEvents::onItemMove(Item& item, Tile& tile, bool isAdd) {
	MoveEvent_t eventType1, eventType2;
	if (isAdd) {
		eventType1 = MOVE_EVENT_ADD_ITEM;
		eventType2 = MOVE_EVENT_ADD_ITEM_ITEMTILE;
	} else {
		eventType1 = MOVE_EVENT_REMOVE_ITEM;
		eventType2 = MOVE_EVENT_REMOVE_ITEM_ITEMTILE;
	}

	uint32_t ret = 1;
	MoveEvent* moveEvent = getEvent(tile, eventType1);
	if (moveEvent) {
		// No tile item
		ret &= moveEvent->fireAddRemItem(item, tile.getPosition());
	}

	moveEvent = getEvent(item, eventType1);
	if (moveEvent) {
		// No tile item
		ret &= moveEvent->fireAddRemItem(item, tile.getPosition());
	}

	for (size_t i = tile.getFirstIndex(), j = tile.getLastIndex(); i < j; ++i) {
		Thing* thing = tile.getThing(i);
		if (!thing) {
			continue;
		}

		Item* tileItem = thing->getItem();
		if (!tileItem) {
			continue;
		}

		moveEvent = getEvent(*tileItem, eventType2);
		if (moveEvent) {
			ret &= moveEvent->fireAddRemItem(item, *tileItem, tile.getPosition());
		}
	}
	return ret;
}

MoveEvent::MoveEvent(LuaScriptInterface* interface) : Event(interface) {}

std::string MoveEvent::getScriptEventName() const {
	switch (eventType) {
		case MOVE_EVENT_STEP_IN: return "onStepIn";
		case MOVE_EVENT_STEP_OUT: return "onStepOut";
		case MOVE_EVENT_EQUIP: return "onEquip";
		case MOVE_EVENT_DEEQUIP: return "onDeEquip";
		case MOVE_EVENT_ADD_ITEM: return "onAddItem";
		case MOVE_EVENT_REMOVE_ITEM: return "onRemoveItem";
		default:
			SPDLOG_ERROR("[MoveEvent::getScriptEventName] - Invalid event type");
			return std::string();
	}
}

bool MoveEvent::configureEvent(const pugi::xml_node& node) {
	pugi::xml_attribute eventAttr = node.attribute("event");
	if (!eventAttr) {
		SPDLOG_ERROR("[MoveEvent::configureMoveEvent] - Missing event");
		return false;
	}

	std::string tmpStr = asLowerCaseString(eventAttr.as_string());
	if (tmpStr == "stepin") {
		eventType = MOVE_EVENT_STEP_IN;
	} else if (tmpStr == "stepout") {
		eventType = MOVE_EVENT_STEP_OUT;
	} else if (tmpStr == "equip") {
		eventType = MOVE_EVENT_EQUIP;
	} else if (tmpStr == "deequip") {
		eventType = MOVE_EVENT_DEEQUIP;
	} else if (tmpStr == "additem") {
		eventType = MOVE_EVENT_ADD_ITEM;
	} else if (tmpStr == "removeitem") {
		eventType = MOVE_EVENT_REMOVE_ITEM;
	} else {
		SPDLOG_ERROR("[MoveEvent::configureMoveEvent] - "
                    "No valid event name {}", eventAttr.as_string());
		return false;
	}

	if (eventType == MOVE_EVENT_EQUIP || eventType == MOVE_EVENT_DEEQUIP) {
		pugi::xml_attribute slotAttribute = node.attribute("slot");
		if (slotAttribute) {
			tmpStr = asLowerCaseString(slotAttribute.as_string());
			if (tmpStr == "head") {
				slot = SLOTP_HEAD;
			} else if (tmpStr == "necklace") {
				slot = SLOTP_NECKLACE;
			} else if (tmpStr == "backpack") {
				slot = SLOTP_BACKPACK;
			} else if (tmpStr == "armor") {
				slot = SLOTP_ARMOR;
			} else if (tmpStr == "right-hand") {
				slot = SLOTP_RIGHT;
			} else if (tmpStr == "left-hand") {
				slot = SLOTP_LEFT;
			} else if (tmpStr == "hand" || tmpStr == "shield") {
				slot = SLOTP_RIGHT | SLOTP_LEFT;
			} else if (tmpStr == "legs") {
				slot = SLOTP_LEGS;
			} else if (tmpStr == "feet") {
				slot = SLOTP_FEET;
			} else if (tmpStr == "ring") {
				slot = SLOTP_RING;
			} else if (tmpStr == "ammo") {
				slot = SLOTP_AMMO;
			} else {
				SPDLOG_WARN("[MoveEvent::configureMoveEvent] - "
							"Unknown slot type: {}", slotAttribute.as_string());
			}
		}

		wieldInfo = 0;

		pugi::xml_attribute levelAttribute = node.attribute("level");
		if (levelAttribute) {
			reqLevel = pugi::cast<uint32_t>(levelAttribute.value());
			if (reqLevel > 0) {
				wieldInfo |= WIELDINFO_LEVEL;
			}
		}

		pugi::xml_attribute magLevelAttribute = node.attribute("maglevel");
		if (magLevelAttribute) {
			reqMagLevel = pugi::cast<uint32_t>(magLevelAttribute.value());
			if (reqMagLevel > 0) {
				wieldInfo |= WIELDINFO_MAGLV;
			}
		}

		pugi::xml_attribute premiumAttribute = node.attribute("premium");
		if (premiumAttribute) {
			premium = premiumAttribute.as_bool();
			if (premium) {
				wieldInfo |= WIELDINFO_PREMIUM;
			}
		}

		//Gather vocation information
		std::list<std::string> vocStringList;
		for (auto vocationNode : node.children()) {
			pugi::xml_attribute vocationNameAttribute = vocationNode.attribute("name");
			if (!vocationNameAttribute) {
				continue;
			}

			int32_t vocationId = g_vocations().getVocationId(vocationNameAttribute.as_string());
			if (vocationId != -1) {
				vocEquipMap[vocationId] = true;
				if (vocationNode.attribute("showInDescription").as_bool(true)) {
					vocStringList.push_back(asLowerCaseString(vocationNameAttribute.as_string()));
				}
			}
		}

		if (!vocEquipMap.empty()) {
			wieldInfo |= WIELDINFO_VOCREQ;
		}

		for (const std::string& str : vocStringList) {
			if (!vocationString.empty()) {
				if (str != vocStringList.back()) {
					vocationString.push_back(',');
					vocationString.push_back(' ');
				} else {
					vocationString += " and ";
				}
			}

			vocationString += str;
			vocationString.push_back('s');
		}
	}
	return true;
}

uint32_t MoveEvent::StepInField(Creature* creature, Item* item, const Position&) {
	if (!creature) {
		SPDLOG_ERROR("[MoveEvent::StepInField] - Creature is nullptr");
		return 0;
	}

	if (!item) {
		SPDLOG_ERROR("[MoveEvent::StepInField] - Item is nullptr");
		return 0;
	}

	MagicField* field = item->getMagicField();
	if (field) {
		field->onStepInField(*creature);
		return 1;
	}

	return LUA_ERROR_ITEM_NOT_FOUND;
}

uint32_t MoveEvent::StepOutField(Creature*, Item*, const Position&) {
	return 1;
}

uint32_t MoveEvent::AddItemField(Item* item, Item*, const Position&) {
	if (!item) {
		SPDLOG_ERROR("[MoveEvent::AddItemField] - Item is nullptr");
		return 0;
	}

	if (MagicField* field = item->getMagicField())
	{
		if (Tile* tile = item->getTile();
		CreatureVector* creatures = tile->getCreatures())
		{
			for (Creature* creature : *creatures) {
				field->onStepInField(*creature);
			}
		}
		return 1;
	}
	return LUA_ERROR_ITEM_NOT_FOUND;
}

uint32_t MoveEvent::RemoveItemField(Item*, Item*, const Position&) {
	return 1;
}

uint32_t MoveEvent::EquipItem(MoveEvent* moveEvent, Player* player, Item* item, Slots_t slot, bool isCheck) {
	if (!player) {
		SPDLOG_ERROR("[MoveEvent::EquipItem] - Creature is nullptr");
		return 0;
	}

	if (!item) {
		SPDLOG_ERROR("[MoveEvent::EquipItem] - Item is nullptr");
		return 0;
	}

	if (player->isItemAbilityEnabled(slot)) {
		return 1;
	}

	if (!player->hasFlag(PlayerFlag_IgnoreWeaponCheck) && moveEvent->getWieldInfo() != 0) {
		if (player->getLevel() < moveEvent->getReqLevel() || player->getMagicLevel() < moveEvent->getReqMagLv()) {
			return 0;
		}

		if (moveEvent->isPremium() && !player->isPremium()) {
			return 0;
		}

		const VocEquipMap& vocEquipMap = moveEvent->getVocEquipMap();
		if (!vocEquipMap.empty() && vocEquipMap.find(player->getVocationId()) == vocEquipMap.end()) {
			return 0;
		}
	}

	if (isCheck) {
		return 1;
	}

	const ItemType& it = Item::items[item->getID()];
	if (it.transformEquipTo != 0) {
		g_game().transformItem(item, it.transformEquipTo);
	} else {
		player->setItemAbility(slot, true);
	}

	for (uint8_t slotid = 0; slotid < item->getImbuementSlot(); slotid++) {
		ImbuementInfo imbuementInfo;
		if (!item->getImbuementInfo(slotid, &imbuementInfo)) {
			continue;
		}

		player->addItemImbuementStats(imbuementInfo.imbuement);
		g_game().increasePlayerActiveImbuements(player->getID());
	}

	if (!it.abilities) {
		return 1;
	}

	if (it.abilities->invisible) {
		Condition* condition = Condition::createCondition(static_cast<ConditionId_t>(slot), CONDITION_INVISIBLE, -1, 0);
		player->addCondition(condition);
	}

	if (it.abilities->manaShield) {
		Condition* condition = Condition::createCondition(static_cast<ConditionId_t>(slot), CONDITION_MANASHIELD, -1, 0);
		player->addCondition(condition);
	}

	if (it.abilities->speed != 0) {
		g_game().changePlayerSpeed(*player, it.abilities->speed);
	}

	if (it.abilities->conditionSuppressions != 0) {
		player->addConditionSuppressions(it.abilities->conditionSuppressions);
		player->sendIcons();
	}

	if (it.abilities->regeneration) {
		Condition* condition = Condition::createCondition(static_cast<ConditionId_t>(slot), CONDITION_REGENERATION, -1, 0);

		if (it.abilities->getHealthGain() != 0) {
			condition->setParam(CONDITION_PARAM_HEALTHGAIN, it.abilities->getHealthGain());
		}

		if (it.abilities->getHealthTicks() != 0) {
			condition->setParam(CONDITION_PARAM_HEALTHTICKS, it.abilities->getHealthTicks());
		}

		if (it.abilities->getManaGain() != 0) {
			condition->setParam(CONDITION_PARAM_MANAGAIN, it.abilities->getManaGain());
		}

		if (it.abilities->getManaTicks() != 0) {
			condition->setParam(CONDITION_PARAM_MANATICKS, it.abilities->getManaTicks());
		}

		player->addCondition(condition);
	}

	//skill/stats modifiers
	bool needUpdate = false;

	for (int32_t i = SKILL_FIRST; i <= SKILL_LAST; ++i) {
		if (it.abilities->skills[i]) {
			needUpdate = true;
			player->setVarSkill(static_cast<skills_t>(i), it.abilities->skills[i]);
		}
	}

	for (int32_t s = STAT_FIRST; s <= STAT_LAST; ++s) {
		if (it.abilities->stats[s]) {
			needUpdate = true;
			player->setVarStats(static_cast<stats_t>(s), it.abilities->stats[s]);
		}

		if (it.abilities->statsPercent[s]) {
			needUpdate = true;
			player->setVarStats(static_cast<stats_t>(s), static_cast<int32_t>(player->getDefaultStats(static_cast<stats_t>(s)) * ((it.abilities->statsPercent[s] - 100) / 100.f)));
		}
	}

	if (needUpdate) {
		player->sendStats();
		player->sendSkills();
	}

	return 1;
}

uint32_t MoveEvent::DeEquipItem(MoveEvent*, Player* player, Item* item, Slots_t slot, bool) {
	if (!player) {
		SPDLOG_ERROR("[MoveEvent::EquipItem] - Creature is nullptr");
		return 0;
	}

	if (!item) {
		SPDLOG_ERROR("[MoveEvent::EquipItem] - Item is nullptr");
		return 0;
	}

	if (!player->isItemAbilityEnabled(slot)) {
		return 1;
	}

	player->setItemAbility(slot, false);

	const ItemType& it = Item::items[item->getID()];
	if (it.transformDeEquipTo != 0) {
		g_game().transformItem(item, it.transformDeEquipTo);
	}

	for (uint8_t slotid = 0; slotid < item->getImbuementSlot(); slotid++) {
		ImbuementInfo imbuementInfo;
		if (!item->getImbuementInfo(slotid, &imbuementInfo)) {
			continue;
		}

		player->removeItemImbuementStats(imbuementInfo.imbuement);
		g_game().decreasePlayerActiveImbuements(player->getID());
	}

	if (!it.abilities) {
		return 1;
	}

	if (it.abilities->invisible) {
		player->removeCondition(CONDITION_INVISIBLE, static_cast<ConditionId_t>(slot));
	}

	if (it.abilities->manaShield) {
		player->removeCondition(CONDITION_MANASHIELD, static_cast<ConditionId_t>(slot));
	}

	if (it.abilities->speed != 0) {
		g_game().changePlayerSpeed(*player, -it.abilities->speed);
	}

	if (it.abilities->conditionSuppressions != 0) {
		player->removeConditionSuppressions(it.abilities->conditionSuppressions);
		player->sendIcons();
	}

	if (it.abilities->regeneration) {
		player->removeCondition(CONDITION_REGENERATION, static_cast<ConditionId_t>(slot));
	}

	//skill/stats modifiers
	bool needUpdate = false;

	for (int32_t i = SKILL_FIRST; i <= SKILL_LAST; ++i) {
		if (it.abilities->skills[i] != 0) {
			needUpdate = true;
			player->setVarSkill(static_cast<skills_t>(i), -it.abilities->skills[i]);
		}
	}

	for (int32_t s = STAT_FIRST; s <= STAT_LAST; ++s) {
		if (it.abilities->stats[s]) {
			needUpdate = true;
			player->setVarStats(static_cast<stats_t>(s), -it.abilities->stats[s]);
		}

		if (it.abilities->statsPercent[s]) {
			needUpdate = true;
			player->setVarStats(static_cast<stats_t>(s), -static_cast<int32_t>(player->getDefaultStats(static_cast<stats_t>(s)) * ((it.abilities->statsPercent[s] - 100) / 100.f)));
		}
	}

	if (needUpdate) {
		player->sendStats();
		player->sendSkills();
	}

	return 1;
}

// TODO (EDUARDO): Move this functions for revscriptsys interface
bool MoveEvent::loadFunction(const pugi::xml_attribute& attr, bool isScripted) {
	const char* functionName = attr.as_string();
	if (strcasecmp(functionName, "onstepinfield") == 0) {
		stepFunction = StepInField;
	} else if (strcasecmp(functionName, "onstepoutfield") == 0) {
		stepFunction = StepOutField;
	} else if (strcasecmp(functionName, "onaddfield") == 0) {
		moveFunction = AddItemField;
	} else if (strcasecmp(functionName, "onremovefield") == 0) {
		moveFunction = RemoveItemField;
	} else if (strcasecmp(functionName, "onequipitem") == 0) {
		equipFunction = EquipItem;
	} else if (strcasecmp(functionName, "ondeequipitem") == 0) {
		equipFunction = DeEquipItem;
	} else {
		if (!isScripted) {
			SPDLOG_WARN("[MoveEvent::loadFunction] - "
						"Function {} does not exist", functionName);
			return false;
		}
	}

	if (!isScripted) {
		scripted = false;
	}
	return true;
}

MoveEvent_t MoveEvent::getEventType() const {
	return eventType;
}

void MoveEvent::setEventType(MoveEvent_t type) {
	eventType = type;
}

uint32_t MoveEvent::fireStepEvent(Creature& creature, Item& item, const Position& pos) {
	if (isLoadedCallback()) {
		return executeStep(creature, item, pos);
	} else {
		return stepFunction(&creature, &item, pos);
	}
}

bool MoveEvent::executeStep(Creature& creature, Item& item, const Position& pos) {
	//onStepIn(creature, item, pos, fromPosition)
	//onStepOut(creature, item, pos, fromPosition)
	if (!scriptInterface->reserveScriptEnv()) {
		SPDLOG_ERROR("[MoveEvent::executeStep - Creature {} item {}] "
                    "Call stack overflow. Too many lua script calls being nested.",
                    creature.getName(), item.getName());
		return false;
	}

	ScriptEnvironment* env = scriptInterface->getScriptEnv();
	env->setScriptId(scriptId, scriptInterface);

	lua_State* L = scriptInterface->getLuaState();

	scriptInterface->pushFunction(scriptId);
	LuaScriptInterface::pushUserdata<Creature>(L, &creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, &creature);
	LuaScriptInterface::pushThing(L, &item);
	LuaScriptInterface::pushPosition(L, pos);
	LuaScriptInterface::pushPosition(L, creature.getLastPosition());

	return scriptInterface->callFunction(4);
}

uint32_t MoveEvent::fireStepEvent(Creature& creature, const Position& pos) {
	if (isLoadedCallback()) {
		return executeStep(creature, pos);
	} else {
		return stepFunction(&creature, nullptr, pos);
	}
}

bool MoveEvent::executeStep(Creature& creature, const Position& pos) {
	//onStepIn(creature, pos, fromPosition)
	//onStepOut(creature, pos, fromPosition)
	if (!scriptInterface->reserveScriptEnv()) {
		SPDLOG_ERROR("[MoveEvent::executeStep - Creature {}] "
                    "Call stack overflow. Too many lua script calls being nested.",
                    creature.getName());
		return false;
	}

	ScriptEnvironment* env = scriptInterface->getScriptEnv();
	env->setScriptId(scriptId, scriptInterface);

	lua_State* L = scriptInterface->getLuaState();

	scriptInterface->pushFunction(scriptId);
	LuaScriptInterface::pushUserdata<Creature>(L, &creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, &creature);
	LuaScriptInterface::pushPosition(L, pos);
	LuaScriptInterface::pushPosition(L, creature.getLastPosition());

	return scriptInterface->callFunction(3);
}

uint32_t MoveEvent::fireEquip(Player& player, Item& item, Slots_t toSlot, bool isCheck) {
	if (isLoadedCallback()) {
		if (!equipFunction || equipFunction(this, &player, &item, toSlot, isCheck) == 1) {
			if (executeEquip(player, item, toSlot, isCheck)) {
				return 1;
			}
		}
		return 0;
	} else {
		return equipFunction(this, &player, &item, toSlot, isCheck);
	}
}

bool MoveEvent::executeEquip(Player& player, Item& item, Slots_t onSlot, bool isCheck) {
	//onEquip(player, item, slot, isCheck)
	//onDeEquip(player, item, slot, isCheck)
	if (!scriptInterface->reserveScriptEnv()) {
		SPDLOG_ERROR("[MoveEvent::executeEquip - Player {} item {}] "
                    "Call stack overflow. Too many lua script calls being nested.",
                    player.getName(), item.getName());
		return false;
	}

	ScriptEnvironment* env = scriptInterface->getScriptEnv();
	env->setScriptId(scriptId, scriptInterface);

	lua_State* L = scriptInterface->getLuaState();

	scriptInterface->pushFunction(scriptId);
	LuaScriptInterface::pushUserdata<Player>(L, &player);
	LuaScriptInterface::setMetatable(L, -1, "Player");
	LuaScriptInterface::pushThing(L, &item);
	lua_pushnumber(L, onSlot);
	LuaScriptInterface::pushBoolean(L, isCheck);

	return scriptInterface->callFunction(4);
}

uint32_t MoveEvent::fireAddRemItem(Item& item, Item& fromTile, const Position& pos) {
	if (isLoadedCallback()) {
		return executeAddRemItem(item, fromTile, pos);
	} else {
		return moveFunction(&item, &fromTile, pos);
	}
}

bool MoveEvent::executeAddRemItem(Item& item, Item& fromTile, const Position& pos) {
	//onAddItem(moveitem, tileitem, pos)
	//onRemoveItem(moveitem, tileitem, pos)
	if (!scriptInterface->reserveScriptEnv()) {
		SPDLOG_ERROR("[MoveEvent::executeAddRemItem - "
                    "Item {} item on tile x: {} y: {} z: {}] "
                    "Call stack overflow. Too many lua script calls being nested.",
                    item.getName(),
                    pos.getX(), pos.getY(), pos.getZ());
		return false;
	}

	ScriptEnvironment* env = scriptInterface->getScriptEnv();
	env->setScriptId(scriptId, scriptInterface);

	lua_State* L = scriptInterface->getLuaState();

	scriptInterface->pushFunction(scriptId);
	LuaScriptInterface::pushThing(L, &item);
	LuaScriptInterface::pushThing(L, &fromTile);
	LuaScriptInterface::pushPosition(L, pos);

	return scriptInterface->callFunction(3);
}

uint32_t MoveEvent::fireAddRemItem(Item& item, const Position& pos) {
	if (isLoadedCallback()) {
		return executeAddRemItem(item, pos);
	} else {
		return moveFunction(&item, nullptr, pos);
	}
}

bool MoveEvent::executeAddRemItem(Item& item, const Position& pos) {
	//onaddItem(moveitem, pos)
	//onRemoveItem(moveitem, pos)
	if (!scriptInterface->reserveScriptEnv()) {
		SPDLOG_ERROR("[MoveEvent::executeAddRemItem - "
                    "Item {} item on tile x: {} y: {} z: {}] "
                    "Call stack overflow. Too many lua script calls being nested.",
                    item.getName(),
                    pos.getX(), pos.getY(), pos.getZ());
		return false;
	}

	ScriptEnvironment* env = scriptInterface->getScriptEnv();
	env->setScriptId(scriptId, scriptInterface);

	lua_State* L = scriptInterface->getLuaState();

	scriptInterface->pushFunction(scriptId);
	LuaScriptInterface::pushThing(L, &item);
	LuaScriptInterface::pushPosition(L, pos);

	return scriptInterface->callFunction(2);
}
