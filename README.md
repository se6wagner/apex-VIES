# apex-VIES #
apex-VIES is a simple force.com API for validating EU VAT IDs and Numbers against the [VAT Information Exchange System](http://ec.europa.eu/taxation_customs/vies/vieshome.do) of the European Union.

A simple UI for running the validation is provided via VIESVATCheck.page (==> VIESVATcheck.component).

**Make sure add VIES Webservice Endpoint to your remote settings (Remote Settings config is contained in the src folder)**

## HOW - TO ##
_API accepts Country Code (e.g. DE for Germany, IT for Italy, ...) and VAT number instead of the complete VAT Id as well. In addition any whitespace characters will be removed automatically as well._

	
### Integer validation ###

VIES.isValidVATID() methods return a simple integer you can use for validation. Return values


*	0 = validation failed
*	1 = valid VAT ID
*	2 = invalid VAT ID


Basic Example

	String vatID = 'DE123456789';
	Integer result = VIES.isValidVATID(String vatID);


Extended Example

	String vatID = 'DE123456789';
	Integer result = VIES.isValidVATID(String vatID);

	if(result == 0){
		// HANDLE FAILURES
	}
	if(result == 1){
		// HANDLE VALID VAT IDs
	}
	else if(result == 2){
		// HANDLE INVALID VAT IDs
	}

### Using VIES.VATCheck Data Type ###

In addition to the simple Integer validation, apex-VIES provides VIES.VATCheck data type wrapping up detailed information like Company Name & Address (if returned by the WebService), Status Codes, Messages ...

	String vatID = 'DE123456789';
	VIES.VATCheck result = VIES.checkVAT(vatID);



**Review VIESTest class for more details.**

View [VIES Webservice FAQ](http://ec.europa.eu/taxation_customs/vies/faqvies.do "FAQ") for detailled information about VIES Service