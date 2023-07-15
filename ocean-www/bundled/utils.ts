
export function objectGetKeysRecursively(object: any, prefix: string, outKeys: string[])
{
    for (const key in object) {
        var value = object[key];
        if (typeof(value) === 'object') {
            objectGetKeysRecursively(value, key + '.', outKeys);
        }
        else {
            outKeys.push(prefix + key);
        }
    }
}

export function objectGetValueRecursively(object: any, separator: string, name: string): any
{
    const nameParts = name.split(separator);
    for (let i = 0; i < nameParts.length; ++i) {
        const namePart = nameParts[i];
        if (i == nameParts.length - 1) {
            return object[namePart];
        }
        else {
            object = object[namePart];
        }
    }
}
