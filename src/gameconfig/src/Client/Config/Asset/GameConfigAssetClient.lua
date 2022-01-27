--[=[
	@class GameConfigAssetClient
]=]

local require = require(script.Parent.loader).load(script)

local GameConfigAssetBase = require("GameConfigAssetBase")
local GameConfigTranslator = require("GameConfigTranslator")
local Rx = require("Rx")

local GameConfigAssetClient = setmetatable({}, GameConfigAssetBase)
GameConfigAssetClient.ClassName = "GameConfigAssetClient"
GameConfigAssetClient.__index = GameConfigAssetClient

function GameConfigAssetClient.new(obj, serviceBag)
	local self = setmetatable(GameConfigAssetBase.new(obj), GameConfigAssetClient)

	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._configTranslator = self._serviceBag:GetService(GameConfigTranslator)

	-- self._maid:GiveTask(self:ObserveTranslatedName():Subscribe(print))
	-- self._maid:GiveTask(self:ObserveTranslatedDescription():Subscribe(print))

	return self
end

function GameConfigAssetClient:ObserveTranslatedName()
	-- TODO: Multicast

	return Rx.combineLatest({
		translationKey = self:ObserveNameTranslationKey();
		text = self:ObserveCloudName();
	}):Pipe({
		Rx.switchMap(function(state)
			if type(state.translationKey) == "string" and state.text then
				-- Immediately write if necessary

				local localizationTable = self._configTranslator:GetLocalizationTable()
				local key = state.translationKey
				local source = ""
				local context = ""
				local localeId = "en"
				local value = state.text

				localizationTable:SetEntryValue(key, source, context, localeId, value)

				return self._configTranslator:ObserveFormatByKey(state.translationKey)
			else
				return Rx.EMPTY -- just don't emit anything until we have it.
			end
		end)
	})
end

function GameConfigAssetClient:ObserveTranslatedDescription()
	-- TODO: Multicast

	return Rx.combineLatest({
		translationKey = self:ObserveDescriptionTranslationKey();
		text = self:ObserveCloudDescription();
	}):Pipe({
		Rx.switchMap(function(state)
			if type(state.translationKey) == "string" and state.text then
				-- Immediately write if necessary

				local localizationTable = self._configTranslator:GetLocalizationTable()
				local key = state.translationKey
				local source = ""
				local context = ""
				local localeId = "en"
				local value = state.text

				localizationTable:SetEntryValue(key, source, context, localeId, value)

				return self._configTranslator:ObserveFormatByKey(state.translationKey)
			else
				return Rx.EMPTY -- just don't emit anything until we have it.
			end
		end)
	})
end

return GameConfigAssetClient