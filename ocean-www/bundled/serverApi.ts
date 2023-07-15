
import { ITrialDocument } from "../db/models/trial";
import { IUserDocument } from "../db/models/user";

export interface IApiResult<T> {
    errorCode: number|null,
    value: T|null,
}

function apiSuccess<T>(value: T): IApiResult<T> {
    return { errorCode: null, value: value };
}
function apiError<T>(errorCode: number): IApiResult<T> {
    return { errorCode: errorCode, value: null };
}

export async function getAllTrials(filterParams: {[k: string]: string}): Promise<IApiResult<ITrialDocument[]>> {
    let url = '/api/admin/trials';
    const params = new URLSearchParams(filterParams);
    if (Array.from(params.values()).length > 0) {
        url += '?' + params.toString();
    }
    const res = await fetch(url);
    if (!res.ok) {
        return apiError(res.status);
    }
    const data = await res.json();
    return apiSuccess(data);
}

export function makeTrialsPageUrl(filters: { [k:string]: string }): string {

    const params = new URLSearchParams();
    let hasParams = false;

    for (const filterKey in filters) {
        const filter = filters[filterKey];
        if (filter && filter.trim().length > 0) {
            params.append(filterKey, filter.trim());
            hasParams = true;
        }
    }

    let url = '/admin/trials';
    if (hasParams) {
        url += '?' + params.toString();
    }
    return url;
}

export function makeTrialsGetUrl(format: string, filters: { [k:string]: string }): string {

    const params = new URLSearchParams();

    params.append('format', format);

    for (const filterKey in filters) {
        const filter = filters[filterKey];
        if (filter && filter.trim().length > 0) {
            params.append(filterKey, filter.trim());
        }
    }

    let url = '/api/admin/trials?' + params.toString()
    return url;
}

export async function getTrialDataHeaders(): Promise<IApiResult<string[]>> {
    const url = '/api/admin/trial-data-headers';
    const res = await fetch(url);
    if (!res.ok) {
        return apiError(res.status);
    }
    const data = await res.json();
    return apiSuccess(data);
}

export async function getAllUsers(): Promise<IApiResult<IUserDocument[]>> {
    const url = '/api/admin/users';
    const res = await fetch(url);
    if (!res.ok) {
        return apiError(res.status);
    }
    const data = await res.json();
    return apiSuccess(data);
}

export async function createUsers(userIds: string[]): Promise<IApiResult<IUserDocument[]>> {
    const url = '/api/admin/users';
    const options = {
        method: 'POST',
        body: JSON.stringify({ userIds: userIds }),
        headers: {
            'Content-type': 'application/json; charset=UTF-8',
        },
    };
    const res = await fetch(url, options);
    if (!res.ok) {
        return apiError(res.status);
    }
    const data = await res.json();
    return apiSuccess(data);
}

export async function deleteUsers(userIds: string[]): Promise<IApiResult<null>> {
    const url = '/api/admin/users';
    const options = {
        method: 'DELETE',
        body: JSON.stringify({ userIds: userIds }),
        headers: {
            'Content-type': 'application/json; charset=UTF-8',
        },
    };
    const res = await fetch(url, options);
    if (!res.ok) {
        return apiError(res.status);
    }
    return apiSuccess(null);
}
