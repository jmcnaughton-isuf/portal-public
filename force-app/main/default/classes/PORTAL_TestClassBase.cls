public abstract class PORTAL_TestClassBase {
    public User thisUser;
    public PORTAL_TestClassBase() {
        thisUser = [SELECT Id,Name FROM User WHERE ID = :UserInfo.getUserId()];

        System.runAs(thisUser){
            insert new ucinn_ascendv2__Bypass_Settings__c(SetupOwnerId = UserInfo.getOrganizationId(),
                                                          ucinn_ascendv2__Bypass_Process_Builders__c = true,
                                                          ucinn_ascendv2__Bypass_Triggers__c = true,
                                                          ucinn_ascendv2__Bypass_Validation_Rules__c = true,
                                                          ucinn_ascendv2__Bypass_Workflows__c = true);

            UserRole usrRole = new UserRole(Name = 'ascendUserRole');
            insert usrRole;

            thisUser.UserRoleId = usrRole.Id;
            update thisUser;
        }

    }
}