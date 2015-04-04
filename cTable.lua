




--[[
	cTable is a class used to create a new table in an sql database if it doesn't exist yet.
	The constructor has one parameter. This is the name of the table.
	
	After that you can add a new field (or column) using the Field function.
	The field function has 3 parameters where the last one is optional:
	Parameter 1: The name of the field
	Parameter 2: The type of the field
	(Parameter3:) Optional attributes of the field.
	
	Example:
		cTable("TestTable")
		:Field("ID", "INTEGER", "PRIMARY KEY AUTOINCREMENT")
		:Field("name", "TEXT")
]]





cTable = {}





function cTable:__call(a_Name)
	local Obj = {}
	
	setmetatable(Obj, cTable)
	Obj.__index = Obj
	
	Obj.m_Name   = a_Name
	Obj.m_Fields = {}
	
	return Obj
end





-- Adds a new field to the table
function cTable:Field(a_Name, a_Type, a_Attributes)
	table.insert(self.m_Fields, {name = a_Name, type = a_Type, attributes = a_Attributes})
	
	return self
end





-- Composes the fields in a valid sql string that can be used by the database directly.
function cTable:Compose()
	local str = ('CREATE TABLE IF NOT EXISTS "%s" ('):format(self.m_Name)
	for _, field in ipairs(self.m_Fields) do
		str = str .. ("\n\t`%s`\t%s %s,"):format(field.name, field.type, field.attributes or "")
	end
	str = str:sub(1, -2)
	str = str .. "\n)"
	
	return str
end





setmetatable(cTable, cTable)
cTable.__index = cTable




