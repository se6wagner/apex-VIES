/**
 *
 */
public with sharing class VIESVATCheckController {

	VIES.VATCheck vatCheck;

	public VIESVATCheckController(){}


	/**
	 * VATcheck getter
	 */
	public VIES.VATCheck getVATCheck(){

		if(vatCheck == null){
			vatCheck = new VIES.VATCheck();
		}
		return vatCheck;
	}

	public String getStatus(){
		return getVATCheck().statusCode.name();
	}

	public PageReference validate(){
		getVATCheck().checkVAT();
		return null;
	}

}