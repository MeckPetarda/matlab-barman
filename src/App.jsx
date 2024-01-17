import { Component } from "react";
import { createRef } from "react";
import DataControll from "./utils/DataControll";
import Menu from "./components/Menu";
import DrinkDetail from "./components/DrinkDetail";
import DrinkFinished from "./components/DrinkFinished";

export default class App extends Component {
  mainRef = createRef();

  componentDidMount() {
    document.addEventListener("setData", this._handleDataChange);

    document.addEventListener("setMenu", this._handleMenuChange);

    document.addEventListener("setView", this._handleViewChange);

    document.addEventListener("setProgress", this._handleProgressChange);
  }

  state = {
    count: 0,
    view: "DRINK_SELECT",
    menu: [{ name: "test", gCode: "G10000", img: "cosmopolitan.jpg" }],
    mixingDrink: 0,
  };

  _handleDataChange = (e) => {
    if (!e?.detail?.count) return;

    this.setState({ count: e.detail.count });
  };

  _handleMenuChange = (e) => {
    this.setState({
      menu: JSON.parse(e.detail).map((e) => ({
        name: e[0],
        gCode: e[1],
      })),
    });
  };

  _handleViewChange = (e) => {
    let data = JSON.parse(e.detail);

    this.setState({ view: data.view });

    switch (data.view) {
      case "DRINK_DETAIL":
        this.setState({
          mixingDrink: this.state.menu.findIndex(
            (e) => e.name === data.drinkName
          ),
        });
        break;

      case "DRINK_SELECT":
        break;

      case "DRINK_PROGRESS":
        break;

      case "DRINK_FINISHED":
        break;

      default:
        break;
    }
  };

  _handleProgressChange = (e) => {
    let data = JSON.parse(e.detail);

    this.setState({ progress: data });
  };

  render() {
    switch (this.state.view) {
      case "DRINK_SELECT":
        return this.state.menu && <Menu menu={this.state.menu} />;

      case "DRINK_DETAIL":
        return (
          <DrinkDetail menu={this.state.menu} index={this.state.mixingDrink} />
        );

      case "DRINK_PROGRESS":
        return (
          <div>
            <button onClick={() => DataControll.sendSignal("returnToMenu")}>
              Cancel
            </button>

            <h1>{`Making ${this.state.menu[this.state.mixingDrink].name}`}</h1>
            <h2>{`${this.state.progress.message} (${this.state.progress.progress}/${this.state.progress.total})`}</h2>
            <progress
              max={this.state.progress.total}
              min={0}
              value={this.state.progress.progress}
            />
          </div>
        );

      case "DRINK_FINISHED":
        return (
          <DrinkFinished
            menu={this.state.menu}
            index={this.state.mixingDrink}
          />
        );

      default:
        break;
    }
  }
}
