import React from 'react';
import { FormattedMessage } from 'react-intl';
import messages from './messages';
import Basim from 'components/Basim';
import Social from 'components/Social';

export default class HomePage extends React.PureComponent { // eslint-disable-line react/prefer-stateless-function
  render() {
    return (
      <div>
        <Basim />
        <Social />
      </div>
    );
  }
}
