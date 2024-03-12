public inherited sharing class PORTAL_ControllerFactoryOR extends PORTAL_ControllerFactory{
    
    public override Object getCommunityUserController(){
        return new PORTAL_CommunityUserControllerBaseOR();
    }
}