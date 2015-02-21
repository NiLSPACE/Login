




cTable = {}





function cTable:__call(a_Name)
	local Obj = {}
	
	setmetatable(Obj, cTable)
	Obj.__index = Obj
	
	Obj.m_Name   = a_Name
	Obj.m_Fields = {}
	
	return Obj
end





function cTable:Field(a_Name, a_Type, a_Attributes)
	table.insert(self.m_Fields, {name = a_Name, type = a_Type, attributes = a_Attributes})
	
	return self
end





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




