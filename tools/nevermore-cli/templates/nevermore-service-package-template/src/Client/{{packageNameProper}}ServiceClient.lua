--[=[
	@class {{packageNameProper}}ServiceClient
]=]

local require = require(script.Parent.loader).load(script)

local {{packageNameProper}}ServiceClient = {}
{{packageNameProper}}ServiceClient.ServiceName = "{{packageNameProper}}ServiceClient"

function {{packageNameProper}}ServiceClient:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")


end

return {{packageNameProper}}ServiceClient