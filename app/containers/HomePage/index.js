import React from 'react';
import { FormattedMessage } from 'react-intl';
import messages from './messages';
import Basim from 'components/Basim';
import classes from './style.scss'

import classNamesBind from 'classnames/bind';
var classNames = classNamesBind.bind(classes);

export default class HomePage extends React.PureComponent { // eslint-disable-line react/prefer-stateless-function
  render() {
    return (
      <div className={classNames("homepageContainer")}>
        <Basim />
      </div>
    );
  }
}
