
const varNamePrefix = "APP_";

/**
 * @param {String} varName
 * @param {Boolean} defaultValue
 * @returns {Boolean}
 */
export function getBoolEnvVar(varName: string, defaultValue: boolean): boolean {
    const fullVarName = varNamePrefix + varName;
    const value = process.env[fullVarName];
    if (value === undefined || value === null) {
        return defaultValue;
    }
    if (typeof value === "boolean") {
        return value;
    }
    if (typeof value === "string") {
        if (value.trim().toLowerCase() === "true") {
            return true;
        }
        if (value.trim().toLowerCase() === "false") {
            return false;
        }
    }
    console.warn(`Can't parse the value of environment variable ${fullVarName} into a boolean. Using the default value "${defaultValue}".`);
    return defaultValue;
}

/**
 * @param {String} varName
 * @param {String} defaultValue
 * @returns {String}
 */
export function getStringEnvVar(varName: string, defaultValue: string): string {
    const fullVarName = varNamePrefix + varName;
    const value = process.env[fullVarName];
    if (value === undefined || value === null) {
        return defaultValue;
    }
    if (typeof value === "string") {
        return value;
    }
    console.warn(`Can't parse the value of environment variable ${fullVarName} into a string. Using the default value "${defaultValue}".`);
    return defaultValue;
}

/**
 * @param {String} varName
 * @param {Number} defaultValue
 * @returns {Number}
 */
export function getIntEnvVar(varName:string , defaultValue: number): number {
    const fullVarName = varNamePrefix + varName;
    const value = process.env[fullVarName];
    if (value === undefined || value === null) {
        return defaultValue;
    }
    if (typeof value === "number") {
        return value;
    }
    if (typeof value === "string") {
        try {
            return parseInt(value);
        }
        catch {
            // That's ok
        }
    }
    console.warn(`Can't parse the value of environment variable ${fullVarName} into an integer. Using the default value "${defaultValue}".`);
    return defaultValue;
}
