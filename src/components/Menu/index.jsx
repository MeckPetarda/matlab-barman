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
                onClick={(e) =>
                  DataControll.sendSignal("selectDrink", row.name)
                }
              >
                {row.name}
              </button>
            </td>
            <td>{row.gCode}</td>
          </tr>
        ))}
      </table>
    );
  }
}
