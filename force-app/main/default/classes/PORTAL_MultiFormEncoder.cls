public class PORTAL_MultiFormEncoder {
    //  The boundary is alligned so it doesn't produce padding characters when base64 encoded.
    private final static string Boundary = 'Boundary';

    /**
     *  Returns the request's content type for multipart/form-data requests.
     */
    public static string GetContentType() {
        return 'multipart/form-data; boundary="' + Boundary + '"';
    }

    /**
     *  Write a boundary at the end of the form's body.
     */
    public static string writeBoundary(String ending) {
        string value = '';

        value += '--' + Boundary + (ending == null ? '\r\n' : '--');

       return value;
    }

    public static String writeBodyParameter(String key, String value) {
        return 'Content-Disposition: form-data; name="' + key + '"\r\n\r\n' + value + '\r\n';
    }
}