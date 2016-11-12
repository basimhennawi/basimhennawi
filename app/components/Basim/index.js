import React from 'react';
import { injectIntl } from 'react-intl';
import messages from './messages';
import classes from './style.scss'

import classNamesBind from 'classnames/bind';
var classNames = classNamesBind.bind(classes);

export class Basim extends React.Component {
  render () {
    return (
      <div className={classNames("basimContainer")}>
        <div className={classNames("avatarContainer")}>
          <img className={classNames("avatar")} />
        </div>
        <div className={classNames("title")}>
          {this.props.intl.formatMessage(messages.title)}
        </div>
        <div className={classNames("subtitle")}>
          {this.props.intl.formatMessage(messages.subtitle)}
        </div>
      </div>
    );
  }
}

export default injectIntl(Basim);
