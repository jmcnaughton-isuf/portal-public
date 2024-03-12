@isTest
public without sharing class PORTAL_JobBoardControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{



        public virtual void testServergetCreateJobPostingFrontEndData() {

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_JobBoardController.SERVER_getCreateJobPostingFrontEndData(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
            } catch (Exception e) {
                PORTAL_JobBoardController.SERVER_getCreateJobPostingFrontEndData(null);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = '';
            } catch (Exception e) {
                PORTAL_JobBoardController.SERVER_getCreateJobPostingFrontEndData(null);
            }
        }


        public virtual void testServergetPicklists() {

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_JobBoardController.SERVER_getPicklists(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_JobBoardController.SERVER_getPicklists(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = '';
                PORTAL_JobBoardController.SERVER_getPicklists(null);
            } catch (Exception e) {

            }

        }


        public virtual void testServersubmitJobPosting() {

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_JobBoardController.SERVER_submitJobPosting(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_JobBoardController.SERVER_submitJobPosting(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = '';
                PORTAL_JobBoardController.SERVER_submitJobPosting(null);
            } catch (Exception e) {

            }

        }


        public virtual void testServergetMyPostedJobs() {

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_JobBoardController.SERVER_getMyPostedJobs(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_JobBoardController.SERVER_getMyPostedJobs(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = '';
                PORTAL_JobBoardController.SERVER_getMyPostedJobs(null);
            } catch (Exception e) {

            }

        }


        public virtual void testServerarchiveJob() {


            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_JobBoardController.SERVER_archiveJob(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_JobBoardController.SERVER_archiveJob(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = '';
                PORTAL_JobBoardController.SERVER_archiveJob(null);
            } catch (Exception e) {

            }

        }


        public virtual void testServergetJobListing() {

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_JobBoardController.SERVER_getJobListing(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_JobBoardController.SERVER_getJobListing(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = '';
                PORTAL_JobBoardController.SERVER_getJobListing(null);
            } catch (Exception e) {

            }

        }


        public virtual void testServercreateJobApplication() {

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_JobBoardController.SERVER_createJobApplication(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_JobBoardController.SERVER_createJobApplication(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = '';
                PORTAL_JobBoardController.SERVER_createJobApplication(null);
            } catch (Exception e) {

            }

        }


        public virtual void testServersubmitJobApplication() {

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_JobBoardController.SERVER_submitJobApplication(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_JobBoardController.SERVER_submitJobApplication(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = '';
                PORTAL_JobBoardController.SERVER_submitJobApplication(null);
            } catch (Exception e) {

            }

        }

        public virtual void testServerGetJobApplicationFileUploads() {

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_JobBoardController.SERVER_getJobApplicationFileUploads(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_JobBoardController.SERVER_getJobApplicationFileUploads(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = '';
                PORTAL_JobBoardController.SERVER_getJobApplicationFileUploads(null);
            } catch (Exception e) {

            }

        }


        public virtual void testServergetMyApplications() {

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_JobBoardController.SERVER_getMyApplications(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_JobBoardController.SERVER_getMyApplications(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = '';
                PORTAL_JobBoardController.SERVER_getMyApplications(null);
            } catch (Exception e) {

            }

        }


        public virtual void testServergetJobApplicants() {

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_JobBoardController.SERVER_getJobApplicants(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_JobBoardController.SERVER_getJobApplicants(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = '';
                PORTAL_JobBoardController.SERVER_getJobApplicants(null);
            } catch (Exception e) {

            }

        }


        public virtual void testServerwithdrawApplication() {

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_JobBoardController.SERVER_withdrawApplication(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_JobBoardController.SERVER_withdrawApplication(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = '';
                PORTAL_JobBoardController.SERVER_withdrawApplication(null);
            } catch (Exception e) {

            }

        }


        public virtual void testServerchangeApplicationStatus() {

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_JobBoardController.SERVER_changeApplicationStatus(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_JobBoardController.SERVER_changeApplicationStatus(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = '';
                PORTAL_JobBoardController.SERVER_changeApplicationStatus(null);
            } catch (Exception e) {

            }
        }


        public virtual void testServergetSearchFilterPicklists() {

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_JobBoardController.SERVER_getSearchFilterPicklists(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_JobBoardController.SERVER_getSearchFilterPicklists(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = '';
                PORTAL_JobBoardController.SERVER_getSearchFilterPicklists(null);
            } catch (Exception e) {

            }

        }


        public virtual void testServersearchForJobWithFilters() {

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_JobBoardController.SERVER_searchForJobWithFilters(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_JobBoardController.SERVER_searchForJobWithFilters(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = '';
                PORTAL_JobBoardController.SERVER_searchForJobWithFilters(null);
            } catch (Exception e) {

            }

        }


        public virtual void testServergetContactInfo() {

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_JobBoardController.SERVER_getContactInfo(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_JobBoardController.SERVER_getContactInfo(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = '';
                PORTAL_JobBoardController.SERVER_getContactInfo(null);
            } catch (Exception e) {

            }

        }


        public virtual void testServerpublishDraft() {

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_JobBoardController.SERVER_publishDraft(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_JobBoardController.SERVER_publishDraft(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = '';
                PORTAL_JobBoardController.SERVER_publishDraft(null);
            } catch (Exception e) {

            }
        }
    
    }

    static testMethod void testServergetCreateJobPostingFrontEndData() {
        PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerTestClass().testServergetCreateJobPostingFrontEndData();
    }

    static testMethod void testServergetPicklists() {
        PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerTestClass().testServergetPicklists();
    }

    static testMethod void testServersubmitJobPosting() {
        PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerTestClass().testServersubmitJobPosting();
    }

    static testMethod void testServergetMyPostedJobs() {
        PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerTestClass().testServergetMyPostedJobs();
    }

    static testMethod void testServerarchiveJob() {
        PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerTestClass().testServerarchiveJob();
    }

    static testMethod void testServergetJobListing() {
        PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerTestClass().testServergetJobListing();
    }

    static testMethod void testServercreateJobApplication() {
        PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerTestClass().testServercreateJobApplication();
    }

    static testMethod void testServersubmitJobApplication() {
        PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerTestClass().testServersubmitJobApplication();
    }

    static testMethod void testServerGetJobApplicationFileUploads() {
        PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerTestClass().testServerGetJobApplicationFileUploads();
    }

    static testMethod void testServergetMyApplications() {
        PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerTestClass().testServergetMyApplications();
    }

    static testMethod void testServergetJobApplicants() {
        PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerTestClass().testServergetJobApplicants();
    }

    static testMethod void testServerwithdrawApplication() {
        PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerTestClass().testServerwithdrawApplication();
    }

    static testMethod void testServerchangeApplicationStatus() {
        PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerTestClass().testServerchangeApplicationStatus();
    }

    static testMethod void testServergetSearchFilterPicklists() {
        PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerTestClass().testServergetSearchFilterPicklists();
    }

    static testMethod void testServersearchForJobWithFilters() {
        PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerTestClass().testServersearchForJobWithFilters();
    }

    static testMethod void testServergetContactInfo() {
        PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerTestClass().testServergetContactInfo();
    }

    static testMethod void testServerpublishDraft() {
        PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerTestClass().testServerpublishDraft();
    }

    //   @isTest
//     public static void testServergetCreateJobPostingFrontEndData() {

//         try {git
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_getCreateJobPostingFrontEndData(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
//         } catch (Exception e) {
//             PORTAL_JobBoardController.SERVER_getCreateJobPostingFrontEndData(null);
//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = '';
//         } catch (Exception e) {
//             PORTAL_JobBoardController.SERVER_getCreateJobPostingFrontEndData(null);
//         }
//     }

//     @isTest
//     public static void testServergetPicklists() {

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_getPicklists(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_getPicklists(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = '';
//             PORTAL_JobBoardController.SERVER_getPicklists(null);
//         } catch (Exception e) {

//         }

//     }

//     @isTest
//     public static void testServersubmitJobPosting() {

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_submitJobPosting(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_submitJobPosting(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = '';
//             PORTAL_JobBoardController.SERVER_submitJobPosting(null);
//         } catch (Exception e) {

//         }

//     }

//     @isTest
//     public static void testServergetMyPostedJobs() {

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_getMyPostedJobs(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_getMyPostedJobs(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = '';
//             PORTAL_JobBoardController.SERVER_getMyPostedJobs(null);
//         } catch (Exception e) {

//         }

//     }

//     @isTest
//     public static void testServerarchiveJob() {


//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_archiveJob(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_archiveJob(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = '';
//             PORTAL_JobBoardController.SERVER_archiveJob(null);
//         } catch (Exception e) {

//         }

//     }

//     @isTest
//     public static void testServergetJobListing() {

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_getJobListing(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_getJobListing(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = '';
//             PORTAL_JobBoardController.SERVER_getJobListing(null);
//         } catch (Exception e) {

//         }

//     }

//     @isTest
//     public static void testServercreateJobApplication() {

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_createJobApplication(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_createJobApplication(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = '';
//             PORTAL_JobBoardController.SERVER_createJobApplication(null);
//         } catch (Exception e) {

//         }

//     }

//     @isTest
//     public static void testServersubmitJobApplication() {

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_submitJobApplication(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_submitJobApplication(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = '';
//             PORTAL_JobBoardController.SERVER_submitJobApplication(null);
//         } catch (Exception e) {

//         }

//     }

//     @isTest
//     public static void testServergetMyApplications() {

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_getMyApplications(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_getMyApplications(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = '';
//             PORTAL_JobBoardController.SERVER_getMyApplications(null);
//         } catch (Exception e) {

//         }

//     }

//     @isTest
//     public static void testServergetJobApplicants() {

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_getJobApplicants(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_getJobApplicants(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = '';
//             PORTAL_JobBoardController.SERVER_getJobApplicants(null);
//         } catch (Exception e) {

//         }

//     }

//     @isTest
//     public static void testServerwithdrawApplication() {

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_withdrawApplication(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_withdrawApplication(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = '';
//             PORTAL_JobBoardController.SERVER_withdrawApplication(null);
//         } catch (Exception e) {

//         }

//     }

//     @isTest
//     public static void testServerchangeApplicationStatus() {

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_changeApplicationStatus(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_changeApplicationStatus(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = '';
//             PORTAL_JobBoardController.SERVER_changeApplicationStatus(null);
//         } catch (Exception e) {

//         }
//     }

//     @isTest
//     public static void testServergetSearchFilterPicklists() {

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_getSearchFilterPicklists(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_getSearchFilterPicklists(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = '';
//             PORTAL_JobBoardController.SERVER_getSearchFilterPicklists(null);
//         } catch (Exception e) {

//         }

//     }

//     @isTest
//     public static void testServersearchForJobWithFilters() {

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_searchForJobWithFilters(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_searchForJobWithFilters(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = '';
//             PORTAL_JobBoardController.SERVER_searchForJobWithFilters(null);
//         } catch (Exception e) {

//         }

//     }

//     @isTest
//     public static void testServergetContactInfo() {

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_getContactInfo(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_getContactInfo(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = '';
//             PORTAL_JobBoardController.SERVER_getContactInfo(null);
//         } catch (Exception e) {

//         }

//     }

//     @isTest
//     public static void testServerpublishDraft() {

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_publishDraft(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
//             PORTAL_JobBoardController.SERVER_publishDraft(null);
//         } catch (Exception e) {

//         }

//         try {
//             PORTAL_CommunityUtils.testExceptionType = '';
//             PORTAL_JobBoardController.SERVER_publishDraft(null);
//         } catch (Exception e) {

//         }
//     }




}