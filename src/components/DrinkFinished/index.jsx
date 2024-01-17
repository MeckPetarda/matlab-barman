import { Component } from "react";
import PropTypes from "prop-types";

import Images from "../Img";
import DataControll from "../../utils/DataControll";

import style from "./style.module.scss";

/**
 * @augments {Component<Props, State>}
 */
export default class DrinkFinished extends Component {
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
        <h1>Drink finished</h1>
        <Images index={this.props.index} />
        <h2>{`Enjoy your ${this.props.menu[this.props.index].name}`}</h2>
        <button onClick={() => DataControll.sendSignal("returnToMenu")}>
          Cancel
        </button>
      </div>
    );
  }
}
