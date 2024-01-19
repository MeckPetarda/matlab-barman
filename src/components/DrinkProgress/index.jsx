import { Component } from "react";
import PropTypes from "prop-types";

import DataControll from "../../utils/DataControll";

import style from "./style.module.scss";

/**
 * @augments {Component<Props, State>}
 */
export default class DrinkProgress extends Component {
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
    const { menu, index, progress } = this.props;

    return (
      <div className={style.wrapper}>
        {progress && (
          <>
            <h1>{`Making ${menu[index].name}`}</h1>
            <h2>{`${progress.message} (${progress.progress}/${progress.total})`}</h2>
            <progress max={progress.total} min={0} value={progress.progress} />
          </>
        )}
        <button onClick={() => DataControll.sendSignal("returnToMenu")}>
          Cancel
        </button>
      </div>
    );
  }
}
