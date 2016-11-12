import React from 'react';
import { injectIntl } from 'react-intl';
import messages from './messages';
import classes from './style.scss'

import classNamesBind from 'classnames/bind';
var classNames = classNamesBind.bind(classes);

export class Social extends React.Component {
  render () {
    return (
      <div className={classNames('socialContainer')}>
        <a className={classNames('s-icon', 'fa', 'fa-facebook')} href='https://www.facebook.com/basimhennawi'></a>
        <a className={classNames('s-icon', 'fa', 'fa-twitter')} href='https://twitter.com/private_basim'></a>
        <a className={classNames('s-icon', 'fa', 'fa-linkedin')} href='https://eg.linkedin.com/in/basimhennawi'></a>
        <a className={classNames('s-icon', 'fa', 'fa-github')} href='https://github.com/basimhennawi'></a>
        <a className={classNames('s-icon', 'fa', 'fa-stack-overflow')} href='http://stackoverflow.com/users/5433516/basim-hennawi'></a>
      </div>
    );
  }
}

export default injectIntl(Social);
