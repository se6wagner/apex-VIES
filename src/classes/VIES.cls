/**
 * API for validating VAT Ids against VIES WebService
 */
public class VIES {

	/**
	 * Returns intieger indicating if a VAT ID is valid or not
	 *
	 * 0 = validation failed
	 * 1 = valid
	 * 2 = invalid
	 */
	public static Integer isValidVATID(String vatID){
		return isValidVATID(checkVAT(vatID));
	}

	public static Integer isValidVATID(String countryCode, String vatNumber){
		return isValidVATID(checkVAT(countryCode,vatNumber));				
	}

	public static Integer isValidVATID(VATCheck check){

		VATCheck toCheck = check.statusCode == VIES.CHECK_STATUS_CODE.PENDING
				? check.checkVAT()
				: check;

		return toCheck.statusCode == VIES.CHECK_STATUS_CODE.FAILED
				? 0
				: (toCheck.isValid
					? 1
					: 2
					);
	}


	public static VATCheck checkVAT(String vatID){

		VATCheck result = new VATCheck();
		result.vatId = vatId;
		return result.checkVAT();
	}


	public static VATCheck checkVAT(String countryCode, String vatNumber){

		VATCheck result = new VATCheck();
		result.countryCode = countryCode.trim();
		result.vatNumber = vatNumber.trim();
		result.checkVAT();
		return result.checkVAT();

	}


	public static String getCountryCode(String vatID){
		return vatID.trim().substring(0,2);
	}
	
	public static String getVATnumber(String vatID){
		return vatID.trim().substring(2,vatID.trim().length());
	}


	/**
	 * Status codes for VATCheck objects
	 */
	public enum CHECK_STATUS_CODE {
		PENDING,
		COMPLETED,
		FAILED
	}


	/**
	 * Wrapper class 
	 */
	public class VATCheck {

		public VATCheck(){
			this.statusCode = VIES.CHECK_STATUS_CODE.PENDING;
			this.statusMessage = '';
		}

		// WEB SERVICE PARAMS
		public String vatID {get;set;}
		public String countryCode {get;set;}
		public String vatNumber {get;set;}

		// WEB SERVICE RESPONSE
		public Boolean isValid {get;set;}
		public Date requestDate {get;set;}
		public String name {get;set;}
		public String address {get;set;}

		// CHECK STATUS
		public VIES.CHECK_STATUS_CODE statusCode {get;private set;}
		public VIESService.ERROR_CODE errorCode {get;private set;}
		public String statusMessage {get;private set;}


		public VATCheck checkVAT(){

			try {

				VIESTypes.CheckResponse resp;
				resp = vatID != null
						? new VIESService().checkVAT(this.vatID.trim())
						: new VIESService().checkVAT(this.countryCode,this.vatNumber);

				this.isValid = resp.valid;
				this.requestDate = resp.requestDate;
				this.name = resp.name;
				this.address = resp.address;
				this.statusCode = CHECK_STATUS_CODE.COMPLETED;

			} catch(VIESException ex){

				this.statusCode = CHECK_STATUS_CODE.FAILED;
				this.errorCode = VIESService.ERROR_CODE.INVALID_INPUT;
				this.statusMessage = ex.getMessage();

			} catch(Exception ex){

				this.statusMessage =  ex.getTypeName() + '\n' 
									+ ex.getMessage();

				this.errorCode = VIESService.getErrorCode(this.statusMessage);
				// Invalid input inidcates there's something wrong the VAT Numer
				this.isValid = this.errorCode == VIESservice.ERROR_CODE.INVALID_INPUT
								? false
								: null;

				this.statusCode = this.isValid == null
							? CHECK_STATUS_CODE.FAILED
							: CHECK_STATUS_CODE.COMPLETED;
			}

			return this;
		}
	}
}