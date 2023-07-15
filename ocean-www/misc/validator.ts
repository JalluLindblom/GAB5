
export class Validator<TValue> {

    value: TValue;
    label: string;
    valid: boolean;
    validationErrorMessages: string[];

    constructor(value: TValue, label: string) {
        this.value = value;
        this.label = label;
        this.valid = true;
        this.validationErrorMessages = [];
    }

    _error(message: string) {
        let valueStr = `${this.value}`;
        if (this.value === undefined) {
            valueStr = 'undefined';
        }
        else if (this.value === null) {
            valueStr = 'null';
        }
        else if (typeof(this.value) == 'string') {
            valueStr = `"${this.value}"`
        }
        this.validationErrorMessages.push(`${this.label}=${valueStr}: ${message}`);
    }

    isString(): Validator<TValue> {
        if (this.value === undefined || this.value === null) {
            return this;
        }
        const msg = 'Expected a string.';
        if (typeof this.value !== "string") {
            this._error(msg);
            this.valid = false;
        }
        return this;
    }

    isStringOfLength(minLength: number, maxLength: number): Validator<TValue> {
        if (this.value === undefined || this.value === null) {
            return this;
        }
        const msg = `Expected a string of length between ${minLength} and ${maxLength}`;
        if (typeof this.value !== 'string') {
            this._error(msg);
            this.valid = false;
            return this;
        }
        if (this.value.length < minLength || this.value.length > maxLength) {
            this._error(msg);
            this.valid = false;
        }
        return this;
    }

    matchesPattern(pattern: string|RegExp): Validator<TValue> {
        if (this.value === undefined || this.value === null) {
            return this;
        }
        const msg = `Expected a string that matches the pattern ${pattern}.`;
        if (typeof this.value !== 'string') {
            this.valid = false;
            this._error(msg);
            return this;
        }
        if (!(new RegExp(pattern).test(this.value))) {
            this._error(msg);
            this.valid = false;
        }
        return this;
    }

    isNumber(): Validator<TValue> {
        if (this.value === undefined || this.value === null) {
            return this;
        }
        const msg = 'Expected a number.';
        if (typeof this.value !== 'number') {
            this._error(msg);
            this.valid = false;
        }
        return this;
    }

    isNumberBetween(minValue: number, maxValue: number): Validator<TValue> {
        if (this.value === undefined || this.value === null) {
            return this;
        }
        const msg = `Expected a number between ${minValue} and ${maxValue}.`;
        if (typeof this.value !== 'number') {
            this._error(msg);
            this.valid = false;
            return this;
        }
        if (this.value < minValue || this.value > maxValue) {
            this._error(msg);
            this.valid = false;
        }
        return this;
    }

     isObject(): Validator<TValue> {
        if (this.value === undefined || this.value === null) {
            return this;
        }
        if (typeof(this.value) !== 'object') {
            this.valid = false;
            return this;
        }
        return this;
    }

    isArray(): Validator<TValue> {
        if (this.value === undefined || this.value === null) {
            return this;
        }
        const msg = 'Expected an array.';
        if (!Array.isArray(this.value)) {
            this._error(msg);
            this.valid = false;
            return this;
        }
        return this;
    }

    fulfills(condition: (value: TValue)=>boolean): Validator<TValue> {
        if (this.value === undefined || this.value === null) {
            return this;
        }
        const msg = "Value doesn't fulfill the predetermined condition.";
        if (!condition(this.value)) {
            this._error(msg);
            this.valid = false;
            return this;
        }
        return this;
    }

    isDbId(db: { isValidId(id: any): boolean }): Validator<TValue> {
        if (this.value === undefined || this.value === null) {
            return this;
        }
        const msg = 'Expected a database ID.';
        if (!db.isValidId(this.value)) {
            this._error(msg);
            this.valid = false;
        }
        return this;
    }
    
    required(): Validator<TValue> {
        const msg = 'Expected a value.';
        if (this.value === undefined || this.value === null) {
            this._error(msg);
            this.valid = false;
            return this;
        }
        return this;
    }

    /**
     * Returns the final validation result.
     * 
     * @returns True iff no validations failed.
     */
    validate(): boolean {
        for (const msg of this.validationErrorMessages) {
            console.error(msg);
        }
        return this.valid;
    }
}

/**
 * Validates all the given validators and returns
 * true only if all of them are valid.
 * 
 * @param validators
 * @returns True iff all the validators are valid.
 */
export function validateAll(validators: Validator<any>[]): boolean {
    return validators.every(v => v.validate());
}
