public inherited sharing class PORTAL_AppleDomainReaderController {
    public String getContent() {
        return new PageReference('/resource/PORTAL_AppleDomainVerification').getContent().toString();
    }
}