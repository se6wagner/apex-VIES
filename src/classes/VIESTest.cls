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
		system.assertEquals(VIES.CHECK_STATUS_CODE.COMPLETED,result.statusCode);
		system.assertEquals(true,result.isValid);

	}

	private static testMethod void isValidVAT_check(){
		VIES.VATCheck result = new VIES.VATCheck();
		system.assertEquals(0, VIES.isValidVATID(result));
	}
	private static testMethod void isValidVATID(){
		system.assertEquals(1,VIES.isValidVATID(vatID));
	}
	private static testMethod void isValidVATNumber(){
		system.assertEquals(1,VIES.isValidVATID(countryCode,vatNumber));
	}

	private static testMethod void nullInputs(){

		String null_String;

		try {
			VIESTypes.CheckResponse resp = new VIESService().checkVAT(null_String);
		} catch(Exception ex){
			system.assertEquals(true, ex instanceof VIESException);
		}

		try {
			VIESTypes.CheckResponse resp = new VIESService().checkVAT(null_String,null_String);
		} catch(Exception ex){
			system.assertEquals(true, ex instanceof VIESException);
		}
		
		try {
			VIES.VATCheck check = new VIES.VATCheck();
			check.checkVAT();
		} catch(Exception ex){
			system.assertEquals(true, ex instanceof VIESException);
		}

	}

	private static testMethod void utilTest(){
		
		system.assertEquals(countryCode,VIES.getCountryCode(vatID));
		system.assertEquals(vatNumber,VIES.getVATNumber(vatID));
		system.assertEquals(VIESService.ERROR_CODE.INVALID_INPUT,VIESService.getErrorCode('INVALID_INPUT'));
		system.assertEquals(VIESService.ERROR_CODE.UNKNOWN,VIESService.getErrorCode('UNDEFINED'));		
	}


}