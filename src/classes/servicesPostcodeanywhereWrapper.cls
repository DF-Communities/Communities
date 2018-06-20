/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Batch APEX Class to wrap a call to the post code webservice.
 *  Author  : Lakshmi Rajendram
 *  Date    : 05-09-2016
 *  Version : 0.1 Unit Test
 *
 *  Description:    Batch APEX Class to wrap a call to the post code webservice.
 *                  
 *  Modification History
 *  Date            Who         Description 
 *  
 *                          
*******************************************************************************************/


global class servicesPostcodeanywhereWrapper{


Public String Constituency {get;set;}
Public String Local_Authority {get;set;}
Public String Primary_Care_Trust {get;set;}
Public String Ward {get;set;}
Public String Clinical_Commissioning_Group {get;set;}
Public Integer Easting {get;set;}
Public Integer Northing {get;set;}
Public Decimal  Latitude {get;set;}
Public Decimal Longitude {get;set;}
Public Boolean bValidPostcode {get;set;}
Public String CCG_Region_Name { get;set; }
Public String CCG_Area_Name { get;set; }
Public String LSOA_Name { get;set; }
Public String Lea_Name { get;set; }
Public String Strategic_Health_Authority { get;set; }
Public String Country_Name { get;set; }
Public String County_Name { get;set; }
Public String District_Name { get;set; }
Public String Government_Office_Name { get;set; }
public String MSOA_Name { get;set; }

public servicesPostcodeanywhereWrapper(String pPostCode){
    String key = 'TR79-FY95-YB55-GE89';
    String userName = 'Alzheimers';
    servicesPostcodeanywhereCoUk.WebServiceSoap ws = new servicesPostcodeanywhereCoUk.WebServiceSoap();

    //if(!Test.isRunningTest()){
                try {
                    servicesPostcodeanywhereCoUk.ArrayOfResults ws_response = ws.RetrieveByPostcode(key, pPostcode, userName);
                    system.debug('RESPONSE '+ws_response );
                    for ( servicesPostcodeanywhereCoUk.Results result : ws_response.Results ) {
                            system.debug('result from PCA - '  + pPostcode);
                            Constituency =result.WestminsterConstituencyName;
                            Local_Authority=result.DistrictName;
                            Primary_Care_Trust=result.NhsPctName;
                            Ward=result.WardName;
                            Clinical_Commissioning_Group=result.CCGname;
                            Easting =result.Easting;
                            Northing =result.Northing;
                            Latitude=result.Latitude;
                            Longitude=result.Longitude;
                            bValidPostcode =true;
                            Strategic_Health_Authority=result.NhsShaName;
                            Government_Office_Name =result.GovernmentOfficeName;
                            District_Name=result.DistrictName;
                            County_Name=result.CountyName;
                            Country_Name=result.CountryName;
                            Lea_Name =result.LeaName;
                            LSOA_Name=result.LSOAName;
                            CCG_Area_Name = result.CCGAreaName;
                            CCG_Region_Name = result.CCGRegionName;
                            MSOA_Name =result.MSOAName;
                    }
               } 
               catch (exception x)
               {
                    System.debug('Exception from webservice');
                    bValidPostcode =false;
                    Constituency ='';
                    Local_Authority='';
                    Primary_Care_Trust='';
                    Ward='';
                    Clinical_Commissioning_Group='';
                    Easting =null;
                    Northing =null;
                    Latitude=null;
                    Longitude=null;
                    Strategic_Health_Authority=null;
                    Government_Office_Name=null;
                    District_Name=null;
                    County_Name=null;
                    Country_Name=null;
                    Lea_Name=null;
                    LSOA_Name=null;
                    CCG_Area_Name = null;
                    CCG_Region_Name = null;
                    MSOA_Name = null;
    
               }
       
    

    }
}