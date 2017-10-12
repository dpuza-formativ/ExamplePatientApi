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
        //columns.add(DataSource.Column.text('Name', 255));
        columns.add(DataSource.Column.text('ExternalId', 255));
        columns.add(DataSource.Column.url('DisplayUrl'));

        columns.add(DataSource.Column.text('LastName', 255));
        columns.add(DataSource.Column.text('Address2', 255));
        columns.add(DataSource.Column.text('PhoneCell', 255));
        columns.add(DataSource.Column.text('FirstName', 255));
        columns.add(DataSource.Column.text('DOB', 255));
        //columns.add(DataSource.Column.text('PatientId', 255));
        columns.add(DataSource.Column.text('State', 255));
        columns.add(DataSource.Column.text('Zip', 255));
        columns.add(DataSource.Column.text('Address1', 255));
        columns.add(DataSource.Column.text('PhoneHome', 255));
        columns.add(DataSource.Column.text('City', 255));

        tables.add(DataSource.Table.get('Patient', 'LastName', columns));
        
        return tables;
    }
    
    override global DataSource.TableResult query(DataSource.QueryContext c) 
    {
        String patientResponse = GetPatientResponse();
        List<Map<String,Object>> patients = ParsePatientsResponse(patientResponse);

		/*        
        Map<String,Object> row = new Map<String,Object>();
        row.put('ExternalId', string.valueOf('123456'));
        row.put('DisplayUrl', string.valueOf('https://example.org/123456'));
        row.put('Name', string.valueOf(response.left(200)));
        rows.add(row);        
  		*/      
        return DataSource.TableResult.get(c, patients);
    }
    
    private String GetPatientResponse()
    {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:PASQACredential/PASOData/api/ExamplePatient/Something');
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res.getBody();
    }
    
    private List<Map<String,Object>> ParsePatientsResponse(String patientsJson)
    {
        List<Map<String,Object>> patients = new List<Map<String,Object>>();
    	List<Object> jsonPatients = (List<Object>)JSON.deserializeUntyped(patientsJson);

        for (Object patientObject : jsonPatients)
        {
            Map<String,Object> jsonPatient = (Map<String,Object>)patientObject;
            Map<String,Object> mappedPatient = MapPatient(jsonPatient);
            patients.add(mappedPatient);
        }
        
        return patients;
    }
    
    private Map<String,Object> MapPatient(Map<String,Object> jsonPatient)
    {
        Map<String,Object> mappedPatient = new Map<String,Object>();
        
        mappedPatient.put('ExternalId', string.valueOf(jsonPatient.get('PatientId')));
        mappedPatient.put('DisplayUrl', string.valueOf(jsonPatient.get('DisplayUrl')));
        mappedPatient.put('Name', string.valueOf(jsonPatient.get('Name')));        
        
        return mappedPatient;
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
        row.put('Name', string.valueOf('Dan Puza'));
        rows.add(row);
        return rows;
    }    
}