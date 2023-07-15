
import React from 'react';

import * as api from '../serverApi';

interface ITrialDataFiltersProps {
    headers: string[],
    initialFilters: { [k:string]: string },
}

interface ITrialDataFiltersState {
    filters: { [k:string]: string },
}

export default class TrialDataFilters extends React.Component<ITrialDataFiltersProps, ITrialDataFiltersState> {

    constructor(props: ITrialDataFiltersProps) {
        super(props);
        this.state = {
            filters: props.initialFilters,
        };
    }

    asyncSetState<K extends keyof ITrialDataFiltersState>(state: Pick<ITrialDataFiltersState, K>): Promise<void> {
        return new Promise((resolve, reject) => {
            this.setState(state, resolve);
        });
    }

    handleFilterChanged(header: string, value: string) {
        const copiedFilters = JSON.parse(JSON.stringify(this.state.filters));
        copiedFilters[header] = value;
        this.setState({ filters: copiedFilters });
    }

    handleClearFiltersClicked() {
        this.setState({ filters: {} });
    }

    render(): React.ReactNode {

        return <div className='TrialDataFilters'>

            <div className='TrialDataFilters-form'>
                <table>
                    <thead>
                        <tr>
                            <td>Variable name</td>
                            <td>Regex filter</td>
                        </tr>
                    </thead>
                    <tbody>
                    {this.props.headers.map(header => <tr key={header}>
                        <td>
                            <label htmlFor=''>{header}</label>
                        </td>
                        <td>
                            <input
                                type='text'
                                value={this.state.filters[header] || ''}
                                onChange={e => this.handleFilterChanged(header, e.target.value)}
                                placeholder='(no filter)'
                            />
                        </td>
                    </tr>)}
                    </tbody>
                </table>
            </div>

            <div className='TrialDataFilters-buttons'>
                <a href={api.makeTrialsPageUrl(this.state.filters)}>
                    <input
                        type='button'
                        value='Apply filters'
                    />
                </a>
                <input
                    type='button'
                    value='Clear filters'
                    onClick={() => this.handleClearFiltersClicked()}
                />
            </div>

        </div>;
    }
}
