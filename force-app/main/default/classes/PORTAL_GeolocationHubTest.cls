@isTest
global class PORTAL_GeolocationHubTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void constructorTest() {
            try {
                PORTAL_GeolocationHub.geolocationTypeOverride = 'ArcGis';
                PORTAL_GeolocationHub geolocationHub = new PORTAL_GeolocationHub();
            }
            catch (Exception e) {
            }

            try {
                PORTAL_GeolocationHub.geolocationTypeOverride = 'Google';
                PORTAL_GeolocationHub geolocationHub = new PORTAL_GeolocationHub();
            }
            catch (Exception e) {
            }

            try {
                PORTAL_GeolocationHub.geolocationTypeOverride = 'notValidAnswer';
                PORTAL_GeolocationHub geolocationHub = new PORTAL_GeolocationHub();
            }
            catch (Exception e) {
            }

        }

        public virtual void geolocateSingleLineAddressTest() {
            PORTAL_GeolocationHub geolocationHub;

            try {
                PORTAL_GeolocationHub.geolocationTypeOverride = 'Google';
                geolocationHub = new PORTAL_GeolocationHub();
            }
            catch (Exception e) {
            }

            try {
                geolocationHub.geolocateSingleLineAddress('address');
            }
            catch (Exception e) {
            }

            try {
                geolocationHub.geolocateSingleLineAddress('address', new Map<String, String>());
            }
            catch (Exception e) {
            }
        }
    }

    @isTest
    static void constructorTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGeolocationHubTestClass().constructorTest();
    }

    @isTest
    static void geolocateSingleLineAddressTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGeolocationHubTestClass().geolocateSingleLineAddressTest();
    }
}