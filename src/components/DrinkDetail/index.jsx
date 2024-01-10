import React, { Component } from "react";
import Images from "../Img";
import DataControll from "../../utils/DataControll";

import style from "./style.module.scss";

export default class DrinkDetail extends Component {
  render() {
    return (
      <div className={style.wrapper}>
        <div className={style.infoWrapper}>
          <div>
            <h1>{this.props.menu[this.props.index].name}</h1>
            <span>Please place the cup in the displenser cavity</span>
          </div>
          <Images index={this.props.index} />
        </div>
        <div className={style.buttonWrapper}>
          <button
            className={style.backButton}
            onClick={(e) => DataControll.sendSignal("returnToMenu")}
          >
            Cancel
          </button>
          <button
            className={style.continueButton}
            onClick={(e) => DataControll.sendSignal("beginDrink")}
          >
            Continue
          </button>
        </div>
      </div>
    );
  }
}
