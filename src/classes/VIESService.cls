/**
 * VIESservice provides simpliefed access to VIES VAT Number validation WebService
 * WSDL: http://ec.europa.eu/taxation_customs/vies/checkVatService.wsdl
 */
public class VIESService {

	public String endpoint_x = 'http://ec.europa.eu/taxation_customs/vies/services/checkVatService';
	public Map<String,String> inputHttpHeaders_x;
	public Map<String,String> outputHttpHeaders_x;
	public String clientCertName_x;
	public String clientCert_x;
	public String clientCertPasswd_x;
	public Integer timeout_x;
	private String[] ns_map_type_info = new String[]{'urn:ec.europa.eu:taxud:vies:services:checkVat:types', 'VIEStypes', 'urn:ec.europa.eu:taxud:vies:services:checkVat', 'VIESservice'};


	public VIESTypes.CheckResponse checkVAT(String vatID){
		if(vatID == null || vatID.length() == 0){
			throw new VIESException('VAT ID is required');
		}
		String trimmedId = vatID.trim().replaceAll(' ','');//vatID = vatID.trim();
		return checkVAT(VIES.getCountryCode(trimmedId),VIES.getVATNumber(trimmedId));
	}
	
	/**
	 * Method invoices Webservice Callout and returns VIESResponse object
	 */
	public VIESTypes.CheckResponse checkVAT(String countryCode, String vatNumber){

		if(countryCode == null || countryCode.length() == 0 || vatNumber == null || vatNumber.length() == 0){
			throw new VIESException('Country Code and VAT Number ID are required');
		}

		VIESTypes.CheckRequest request_x = new VIESTypes.CheckRequest();
		VIESTypes.CheckResponse response_x = new VIESTypes.CheckResponse();
		request_x.countryCode = countryCode.trim().replaceAll(' ','');
		request_x.vatNumber = vatNumber.trim().replaceAll(' ','');

		Map<String, VIEStypes.CheckResponse> response_map_x = new Map<String, VIEStypes.CheckResponse>{
			'response_x'=>response_x
		};

		// PRODUCTION CONTEXT
		if(!Test.isRunningTest()){

            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:ec.europa.eu:taxud:vies:services:checkVat:types',
              'checkVat',
              'urn:ec.europa.eu:taxud:vies:services:checkVat:types',
              'checkVatResponse',
              'VIESTypes.CheckResponse'}
            );

            response_x = response_map_x.get('response_x');

		// TEST CONTEXT
		} else {
			response_x = new VIESTypes.CheckResponse();
			response_x.valid = true;
			response_x.requestDate = date.today();
			response_x.name = 'TEST_CONTEXT';
		}

		return response_x;

	}

	/**
	 * Error codes the the service might cause
	 * 
	 * INVALID_INPUT - The provided CountryCode is invalid or the VAT number is empty
 	 * SERVICE_UNAVAILABLE - The SOAP service is unavailable, try again later
	 * MS_UNAVAILABLE - The Member State service is unavailable, try again later or with another Member State
	 * TIMEOUT - The Member State service could not be reach in time, try again later or with another Member State
	 * SERVER_BUSY - The service can't process your request. Try again latter.
	 * UNKNOWN - custom error code
	 */
	public enum ERROR_CODE {

		INVALID_INPUT,
		SERVICE_UNAVAILABLE, 
		MS_UNAVAILABLE,
		TIMEOUT,
		SERVER_BUSY,
		UNKNOWN
	}


	public static ERROR_CODE getErrorCode(String errorMessage){
		for(ERROR_CODE ecode : ERROR_CODE.values()){
			if(errorMessage.contains(ecode.name())) return ecode;
		}
		return ERROR_CODE.UNKNOWN;
	}
	/*
        public VIEStypes.checkVatApproxResponse_element checkVatApprox(String countryCode,String vatNumber,String traderName,String traderCompanyType,String traderStreet,String traderPostcode,String traderCity,String requesterCountryCode,String requesterVatNumber) {
            VIEStypes.checkVatApprox_element request_x = new VIEStypes.checkVatApprox_element();
            VIEStypes.checkVatApproxResponse_element response_x;
            request_x.countryCode = countryCode;
            request_x.vatNumber = vatNumber;
            request_x.traderName = traderName;
            request_x.traderCompanyType = traderCompanyType;
            request_x.traderStreet = traderStreet;
            request_x.traderPostcode = traderPostcode;
            request_x.traderCity = traderCity;
            request_x.requesterCountryCode = requesterCountryCode;
            request_x.requesterVatNumber = requesterVatNumber;
            Map<String, VIEStypes.checkVatApproxResponse_element> response_map_x = new Map<String, VIEStypes.checkVatApproxResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:ec.europa.eu:taxud:vies:services:checkVat:types',
              'checkVatApprox',
              'urn:ec.europa.eu:taxud:vies:services:checkVat:types',
              'checkVatApproxResponse',
              'VIEStypes.checkVatApproxResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    */
}