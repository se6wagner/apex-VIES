@isTest
private class VIESTest {

	static final String countryCode = 'DE';
	static final String vatNumber = '812639372';
	static final String vatID = 'DE812639372';


	private static testMethod void checkVATID(){

		VIES.VATCheck result = VIES.checkVAT(vatID);
		system.assertEquals(true,result.isValid);

	}

	private static testMethod void checkVATNumber(){

		VIES.VATCheck result = VIES.checkVAT(countryCode,vatNumber);
		system.assertEquals(VIES.CHECK_STATUS_CODE.COMPLETED,result.status);
		system.assertEquals(true,result.isValid);

	}


	private static testMethod void splitVATId(){

		Map<String,String> map_x = VIES.splitVATID(vatID);
		system.assertEquals(countryCode,map_x.get('countryCode'));
		system.assertEquals(vatNumber,map_x.get('vatNumber'));

	}

}