import React, { Component } from "react";
import DataControll from "../../utils/DataControll";

export default class Menu extends Component {
  render() {
    return (
      <table>
        {this.props.menu.map((row) => (
          <tr>
            <td>
              <button
                onClick={(e) => DataControll.sendSignal("selectDrink", row[0])}
              >
                {row[0]}
              </button>
            </td>
            <td>{row[1]}</td>
          </tr>
        ))}
      </table>
    );
  }
}
