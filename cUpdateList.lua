




--[[
	cUpdateList is a class used to define new values to existing rows.
	
	It has 2 functions. Update to define a new value and Compose to make a valid sql string out of all the updates.
	Update has 2 parameters:
	Parameter 1: The field
	Parameter 2: The new value
	
	Update returns itself so you can keep pushing new updates.
	Example:
		local updateList = cUpdateList()
		:Update("name", "STR_Warrior") -- Change the name to "STR_Warrior"
		:Update("isadmin", 0)          -- Change isadmin to 0
]]





cUpdateList = {}





function cUpdateList:__call()
	local Obj = {}
	
	setmetatable(Obj, cUpdateList)
	Obj.__index = Obj
	
	Obj.m_Values = {}
	
	return Obj
end





-- Adds new update values to the list
function cUpdateList:Update(a_Field, a_NewVal)
	a_Field = EscapeString(a_Field)
	a_NewVal = EscapeString(a_NewVal)
	
	table.insert(self.m_Values, {field = a_Field, newVal = a_NewVal})
	return self
end





-- Composes all the values in a valid sql string.
function cUpdateList:Compose()
	local str = ''
	for I, value in ipairs(self.m_Values) do
		local StringToFormat = type(value.newVal) == 'string' and "%s = '%s', " or "%s = %s, "
		str = str .. StringToFormat:format(value.field, value.newVal)
	end
	
	return str:sub(1, -3)
end





setmetatable(cUpdateList, cUpdateList)
cUpdateList.__index = cUpdateList




