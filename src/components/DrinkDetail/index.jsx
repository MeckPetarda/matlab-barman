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
        <div>
          <div>
            <h1>{`Make ${this.props.menu[this.props.index].name}?`}</h1>
            <pre>
              {this.props.menu[this.props.index].ingredients.replace(
                /\\n/g,
                "\n"
              )}
            </pre>
          </div>
          <Images index={this.props.index} />
        </div>
        <div>
          <button onClick={() => DataControll.sendSignal("returnToMenu")}>
            Cancel
          </button>
          <button onClick={() => DataControll.sendSignal("beginDrink")}>
            Continue
          </button>
        </div>
      </div>
    );
  }
}
