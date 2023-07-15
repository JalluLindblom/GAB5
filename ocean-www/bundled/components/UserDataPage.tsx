
import React from 'react';

import dayjs from 'dayjs';
import localizedFormat from 'dayjs/plugin/localizedFormat';
dayjs.extend(localizedFormat);

import { IUserDocument } from '../../db/models/user';
import { userIdPattern } from '../../db/user';
import * as api from '../serverApi';

interface IUserDataPageProps {
}

interface IUserDataPageState {
    loading: boolean,
    registering: boolean,
    registrationFailed: boolean,
    users: IUserDocument[],
    formUserIdsRaw: string,
    formUserIdsParsed: string[],
    invalidUserIds: string[],
    checkedUsers: Set<string>,
    deleting: boolean,
}

export default class UserDataPage extends React.Component<IUserDataPageProps, IUserDataPageState> {

    formRef: React.RefObject<HTMLFormElement>;

    constructor(props: IUserDataPageProps) {
        super(props);
        this.formRef = React.createRef();
        this.state = {
            loading: false,
            registering: false,
            registrationFailed: false,
            users: [],
            formUserIdsRaw: '',
            formUserIdsParsed: [],
            invalidUserIds: [],
            checkedUsers: new Set(),
            deleting: false,
        };
    }

    asyncSetState<K extends keyof IUserDataPageState>(state: Pick<IUserDataPageState, K>): Promise<void> {
        return new Promise((resolve, reject) => {
            this.setState(state, resolve);
        });
    }

    // async updateUsersFromServer() {
    //     await this.asyncSetState({ loading: true });
    //     const res = await api.getAllUsers();
    //     if (res.errorCode) {
    //         console.error(`Failed to get trials: ${res.errorCode}.`);
    //     }
    //     else if (res.value) {
    //         await this.asyncSetState({ users: res.value });
    //     }
    //     await this.asyncSetState({ loading: false });
    // }

    // async componentDidMount() {
    //     await this.updateUsersFromServer();
    // }

    handleFormUserIdsChanged(newValue: string) {
        const validUserIds = [];
        const invalidUserIds = [];
        for (const line of newValue.replace('\r\n', '\n').split('\n')) {
            if (line.trim().length <= 0) {
                continue;
            }
            if (!new RegExp(userIdPattern).test(line)) {
                invalidUserIds.push(line);
                continue;
            }
            validUserIds.push(line);
        }
        this.setState({ formUserIdsRaw: newValue, formUserIdsParsed: validUserIds, invalidUserIds: invalidUserIds });
    }

    async handleFormSubmitClicked() {

        if (!this.formRef.current?.reportValidity()) {
            return;
        }

        if (!confirm(`Register ${this.state.formUserIdsParsed.length} new user IDs?`)) {
            return;
        }

        await this.asyncSetState({ loading: true, registrationFailed: false });
        const res = await api.createUsers(this.state.formUserIdsParsed);
        const success = !res.errorCode;
        await this.asyncSetState({
            loading: false,
            registrationFailed: !success,
            formUserIdsRaw: '',
            formUserIdsParsed: [],
            invalidUserIds: []
        });
        if (success) {
            // await this.updateUsersFromServer();
        }
        else {
            console.log(`Registration failed: ${res.errorCode}`);
        }
    }

    handleUserChecked(userId: string, checked: boolean) {
        const copiedCheckedUsers = new Set(this.state.checkedUsers);
        if (checked) {
            copiedCheckedUsers.add(userId);
        }
        else {
            copiedCheckedUsers.delete(userId);
        }
        this.setState({ checkedUsers: copiedCheckedUsers });
    }

    async handleDeleteUsersClicked() {
        const n = this.state.checkedUsers.size;
        if (!confirm(`Are you sure you want to unregister the selected ${n} user ID(s)?\nThis will only remove their registration but the trials submitted with those user IDs will not be deleted.`)) {
            return;
        }
        await this.asyncSetState({ deleting: true });
        const res = await api.deleteUsers(Array.from(this.state.checkedUsers));
        if (res.errorCode !== null) {
            console.error(`Error: ${res.errorCode}`);
        }
        // await this.updateUsersFromServer();
        await this.asyncSetState({ deleting: false, checkedUsers: new Set() });
    }

    render(): React.ReactNode {
        return <div className='UserDataPage'>

            <div className='UserDataPage-form'>
                <div>
                    Register new user IDs:
                </div>
                <form ref={this.formRef}>
                    <div>
                        <textarea
                            value={this.state.formUserIdsRaw}
                            required
                            onChange={e => this.handleFormUserIdsChanged(e.target.value)}
                        />
                        <br/>
                        <input
                            type='button'
                            value={`Register user IDs (${this.state.formUserIdsParsed.length})`}
                            disabled={this.state.formUserIdsParsed.length <= 0 || this.state.invalidUserIds.length > 0}
                            onClick={() => this.handleFormSubmitClicked()}
                        />
                        <br/>
                        {this.state.invalidUserIds.length <= 0 || <div>
                            The following user IDs are invalid:<br/>
                            {this.state.invalidUserIds.map(userId => <div>"{userId}"</div>)}
                        </div>}
                    </div>
                    <div>
                        <div>
                            Enter one or more user IDs to be registered, each on its own line.
                        </div>
                        <div>
                            User IDs may only contain A-Z letters and digits.
                        </div>
                    </div>
                </form>
                {this.state.registrationFailed ? 'Failed' : null}
            </div>

            {/*

            <div className='UserDataPage-controls'>
                <input
                    type='button'
                    value={`Unregister selected user IDs (${this.state.checkedUsers.size})`}
                    disabled={this.state.checkedUsers.size <= 0 || this.state.deleting}
                    onClick={() => this.handleDeleteUsersClicked()}
                />
                {this.state.deleting ? 'Unregistering...' : null}
            </div>
            
            <div>
                Registered user IDs ({this.state.users.length}):
                <table className='UserDataPage-users-table'>
                    <thead>
                        <tr>
                            <td></td>
                            <td>User ID</td>
                            <td>Creation date</td>
                        </tr>
                    </thead>
                    <tbody>
                        {this.state.users.map(user => <tr key={user.userId}>
                            <td>
                                <input
                                    type='checkbox'
                                    checked={this.state.checkedUsers.has(user.userId)}
                                    onChange={(e) => this.handleUserChecked(user.userId, e.target.checked)}
                                />
                            </td>
                            <td>{user.userId}</td>
                            <td>{dayjs(user.creationDate).format('lll')}</td>
                        </tr>)}
                    </tbody>
                </table>
                </div>
                
                */}
        </div>;
    }
}
