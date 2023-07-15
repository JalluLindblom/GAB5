
import React from 'react';
import ReactDOM from 'react-dom/client';

import TrialDataPage from './components/TrialDataPage';
import UserDataPage from './components/UserDataPage';

function renderComponents(selector, element, getProps=undefined) {
    $(selector).each(function() {
        ReactDOM.createRoot(this).render(React.createElement(element, getProps ? getProps(this) : undefined));
    });
}

$(function() {
    
    renderComponents('.TrialDataPage-container', TrialDataPage);
    renderComponents('.UserDataPage-container', UserDataPage);

});
