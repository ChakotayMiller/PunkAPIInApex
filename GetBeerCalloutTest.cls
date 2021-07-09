@IsTest
private class GetBeerCalloutTest {
    @isTest 
    static void testmakecallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetBeerCalloutMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        HttpResponse response = GetBeerCallout.makecallout();
        // Verify that the response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = response.getBody();
        String expectedValue = '[{"id": 192,"name": "Punk IPA 2007 - 2010","tagline": "Post Modern Classic. Spiky. Tropical. Hoppy.","first_brewed": "04/2007","description": "Our flagship beer that kick started the craft beer revolution. This is James and Martin\'s original take on an American IPA, subverted with punchy New Zealand hops. Layered with new world hops to create an all-out riot of grapefruit, pineapple and lychee before a spiky, mouth-puckering bitter finish.","image_url": "https://images.punkapi.com/v2/192.png","abv": 6.0,"ibu": 60.0,"target_fg": 1010.0,"target_og": 1056.0,"ebc": 17.0,"srm": 8.5,"ph": 4.4,"attenuation_level": 82.14,"volume": {"value": 20,"unit": "liters"},"boil_volume": {"value": 25,"unit": "liters"},"method": {"mash_temp": [{"temp": {"value": 65,"unit": "celsius"},"duration": 75}],"fermentation": {"temp": {"value": 19.0,"unit": "celsius"}},"twist": null},"ingredients": {"malt": [{"name": "Extra Pale","amount": {"value": 5.3,"unit": "kilograms"}}],"hops": [{"name": "Ahtanum","amount": {"value": 17.5,"unit": "grams"},"add": "start","attribute": "bitter"},{"name": "Chinook","amount": {"value": 15,"unit": "grams"},"add": "start","attribute": "bitter"}],"yeast": "Wyeast 1056 - American Ale™"},"food_pairing": ["Spicy carne asada with a pico de gallo sauce","Shredded chicken tacos with a mango chilli lime salsa","Cheesecake with a passion fruit swirl sauce"],"brewers_tips": "While it may surprise you, this version of Punk IPA isn\'t dry hopped but still packs a punch! To make the best of the aroma hops make sure they are fully submerged and add them just before knock out for an intense hop hit.","contributed_by": "Sam Mason <samjbmason>"} ]';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, response.getStatusCode());
    }
    @isTest
    static void testfillfridge(){
        Test.setMock(HttpCalloutMock.class, new GetBeerCalloutMock());
        String test = GetBeerCallout.fillfridge();
        System.assertEquals('Too many tries! Tried 50 times and couldn\'t fill your fridge! You may have all the beers.', test);
    }
    @isTest
    static void testbadstatus(){
        Test.setMock(HttpCalloutMock.class, new GetBeerCalloutMockBadStatus());
        String test = GetBeerCallout.fillfridge();
        System.assertEquals('Status code was not 200, something went wrong with your request', test);
    }
    @isTest
    static void testfillfridgesuccess(){
        Test.setMock(HttpCalloutMock.class, new GetBeerCalloutMockThirtyBeers());
        //Test.startTest();
        String testresult = GetBeerCallout.fillfridge();
        //Test.stopTest();
        System.assertEquals('Fridge filled with 30 beers!', testresult);
    }
}