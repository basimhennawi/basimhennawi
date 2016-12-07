import React from 'react';
import { injectIntl } from 'react-intl';
import Facebook from 'static/Facebook.html';
import Twitter from 'static/Twitter.html';
import Linkedin from 'static/Linkedin.html';
import Github from 'static/Github.html';
import Stackoverflow from 'static/Stackoverflow.html';
import Couchsurfing from 'static/Couchsurfing.html';
import messages from './messages';
import classes from './style.scss'

import classNamesBind from 'classnames/bind';
var classNames = classNamesBind.bind(classes);

export class Basim extends React.Component {
  render () {
    return (
      <div className={classNames("basimContainer")}>
        <div className={classNames("contentContainer")}>
          <img className={classNames("avatar")} />
          <div className={classNames("title")}>
            {this.props.intl.formatMessage(messages.title)}
          </div>
          <div className={classNames("subtitle")}>
            {this.props.intl.formatMessage(messages.subtitle)}
          </div>
        </div>
        <div className={classNames('socialContainer')}>
          <a 
            href='https://www.facebook.com/basimhennawi'
            className={classNames("icon")}
            dangerouslySetInnerHTML={{__html: Facebook }}/>
          <a 
            href='https://twitter.com/private_basim'
            className={classNames("icon")}
            dangerouslySetInnerHTML={{__html: Twitter }}/>
          <a 
            href='https://eg.linkedin.com/in/basimhennawi'
            className={classNames("icon")}
            dangerouslySetInnerHTML={{__html: Linkedin }}/>
          <a 
            href='https://github.com/basimhennawi'
            className={classNames("icon")}
            dangerouslySetInnerHTML={{__html: Github }}/>
          <a 
            href='http://stackoverflow.com/users/5433516/basim-hennawi'
            className={classNames("icon")}
            dangerouslySetInnerHTML={{__html: Stackoverflow }}/>
          <a 
            href='https://www.couchsurfing.com/people/basim-hennawi'
            className={classNames("icon")}
            dangerouslySetInnerHTML={{__html: Couchsurfing }}/>
        </div>
      </div>
    );
  }
}

export default injectIntl(Basim);
