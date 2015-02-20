




cUpdateList = {}





function cUpdateList:__call()
	local Obj = {}
	
	setmetatable(Obj, cUpdateList)
	Obj.__index = Obj
	
	Obj.m_Values = {}
	
	return Obj
end





function cUpdateList:Update(a_Field, a_NewVal)
	a_Field = EscapeString(a_Field)
	a_NewVal = EscapeString(a_NewVal)
	
	table.insert(self.m_Values, {field = a_Field, newVal = a_NewVal})
	return self
end





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




