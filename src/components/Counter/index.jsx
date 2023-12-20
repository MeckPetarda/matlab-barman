import React, { Component } from "react";

import style from "./style.module.scss";

export default class Counter extends Component {
  render() {
    return <div className={style.wrapper}>Count: {this.props.count}</div>;
  }
}
