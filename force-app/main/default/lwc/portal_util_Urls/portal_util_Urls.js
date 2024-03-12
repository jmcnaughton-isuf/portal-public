import communityPath from '@salesforce/community/basePath';

export const communityRootPath = communityPath.endsWith('/s') ? communityPath.slice(0, communityPath.length - 2) : communityPath;
export const communitySitePath = communityPath;
export const originURL = window.location.origin;

export function formatRelativeUrlWithRootPath(relativeUrl) {
    if (!relativeUrl || relativeUrl.startsWith('http')) {
        return relativeUrl;
    }

    return prependRelativeUrl(relativeUrl, communityRootPath);
}

export function formatRelativeUrlWithSitePath(relativeUrl) {
    if (!relativeUrl || relativeUrl.startsWith('http')) {
        return relativeUrl;
    }

    return prependRelativeUrl(relativeUrl, communitySitePath);
}

export function formatRelativeUrlWithAbsoluteUrl(relativeUrl) {
    if (!relativeUrl || relativeUrl.startsWith('http')) {
        return relativeUrl;
    }

    return prependRelativeUrl(relativeUrl, getAbsoluteCommunitySiteUrl());
}

export function getRelativeUrl() {
    return window.location.pathname;
}

export function getAbsoluteCommunitySiteUrl() {
    return originURL + communitySitePath;
}

function prependRelativeUrl(relativeUrl, path) {
    if (!relativeUrl.startsWith('/')) {
        return path + '/' + relativeUrl;
    }

    return path + relativeUrl;
}