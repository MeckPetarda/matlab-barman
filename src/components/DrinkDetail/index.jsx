import { Component } from "react";
import PropTypes from "prop-types";

import Images from "../Img";
import DataControll from "../../utils/DataControll";

import style from "./style.module.scss";

/**
 * @augments {Component<Props, State>}
 */
export default class DrinkDetail extends Component {
  static propTypes = {
    menu: PropTypes.arrayOf(
      PropTypes.shape({
        name: PropTypes.string,
        gCode: PropTypes.string,
      })
    ),
    index: PropTypes.number,
  };

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
            onClick={() => DataControll.sendSignal("returnToMenu")}
          >
            Cancel
          </button>
          <button
            className={style.continueButton}
            onClick={() => DataControll.sendSignal("beginDrink")}
          >
            Continue
          </button>
        </div>
      </div>
    );
  }
}
