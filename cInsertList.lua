




--[[
	cInsertList is a class used to define new values in an table row.
	
	It has 2 functions. Insert to add new values to the list and Compose to make a string out of everything.
	The parameters for Insert are:
	Parameter 1: The name of the field
	Parameter 2: The value to give it.
	
	Insert returns the itself, so you can continue inserting new values.
	Example:
		local insertList = cInsertList()
		:Insert("name", "NiLSPACE") -- Insert "NiLSPACE" in the field "name"
		:Insert("isadmin", 1)       -- Insert 1 in the field "isadmin"
]]





cInsertList = {}





function cInsertList:__call()
	local Obj = {}
	
	setmetatable(Obj, cInsertList)
	Obj.__index = Obj
	
	Obj.m_Values = {}
	
	return Obj
end





-- Adds a new value to the list
function cInsertList:Insert(a_Field, a_Val)
	a_Field = EscapeString(a_Field)
	a_Val   = EscapeString(a_Val)
	
	table.insert(self.m_Values, {field = a_Field, value = a_Val})
	return self
end





-- Composes all the values into a valid sql string.
function cInsertList:Compose()
	local fieldList = "("
	local valueList = "("
	for _, values in ipairs(self.m_Values) do
		fieldList = fieldList .. ("'%s', "):format(values.field)
		valueList = valueList .. ("'%s', "):format(values.value)
	end
	fieldList = fieldList:sub(1, -3) .. ")"
	valueList = valueList:sub(1, -3) .. ")"
	
	return ("%s VALUES %s"):format(fieldList, valueList)
end




setmetatable(cInsertList, cInsertList)
cInsertList.__index = cInsertList




