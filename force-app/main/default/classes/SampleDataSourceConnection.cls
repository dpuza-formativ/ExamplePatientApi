global class SampleDataSourceConnection 
	extends DataSource.Connection 
{
	global SampleDataSourceConnection(DataSource.ConnectionParams connectionParams)
    {
        
    }
    
    override global List<DataSource.Table> sync()
    {
        List<DataSource.Table> tables = new List<DataSource.Table>();        
        List<DataSource.Column> columns = new List<DataSource.Column>();
        columns.add(DataSource.Column.text('Name', 255));
        columns.add(DataSource.Column.text('ExternalId', 255));
        columns.add(DataSource.Column.url('DisplayUrl'));

        columns.add(DataSource.Column.text('LastName', 255));
        columns.add(DataSource.Column.text('Address2', 255));
        columns.add(DataSource.Column.text('PhoneCell', 255));
        columns.add(DataSource.Column.text('FirstName', 255));
        columns.add(DataSource.Column.text('DOB', 255));
        columns.add(DataSource.Column.text('PatientId', 255));
        columns.add(DataSource.Column.text('State', 255));
        columns.add(DataSource.Column.text('Zip', 255));
        columns.add(DataSource.Column.text('Address1', 255));
        columns.add(DataSource.Column.text('PhoneHome', 255));
        columns.add(DataSource.Column.text('City', 255));

        tables.add(DataSource.Table.get('Patient', 'LastName', columns));
        
        return tables;
    }
    
    override global DataSource.TableResult query(DataSource.QueryContext c) {
        List<Map<String,Object>> rows = new List<Map<String,Object>>();
        //rows = DataSource.QueryUtils.process(c, getRows());
        rows = GetHttpResult();
        //rows = GetHardcodedResult();
        return DataSource.TableResult.get(c, rows);
    }
    
    private static List<Map<String,Object>> GetHardcodedResult()
    {
        List<Map<String,Object>> rows = new List<Map<String,Object>>();
        Map<String,Object> row = new Map<String,Object>();
        row.put('ExternalId', string.valueOf('123456'));
        row.put('DisplayUrl', string.valueOf('https://example.org/123456'));
        row.put('Name', string.valueOf('Example'));
        rows.add(row);
        row = new Map<String,Object>();
        row.put('ExternalId', string.valueOf('123457'));
        row.put('DisplayUrl', string.valueOf('https://example.org/123457'));
        row.put('Name', string.valueOf('Christine Puza'));
        rows.add(row);
        return rows;
    }
       
    private static List<Map<String,Object>> GetHttpResult()
    {
        List<Map<String,Object>> rows = new List<Map<String,Object>>();
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:PASQACredential/PASOData/api/ExamplePatient/Something');
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String responseBody = res.getBody();
                    
        Map<String,Object> row = new Map<String,Object>();
        row.put('ExternalId', string.valueOf('123456'));
        row.put('DisplayUrl', string.valueOf('https://example.org/123456'));
        row.put('Name', string.valueOf(responseBody.left(200)));
        rows.add(row);
        
        return rows;
    }

    // Helper method to get record values from the external system for the Sample table.
    private List<Map<String, Object>> getRows () {
        List<Map<String,Object>> rows = new List<Map<String,Object>>();
        /*
        // Get row field values for the Sample table from the external system via a callout.
        HttpResponse response = makeGetCallout();
        // Parse the JSON response and populate the rows.
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(
                response.getBody());
        Map<String, Object> error = (Map<String, Object>)m.get('error');
        if (error != null) {
            throwException(string.valueOf(error.get('message')));
        }
        List<Map<String,Object>> rows = new List<Map<String,Object>>();
        List<Object> jsonRows = (List<Object>)m.get('value');
        if (jsonRows == null) {
            rows.add(foundRow(m));
        } else {
            for (Object jsonRow : jsonRows) {
                Map<String,Object> row = (Map<String,Object>)jsonRow;
                rows.add(foundRow(row));
            }
        }
		*/
        return rows;
    }
    
    // Populate a row based on values from the external system.
    private Map<String,Object> foundRow(Map<String,Object> foundRow) {
        Map<String,Object> row = new Map<String,Object>();
        row.put('ExternalId', string.valueOf(foundRow.get('PatientId')));
        //row.put('DisplayUrl', string.valueOf(foundRow.get('DisplayUrl')));
        //row.put('Name', string.valueOf(foundRow.get('Name')));        
        return row;
    }    
}