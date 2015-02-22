




--[[
	cWhereList is a class that is used to specify a condition while fetching, updating or deleting data from one table.
	
	Add new conditions:
		You can give new conditions by using the Where function. The Where functions returns itself so you can keep pushing new conditions.
		The first 2 paramters are required, but the last 2 are optional.
		 Parameter 1: (string) The field to check.
		 Parameter 2: (string) The value that the field has to be compared with.
		<Parameter 3>: (string) The compare method to use. This can be for example an equal sign.
		<Parameter 4>: (string) The logical operator to put before the condition
	
	Afterwards the SQLiteHandler class uses the Compose function to create a valid SQL string
	
	Example:
		local whereList = cWhereList()
		:Where("name", "nilspace") -- Where "name" = "nilspace"
		:Where("ID", 5, "=", "OR") -- OR where "ID" = 5
	
]]





cWhereList = {}




function cWhereList:__call()
	local Obj = {}
	
	setmetatable(Obj, cWhereList)
	Obj.__index = Obj
	
	Obj.m_Values    = {} -- array with tables that contain info about a where condition
	Obj.m_Operators = {} -- array with logical operators.
	
	return Obj
end





-- Function to add a new condition in the list
function cWhereList:Where(a_Field, a_IsVal, a_CompareMethod, a_LogicOpp)
	a_Field         = EscapeString(a_Field)
	a_IsVal         = EscapeString(a_IsVal)
	a_CompareMethod = a_CompareMethod or "="
	a_LogicOpp      = a_LogicOpp or "AND"
	
	table.insert(self.m_Values, {field = a_Field, value = a_IsVal, compareMethod = a_CompareMethod})
	table.insert(self.m_Operators, a_LogicOpp)
	return self
end





-- Function to compose a valid SQL string about the conditions an sql execution should meet
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




