package SheetPackageTester;

// This is SheetsQuickstart. This program is used as a demo to demostrate an update to a fix cell location on a Google sheet
// Todos: Please be sure to update the location of your client_secret.json file & the Googlesheet id before running your program.
// Author: Doan Nguyen
// Date: 5/28/18
import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.extensions.java6.auth.oauth2.AuthorizationCodeInstalledApp;
import com.google.api.client.extensions.jetty.auth.oauth2.LocalServerReceiver;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.util.store.FileDataStoreFactory;
import com.google.api.services.sheets.v4.SheetsScopes;
import com.google.api.services.sheets.v4.model.*;
import com.google.api.services.sheets.v4.Sheets;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class SheetsQuickstart {
    /** Application name. */
    private static final String APPLICATION_NAME =
        "Google Sheets API Java Quickstart";

    /** Directory to store user credentials for this application. */
    private static final java.io.File DATA_STORE_DIR = new java.io.File(
        System.getProperty("user.home"), ".credentials//sheets.googleapis.com-java-quickstart.json");

    /** Global instance of the {@link FileDataStoreFactory}. */
    private static FileDataStoreFactory DATA_STORE_FACTORY;

    /** Global instance of the JSON factory. */
    private static final JsonFactory JSON_FACTORY =
        JacksonFactory.getDefaultInstance();

    /** Global instance of the HTTP transport. */
    private static HttpTransport HTTP_TRANSPORT;
    
    /** Global instance of the SpreadsheetID. */
    private static String SPREADSHEET_ID = "1DSdEQJlA6NaHlE0i0VpPRVk40wsH663UOt5TMBdliMc";
    
    /** Global instance of the Instructor Fields*/
    private static String INSTRUCTOR_USERNAME;
    private static String INSTRUCTOR_PASSWORD;

    /** Global instance of the scopes required by this quickstart.
     *
     * If modifying these scopes, delete your previously saved credentials
     * at ~/.credentials/sheets.googleapis.com-java-quickstart.json
     */
    private static final List<String> SCOPES =
        Arrays.asList( SheetsScopes.SPREADSHEETS );

    static {
        try {
            HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();
            DATA_STORE_FACTORY = new FileDataStoreFactory(DATA_STORE_DIR);
        } catch (Throwable t) {
            t.printStackTrace();
            System.exit(1);
        }
    }

    /**
     * Creates an authorized Credential object.
     * @return an authorized Credential object.
     * @throws IOException
     */
    public static Credential authorize() throws IOException {
        // Load client secrets.
        // Location where local client_secret resides
        //InputStream in = new FileInputStream("C:\\Users\\daniel\\eclipse-workspace\\csc-131\\src\\main\\resources\\client_secret.json");
        InputStream in = SheetsQuickstart.class.getResourceAsStream("/client_secret.json");
        GoogleClientSecrets clientSecrets =
            GoogleClientSecrets.load(JSON_FACTORY, new InputStreamReader(in));

        // Build flow and trigger user authorization request.
        GoogleAuthorizationCodeFlow flow =
                new GoogleAuthorizationCodeFlow.Builder(
                        HTTP_TRANSPORT, JSON_FACTORY, clientSecrets, SCOPES)
                .setDataStoreFactory(DATA_STORE_FACTORY)
                .setAccessType("offline")
                .build();
        Credential credential = new AuthorizationCodeInstalledApp(
            flow, new LocalServerReceiver()).authorize("user");
        System.out.println(
                "Credentials saved to " + DATA_STORE_DIR.getAbsolutePath());
        return credential;
    }

    /**
     * Build and return an authorized Sheets API client service.
     * @return an authorized Sheets API client service
     * @throws IOException
     */
    public static Sheets getSheetsService() throws IOException {
        Credential credential = authorize();
        return new Sheets.Builder(HTTP_TRANSPORT, JSON_FACTORY, credential)
                .setApplicationName(APPLICATION_NAME)
                .build();
    }

    /*public static void updateSheet() throws IOException {
        // Build a new authorized API client service.
        Sheets service = getSheetsService();

        // Prints the names and majors of students in a sample spreadsheet:
        // https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit
        // Todo: change this text to have your own spreadsheetID
        String spreadsheetId = "1DSdEQJlA6NaHlE0i0VpPRVk40wsH663UOt5TMBdliMc";
 
        // Create requests object
        List<Request> requests = new ArrayList<>();

        // Create values object
        List<CellData> values = new ArrayList<>();
        
        // Add string 5/28/2018 value
        values.add(new CellData()
                .setUserEnteredValue(new ExtendedValue()
                        .setStringValue(("5/28/2018"))));

        // Prepare request with proper row and column and its value
        requests.add(new Request()
                .setUpdateCells(new UpdateCellsRequest()
                        .setStart(new GridCoordinate()
                                .setSheetId(0)
                                .setRowIndex(0)     // set the row to row 0 
                                .setColumnIndex(6)) // set the new column 6 to value 5/28/2018 at row 0
                        .setRows(Arrays.asList(
                                new RowData().setValues(values)))
                        .setFields("userEnteredValue,userEnteredFormat.backgroundColor")));
        
         BatchUpdateSpreadsheetRequest batchUpdateRequest = new BatchUpdateSpreadsheetRequest()
     	        .setRequests(requests);
     	service.spreadsheets().batchUpdate(spreadsheetId, batchUpdateRequest)
     	        .execute();
     	
     	List<CellData> valuesNew = new ArrayList<>();
         // Add string 5/28/2018 value
         valuesNew.add(new CellData()
                 .setUserEnteredValue(new ExtendedValue()
                         .setStringValue(("Yes"))));

         // Prepare request with proper row and column and its value
         requests.add(new Request()
                 .setUpdateCells(new UpdateCellsRequest()
                         .setStart(new GridCoordinate()
                                 .setSheetId(0)
                                 .setRowIndex(1)     // set the row to row 1 
                                 .setColumnIndex(6)) // set the new column 6 to value "yes" at row 1
                         .setRows(Arrays.asList(
                                 new RowData().setValues(valuesNew)))
                         .setFields("userEnteredValue,userEnteredFormat.backgroundColor")));        
         BatchUpdateSpreadsheetRequest batchUpdateRequestNew = new BatchUpdateSpreadsheetRequest()
     	        .setRequests(requests);
     	service.spreadsheets().batchUpdate(spreadsheetId, batchUpdateRequestNew)
     	        .execute();        
    
    }*/
    
    private static void getInstructorFields() throws IOException {
    	// Build a new authorized API client service.
    	Sheets service = getSheetsService();
    	
    	// Get instructor info from specified cells in Google Spreadsheet
    	List<String> ranges = Arrays.asList("C2","C3");
    	BatchGetValuesResponse readResult = service.spreadsheets().values()
    			.batchGet(SPREADSHEET_ID)
    			.setRanges(ranges)
    			.execute();
    	ValueRange instructorUsernameRange = readResult.getValueRanges().get(0);
    	ValueRange instructorPasswordRange = readResult.getValueRanges().get(1);
    	INSTRUCTOR_USERNAME = (String) instructorUsernameRange.getValues().get(0).get(0);
    	INSTRUCTOR_PASSWORD = (String) instructorPasswordRange.getValues().get(0).get(0);
    }
    
    public static void postKey() throws IOException {
    	// Build a new authorized API client service.
    	Sheets service = getSheetsService();
    	
    	// Create requests object
    	List<Request> requests = new ArrayList<>();
    	
    	// Create values object
    	List <CellData> values = new ArrayList<>();
    	
    	// Get value of Instructor's username and password if undefined
    	if(INSTRUCTOR_USERNAME == null || INSTRUCTOR_PASSWORD == null) {
    		getInstructorFields();
    	}
    	
    	//Add instuctorUsername
    	values.add(new CellData()
    			.setUserEnteredValue(new ExtendedValue()
    					.setStringValue(INSTRUCTOR_USERNAME)));
    	
    	requests.add(new Request()
        		.setUpdateCells(new UpdateCellsRequest()
        				.setStart(new GridCoordinate()
        						.setSheetId(0)
        						.setRowIndex(5)
        						.setColumnIndex(0))
        				.setRows(Arrays.asList(
        						new RowData().setValues(values)))
        				.setFields("userEnteredValue,userEnteredFormat.backgroundColor")));
        
         BatchUpdateSpreadsheetRequest batchUpdateReq = new BatchUpdateSpreadsheetRequest()
        		 .setRequests(requests);
        service.spreadsheets().batchUpdate(SPREADSHEET_ID, batchUpdateReq).execute();
    		
    }

    public static void updateSheet() throws IOException {
        // Build a new authorized API client service.
        Sheets service = getSheetsService();

        // spreadsheetID for our Google spreadsheet
        //String spreadsheetId = "1DSdEQJlA6NaHlE0i0VpPRVk40wsH663UOt5TMBdliMc";
 
        // Create requests object
        List<Request> requests = new ArrayList<>();

        // Create values object
        List<CellData> values = new ArrayList<>(); 
        
        // Get value of UniqueClassKey        
        List<String> ranges = Arrays.asList("C1");
        BatchGetValuesResponse readResult = service.spreadsheets().values()
        		.batchGet(SPREADSHEET_ID)
        		.setRanges(ranges)
        		.execute();
        ValueRange classKeyRange = readResult.getValueRanges().get(0);
        String classKey = (String) classKeyRange.getValues().get(0).get(0);
        
        // Get value of studentId
        if(classKey.equals("8675309")) {
        //service.spreadsheets().values().get(spreadsheetId, "Sheet1!A1:A1").execute();
        //String a1 = result.getValues().get(0).get(0).toString();
        
        // Add string value from a1 to another cell
        values.add(new CellData()
        		.setUserEnteredValue(new ExtendedValue()
        				.setStringValue("Shit")));
        
        // Prepare request with new row/column and its value
        requests.add(new Request()
        		.setUpdateCells(new UpdateCellsRequest()
        				.setStart(new GridCoordinate()
        						.setSheetId(0)
        						.setRowIndex(5)
        						.setColumnIndex(0))
        				.setRows(Arrays.asList(
        						new RowData().setValues(values)))
        				.setFields("userEnteredValue,userEnteredFormat.backgroundColor")));
        
         BatchUpdateSpreadsheetRequest batchUpdateReq = new BatchUpdateSpreadsheetRequest()
        		 .setRequests(requests);
        service.spreadsheets().batchUpdate(SPREADSHEET_ID, batchUpdateReq).execute();
        
        List<CellData> valuesTwo = new ArrayList<>();
        
        // Add string 5/28/2018 value
        valuesTwo.add(new CellData()
                .setUserEnteredValue(new ExtendedValue()
                        .setStringValue(("5/30/2018"))));

        // Prepare request with proper row and column and its value
        requests.add(new Request()
                .setUpdateCells(new UpdateCellsRequest()
                        .setStart(new GridCoordinate()
                                .setSheetId(0)
                                .setRowIndex(6)     // set the row to row 0 
                                .setColumnIndex(6)) // set the new column 6 to value 5/28/2018 at row 0
                        .setRows(Arrays.asList(
                                new RowData().setValues(valuesTwo)))
                        .setFields("userEnteredValue,userEnteredFormat.backgroundColor")));
        
         BatchUpdateSpreadsheetRequest batchUpdateRequest = new BatchUpdateSpreadsheetRequest()
     	        .setRequests(requests);
     	service.spreadsheets().batchUpdate(SPREADSHEET_ID, batchUpdateRequest)
     	        .execute();
     	
     	List<CellData> valuesNew = new ArrayList<>();
         // Add yes value
         valuesNew.add(new CellData()
                 .setUserEnteredValue(new ExtendedValue()
                         .setStringValue(("Yes"))));

         // Prepare request with proper row and column and its value
         requests.add(new Request()
                 .setUpdateCells(new UpdateCellsRequest()
                         .setStart(new GridCoordinate()
                                 .setSheetId(0)
                                 .setRowIndex(7)     // set the row to row 1 
                                 .setColumnIndex(6)) // set the new column 6 to value "yes" at row 1
                         .setRows(Arrays.asList(
                                 new RowData().setValues(valuesNew)))
                         .setFields("userEnteredValue,userEnteredFormat.backgroundColor")));        
         BatchUpdateSpreadsheetRequest batchUpdateRequestNew = new BatchUpdateSpreadsheetRequest()
     	        .setRequests(requests);
     	service.spreadsheets().batchUpdate(SPREADSHEET_ID, batchUpdateRequestNew)
     	        .execute(); 
        }
    
    }

}
