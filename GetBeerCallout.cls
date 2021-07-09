//this should probably be made asynchronous because we are limited to one request per second by the API
public with sharing class GetBeerCallout{
    public static String fillfridge(){
        List<Beer__c> fridge = new List<Beer__c>();
        integer tries=0;    
        //I guess technically this could be a while loop
        for(Integer fullfridge = 0; fullfridge<30;){
            HttpResponse response = makecallout();
            // If the request is successful, parse the JSON response.
            if (response.getStatusCode() == 200) {
                List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
                for(Object item : results){    
                    Map<String,Object> fld = (Map<String,Object>)item;
                    Beer__c newBeer = new Beer__c();
                    newBeer.External_ID__c = String.valueOf(fld.get('id'));
                    newBeer.Name = (String)fld.get('name');
                    newBeer.Tagline__c = (String)fld.get('tagline');
                    newBeer.Description__c = (String)fld.get('description');
                    //if the beer doesn't already exist in the database AND its not already in the 'fridge', go ahead and add it and increment full fridge
                    //I could move this select statement outside of the loop, put the Id's in an ID list then just do a contains; check
                    if ([SELECT External_ID__c FROM Beer__c WHERE External_ID__c = :newBeer.External_ID__c].size() == 0 && !(fridge.contains(newBeer))){
                        fridge.add(newbeer);
                        fullfridge++;
                    }
                    else {
                        tries++;
                    }
                }
            }
            else {
                return 'Status code was not 200, something went wrong with your request';
            }
            if(tries>=50){
                return 'Too many tries! Tried 50 times and couldn\'t fill your fridge! You may have all the beers.';
            }
            else if(fullfridge==30) {
                insert fridge;
                break;
            }
        }
        return 'Fridge filled with 30 beers!';
    }
    //I don't think I'll need this bc we cant do other stuff until we get the response;
    /*@future(callout=true)
    public static void makecalloutasync(){
        HttpResponse response = makecallout();
    }*/
    public static HttpResponse makecallout(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.punkapi.com/v2/beers/random');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        return response;
    }
}