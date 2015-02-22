



--[[
This is a class used to make connections to sqlite3 in MCServer much easier to manage.
It creates some basic functions that can still do quite allot, and probably in most cases all you need.
To use it you need the cWhereList, cInsertList and cUpdateList classes

Usage:
	To first create the database you call the table with the path to the file as a parameter.
	You can also give an cTable class. That way the database will automaticly create a new table if it doesn't exist.
	Example:
		local db = cSQLiteHandler("TestDatabase.sqlite")
		local db = cSQLiteHandler("TestDatabase.sqlite", 
			cTable("TestTable")
			:Field("ID", "INTEGER", "PRIMARY KEY AUTOINCREMENT")
			:Field("name", "TEXT")
		)
		
	Get Values (Select):
		To collect values you use the Select function. It has multiple parameters:
			a_Table:          The name of the table to get the information from
			a_Fields:         The fields you want information from
			a_WhereList:      A cWhereList class where all the criteria are defined for the rows to meet.
			a_OrderBy:        A string with the name of a field that. All the rows would be ordered that way.
			a_ReverseResults: A boolean value. If true the order of the results will be reversed
		
		Return values:
			If the query was unsuccessful it returns false, if not it returns an array with all the rows.
			
		Example:
			local res = db:Select("TestTable"); -- Returns all the rows in the table
			
			local whereList = cWhereList()
			:Where("ID", 5)
			local res = db:Select("TestTable", "*", whereList -- Returns all the rows with the ID 5.
	
	Insert values (Insert):
		Puts new values in the database.
		The parameters are:
			a_Table:      The name of the table to insert a row into.
			a_InsertList: A cInsertList class that contains the information about the fields.
		
		Return values:
			Returns true on succes, and returns false when the query was unsuccessful.
		
		Example:
			local insertList = cInsertList()
			:Insert("Field1", "NewData1") -- Field1 will contain "NewData1"
			:Insert("Field2", "NewData2") -- Field2 will contain "NewData2"
			local res = db:Insert("TestTable", insertList)
	
	Remove Rows (Delete):
		If a row has to be deleted you use the Delete function
		The parameters are:
			a_Table:      The table name to delete rows from
			a_WhereList:  A cWhereList class where all the criteria are defined for the rows to meet.
		
		Return values:
			Returns true on succes, and returns false when the query was unsuccessful.
		
		Example:
			local whereList = cWhereList()
			:Where("ID", 127) -- Delete all the rows that have the a field called ID with a value of 127
			local res = db:Delete("TestTable", whereList)
	
	Update data (Update)
		Update is used to change data in the database.
		It has 3 parameters:
			a_Table:      The name of the table to change data in.
			a_UpdateList: A cUpdateList class that contains the new data
			a_WhereList:  A cWhereList class that contains the criteria to find the proper row to change
		
		Return values:
			Returns true on succes, and returns false when the query was unsuccessful.
		
		Example:
			local updateList = cUpdateList()
			:Update("Field1", "ChangedData1") -- Change Field1 to "ChangedData1"
			:Update("Field2", "ChangedData2") -- Change Field2 to "ChangedData2"
			
			local whereList = cWhereList()
			:Where("Field3", "OldData") -- Only change rows where Field3 contains "OldData"
			
			local res = db:Update("TestTable", updateList, whereList)

]]





cSQLiteHandler = {}





-- A function used to put all the results from a SELECT operation into a single table.
cSQLiteHandler.m_ListResults = function(a_UserData, a_NumCols, a_Values, a_Names)
	local res = {}
	for I = 1, a_NumCols do
		res[a_Names[I]] = a_Values[I]
	end
	table.insert(a_UserData, res)
	return 0
end





-- Constructor
function cSQLiteHandler:__call(a_Path, a_Table)
	local m_DB, ErrCode, ErrMsg = sqlite3.open(a_Path)
	
	if (not m_DB) then
		-- Database didn't open. Bail out.
		return false, ErrorCode, ErrMsg
	end
	
	local Obj = {}
	setmetatable(Obj, cSQLiteHandler)
	self.__index = self
	
	
	Obj.m_DB = m_DB
	
	if (a_Table ~= nil) then
		-- a_Table isn't nil, so we must create a new table if it doesn't exist
		local sql = a_Table:Compose()
		local res, Err = Obj:Query(sql)
		if (not res) then
			LOGWARNING("Could not create table %s", Err)
		end
	end
	
	return Obj
end





-- Function used we use to executed sql strings.
function cSQLiteHandler:Query(a_SQL, a_Handler, a_Data)
	assert(a_SQL ~= nil)
	
	local ErrCode = self.m_DB:exec(a_SQL, a_Handler, a_Data)
	if (ErrCode ~= sqlite3.OK) then
		return false, self.m_DB:errmsg();
	end
	
	return true
end





function cSQLiteHandler:Select(a_Table, a_Fields, a_WhereList, a_OrderBy, a_ReverseResults)
	assert(type(a_Table) == 'string')
	
	-- Take "*" as default
	a_Fields = a_Fields or "*"
	
	-- Start the sql string
	local sql = ("SELECT %s FROM %s"):format(a_Fields, a_Table)
	
	if (a_WhereList ~= nil) then
		-- Add the where parameter
		local Where = a_WhereList:Compose()
		
		-- Add where parameters
		sql = sql .. " WHERE " .. Where
	end
	
	-- Give the result in a specific order
	if (a_OrderBy ~= nil) then
		local Order = EscapeString(a_OrderBy)
		
		sql = sql .. (' ORDER BY `%s`'):format(Order)
		if (a_ReverseResults) then
			sql = sql .. ' DESC';
		end
	end
	
	local Data = {}
	local res, Err = self:Query(sql, cSQLiteHandler.m_ListResults, Data)
	if (not res) then
		-- Query was unsuccesfull
		return false, Err;
	end
	
	return Data
end





function cSQLiteHandler:Insert(a_Table, a_InsertList)
	assert(type(a_Table) == 'string')
	assert(type(a_InsertList) == 'table')
	
	local values = a_InsertList:Compose()
	
	-- Finish sql string
	local sql = ("INSERT INTO '%s' %s"):format(a_Table, values)
	
	return self:Query(sql)
end





function cSQLiteHandler:Delete(a_Table, a_WhereList)
	assert(type(a_Table) == 'string')
	
	local where = a_WhereList:Compose()
	
	local sql = ("DELETE FROM '%s' WHERE %s"):format(a_Table, where)
	
	return self:Query(sql)
end





function cSQLiteHandler:Update(a_Table, a_UpdateList, a_WhereList)
	assert(type(a_Table) == 'string')
	
	local update = a_UpdateList:Compose()
	local where  = a_WhereList:Compose()
	
	local sql = ("UPDATE `%s` SET %s WHERE %s"):format(a_Table, update, where)
	
	return self:Query(sql)
end





setmetatable(cSQLiteHandler, cSQLiteHandler)
cSQLiteHandler.__index = cSQLiteHandler




