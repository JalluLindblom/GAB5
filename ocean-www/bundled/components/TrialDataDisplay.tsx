
import React from 'react';

import dayjs from 'dayjs';
import localizedFormat from 'dayjs/plugin/localizedFormat';
dayjs.extend(localizedFormat);

import { ITrialDocument } from '../../db/models/trial';
import * as utils from '../utils';

interface ITrialDataFiltersProps {
    headers: string[],
    trials: ITrialDocument[],
}

interface ITrialDataFiltersState {
    showResults: boolean,
    compact: boolean,
}

export default class TrialDataFilters extends React.Component<ITrialDataFiltersProps, ITrialDataFiltersState> {

    constructor(props: ITrialDataFiltersProps) {
        super(props);
        this.state = {
            showResults: false,
            compact: false,
        };
    }

    asyncSetState<K extends keyof ITrialDataFiltersState>(state: Pick<ITrialDataFiltersState, K>): Promise<void> {
        return new Promise((resolve, reject) => {
            this.setState(state, resolve);
        });
    }

    render(): React.ReactNode {

        return <div className='TrialDataDisplay'>

            <div>
                <input
                    id='showResultsCheckbox'
                    type='checkbox'
                    checked={this.state.showResults}
                    onChange={(e) => this.setState({ showResults: e.target.checked })}
                />
                <label htmlFor='showResultsCheckbox'>Show results</label>
            </div>

            {!this.state.showResults || <div>
                <div>
                    <input
                        id='compactCheckbox'
                        type='checkbox'
                        checked={this.state.compact}
                        onChange={(e) => this.setState({ compact: e.target.checked })}
                    />
                    <label htmlFor='compactCheckbox'>Compact view</label>
                </div>

                <div>
                    <table className='TrialDataPage-trials-table'>
                        <thead>
                            <tr>
                                {this.props.headers.map(header =>
                                    <td key={header} style={{ writingMode: this.state.compact ? 'vertical-rl' : undefined }}>
                                        {header}
                                    </td>
                                )}
                            </tr>
                        </thead>
                        <tbody>
                            {this.props.trials.map(trial => <tr key={trial._id}>
                                {this.props.headers.map(header =>
                                    <td key={header} title={header}>
                                        {header === 'date' ? dayjs(trial.date).format('lll') : utils.objectGetValueRecursively(trial.data, '.', header)}
                                    </td>
                                )}
                            </tr>)}
                        </tbody>
                    </table>
                </div>
            </div>}

        </div>;
    }
}
