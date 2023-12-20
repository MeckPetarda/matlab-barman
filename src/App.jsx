import React, { Component } from "react";
import Counter from "./components/Counter";
import { createRef } from "react";
import DataControll from "./utils/DataControll";
import Menu from "./components/Menu";

export default class App extends Component {
  mainRef = createRef();

  componentDidMount() {
    document.addEventListener("setData", this._handleDataChange);

    document.addEventListener("setMenu", this._handleMenuChange);

    document.addEventListener("setView", this._handleViewChange);
  }

  state = { count: 0, view: "DRINK_SELECT" };

  _handleDataChange = (e) => {
    if (!e?.detail?.count) return;

    this.setState({ count: e.detail.count });
  };

  _handleMenuChange = (e) => {
    this.setState({ menu: JSON.parse(e.detail) });
  };

  _handleViewChange = (e) => {
    let data = JSON.parse(e.detail);

    this.setState({ view: data.view });

    switch (data.view) {
      case "PLACE_CUP":
        this.setState({ mixingDrink: data.drinkName });
        break;

      case "DRINK_SELECT":
        break;

      case "DRINK_PROGRESS":
        break;

      default:
        break;
    }
  };

  render() {
    switch (this.state.view) {
      case "DRINK_SELECT":
        return this.state.menu && <Menu menu={this.state.menu} />;

      case "PLACE_CUP":
        return (
          <div>
            <button onClick={(e) => DataControll.sendSignal("returnToMenu")}>
              Cancel
            </button>
            <h1>{this.state.mixingDrink}</h1>
            <span>Please place the cup in the displenser cavity</span>
            <button onClick={(e) => DataControll.sendSignal("beginDrink")}>
              Continue
            </button>
          </div>
        );

      case "DRINK_PROGRESS":
        return (
          <div>
            <button onClick={(e) => DataControll.sendSignal("returnToMenu")}>
              Cancel
            </button>
            <h1>{this.state.mixingDrink}</h1>
            <span>WIP</span>
          </div>
        );

      default:
        break;
    }
  }
}
