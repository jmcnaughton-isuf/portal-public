public with sharing class PORTAL_XmlParser {
    DOM.XMLNode xmlPayload;

    public PORTAL_XmlParser(DOM.XMLNode xmlPayload) {
        this.xmlPayload = xmlPayload;
    }

    /**
     * @description Recursive function to parse through xml and return a value from a simple xml path, pulled directly from base ascend, remove when no longer needed
     *
     * @param xmlPath               Simple xml path where elements are nested. Ex: {'replyMessage', 'reasonCode'}, where xmlNodeToProcess is an XMLNode, replyMessage is a child of xmlNodeToProcess, and reasonCode is a child of replyMessage.
     *
     * @author Mark Johnson
     *
     * @return                      value of 'reasonCode' xmlNode in this case
     */
    public String getXMLAttribute(List<String> xmlPath) {
        return getXMLAttribute(xmlPath, xmlPayload);
    }

    /**
     * @description Recursive function to parse through xml and return a value from a simple xml path, pulled directly from base ascend, remove when no longer needed
     *
     * @param xmlPath               Simple xml path where elements are nested. Ex: {'replyMessage', 'reasonCode'}, where xmlNodeToProcess is an XMLNode, replyMessage is a child of xmlNodeToProcess, and reasonCode is a child of replyMessage.
     * @param xmlNodeToProcess      Parent XMLNode
     *
     * @author Mark Johnson
     *
     * @return                      value of 'reasonCode' xmlNode in this case
     */
    public static String getXMLAttribute(List<String> xmlPath, DOM.XMLNode xmlNodeToProcess) {
        String returnString = '';

        //Base case on success.
        if (xmlPath.size() == 0) {
            return xmlNodeToProcess.getText();

        //Base case on bad input
        } else if (xmlNodeToProcess == null || xmlNodeToProcess.getChildElements().isEmpty()) {
            return null;

        //Recursive element
        } else {
            Boolean foundNode = false;

            for (DOM.XMLNode xmlNode : xmlNodeToProcess.getChildElements()) {
                if (xmlNode.getName() == xmlPath[0]) {
                    xmlPath.remove(0);
                    foundNode = true;
                    returnString = getXMLAttribute(xmlPath, xmlNode);
                    break;
                }
            }

            if (foundNode == false) {
                return null;
            }
        }

        return returnString;
    }
}