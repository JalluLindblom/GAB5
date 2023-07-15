
import React from 'react';

import { ITrialDocument } from '../../db/models/trial';
import * as api from '../serverApi';
import * as utils from '../utils';

import TrialDataFilters from './TrialDataFilters';
import TrialDataDisplay from './TrialDataDisplay';

interface ITrialDataPageProps {
}

interface ITrialDataPageState {
    headers: string[],
    filtersFromUrl: { [k:string]: string},
    trials: ITrialDocument[],
    loading: boolean,
}

export default class TrialDataPage extends React.Component<ITrialDataPageProps, ITrialDataPageState> {

    constructor(props: ITrialDataPageProps) {
        super(props);
        this.state = {
            headers: [],
            filtersFromUrl: {},
            trials: [],
            loading: false,
        };
    }

    asyncSetState<K extends keyof ITrialDataPageState>(state: Pick<ITrialDataPageState, K>): Promise<void> {
        return new Promise((resolve, reject) => {
            this.setState(state, resolve);
        });
    }

    async componentDidMount() {
        await this.asyncSetState({ loading: true });

        const headersRes = await api.getTrialDataHeaders();
        if (headersRes.value !== null) {
            await this.asyncSetState({ headers: headersRes.value });
        }

        const urlSearchParams = new URLSearchParams(window.location.search);
        const params = Object.fromEntries(urlSearchParams.entries());
        await this.setState({ filtersFromUrl: params });

        const res = await api.getAllTrials(params);
        if (res.errorCode) {
            console.error(`Failed to get trials: ${res.errorCode}.`);
        }
        else if (res.value) {
            await this.asyncSetState({ trials: res.value });
        }
        await this.asyncSetState({ loading: false });
    }

    render(): React.ReactNode {

        if (this.state.loading) {
            return 'Loading...';
        }

        return <div className='TrialDataPage'>

            <TrialDataFilters
                initialFilters={this.state.filtersFromUrl}
                headers={this.state.headers}
            />

            <div>
                Found {this.state.trials.length} trial results with current filters.
            </div>

            <div>
                <a href={api.makeTrialsGetUrl('csv', this.state.filtersFromUrl)}>Download results as CSV</a>
                <br/>
                <a href={api.makeTrialsGetUrl('json', this.state.filtersFromUrl)}>Download results as JSON</a>
            </div>

            <TrialDataDisplay
                headers={this.state.headers}
                trials={this.state.trials}
            />
        </div>;
    }
}
