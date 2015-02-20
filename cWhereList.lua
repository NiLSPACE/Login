




cWhereList = {}




function cWhereList:__call()
	local Obj = {}
	
	setmetatable(Obj, cWhereList)
	Obj.__index = Obj
	
	Obj.m_Values    = {}
	Obj.m_Operators = {}
	
	return Obj
end





function cWhereList:Where(a_Field, a_IsVal, a_CompareMethod, a_LogicOpp)
	a_Field         = EscapeString(a_Field)
	a_IsVal         = EscapeString(a_IsVal)
	a_CompareMethod = a_CompareMethod or "="
	a_LogicOpp      = a_LogicOpp or "AND"
	
	table.insert(self.m_Values, {field = a_Field, value = a_IsVal, compareMethod = a_CompareMethod})
	table.insert(self.m_Operators, a_LogicOpp)
	return self
end





function cWhereList:Compose()
	local str = '('
	for I, values in ipairs(self.m_Values) do
		local Operator = self.m_Operators[I + 1]
		
		-- Sqlite seems to see differences between numbers and strings
		local StringToFormat = type(values.value) == 'string' and "%s %s '%s'" or "%s %s %s"
		str = str .. StringToFormat:format(values.field, values.compareMethod, values.value)
		
		if (Operator) then
			str = str .. (" %s "):format(Operator)
		end
	end
	str = str .. ")"
	
	return str
end





setmetatable(cWhereList, cWhereList)
cWhereList.__index = cWhereList




