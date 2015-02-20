




cInsertList = {}





function cInsertList:__call()
	local Obj = {}
	
	setmetatable(Obj, cInsertList)
	Obj.__index = Obj
	
	Obj.m_Values = {}
	
	return Obj
end





function cInsertList:Insert(a_Field, a_Val)
	a_Field = EscapeString(a_Field)
	a_Val   = EscapeString(a_Val)
	
	table.insert(self.m_Values, {field = a_Field, value = a_Val})
	return self
end





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




