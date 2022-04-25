# Build out the connection string to SQL Server and DB to connect to
$Server = Read-Host -Prompt "Input the SQL Server to connect to"
$Database = Read-Host -Prompt "Input the Database to connect to"

$SqlConnection.ConnectionString = "Server=$Server;Database=$Database;Integrated Security=True"

# Create a SqlCommand Object, set the Query text to CommandText and set Connection to the Pre-created connection string above - https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient.sqlcommand
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $("") # Put the query you want to run within this!
$SqlCmd.Connection = $SqlConnection

# Build a new SqlAdapter object and set the query to use our pre-created SqlCmd object that contains connection string and query - https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient.sqldataadapter
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd

# Build dataset object that will store the query results in it's DataTable objects - https://docs.microsoft.com/en-us/dotnet/api/system.data.dataset
$DataSet = New-Object System.Data.DataSet

# Run the SqlAdapter and use its settings to fill the DataSet Object with query results
$SqlAdapter.Fill($DataSet)

# Close out the connection to the SQl Server after filling the DataSet Object
$SqlConnection.Close()
 
<# Convert the output DataSet object to a PowerShell object so it is easier to manipulate.
We do this by building a new PSobject (DataArray) and looping through the DataSet object,
In the ForEach loop, a new inner object (Record) is created to store within the PowerShell Array of Objects (DataArray)
Each inner object is then built by looping through each column in the DataTable and building an entry
made up of the Column (header) and Row Values for each respective column entry in the original DataSet #>
$DataArray = ForEach ($Row in $dataset.Tables[0].Rows) {
    $Record = New-Object PSObject
    ForEach ($Col in $dataset.Tables[0].Columns.ColumnName) {
        Add-Member -InputObject $Record -NotePropertyName $Col -NotePropertyValue $Row.$Col
    }
    $Record
}

$DataArray