export function getCookie(name) {
    let cookies = document.cookie.split(';');
    let cookieValue;

    cookies.forEach(cookie => {
        cookie = cookie.trim();
        if (cookie.indexOf(name) == 0) {
            cookieValue = cookie.substring(name.length + 1, cookie.length);
        }
    });

    return cookieValue;
}