public class PORTAL_TestClassFactoryOR extends PORTAL_TestClassFactory{

    public override PORTAL_MyInformationControllerBaseTest.TestClass getMyInformationControllerBaseTestClass(){
        return new PORTAL_MyInformationControllerBaseTestOR();
    }
    
    public override PORTAL_CommunityUserControllerTest.TestClass getCommunityUserControllerTestClass(){
        return new PORTAL_CommunityUserControllerTestOR();
    }
    public override PORTAL_OnlineGivingControllerTest.TestClass getOnlineGivingControllerTestClass(){
        return new PORTAL_OnlineGivingControllerTestOR();
    }
    
    public override PORTAL_MyInformationEditCtrlBaseTest.TestClass getMyInformationEditCtrlBaseTestClass() {
        return new PORTAL_MyInformationEditCtrlBaseTestOR();
    }
}