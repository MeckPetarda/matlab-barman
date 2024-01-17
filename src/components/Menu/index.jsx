import React, { Component } from "react";
import DataControll from "../../utils/DataControll";

import style from "./style.module.scss";
import Images from "../Img";

export default class Menu extends Component {
  render() {
    return (
      <div className={style.wrapper}>
        {this.props.menu.map((row, index) => (
          <button
            className={style.button}
            onClick={(e) => DataControll.sendSignal("selectDrink", row.name)}
          >
            <Images index={index} />
            <span>{row.name}</span>
          </button>
        ))}
      </div>
    );
  }
}
