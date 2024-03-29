import { Component } from "react";
import PropTypes from "prop-types";

import DataControll from "../../utils/DataControll";
import Images from "../Img";

import style from "./style.module.scss";

/**
 * @augments {Component<Props, State>}
 */
export default class Menu extends Component {
  static propTypes = {
    menu: PropTypes.arrayOf(
      PropTypes.shape({
        name: PropTypes.string,
        gCode: PropTypes.string,
      })
    ),
  };

  render() {
    return (
      <div className={style.wrapper}>
        {this.props.menu.map((row, index) => (
          <button
            key={row.name}
            className={style.button}
            onClick={() => DataControll.sendSignal("selectDrink", row.name)}
          >
            <Images index={index} />
            <span>{row.name}</span>
          </button>
        ))}
      </div>
    );
  }
}
