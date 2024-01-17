import React, { Component } from "react";

import Cosmopolitan from "../../../imgs/cosmopolitan.jpg";
import JungleJuice4Poor from "../../../imgs/jungle-juice-4-poor.jpg";
import Margarita from "../../../imgs/margarita.jpg";
import TequilaSunrise from "../../../imgs/tequila-sunrise.jpg";
import CubaLibre from "../../../imgs/cuba-libre.jpg";
import Kamikaze from "../../../imgs/kamikaze.jpg";
import Screwdriver from "../../../imgs/screwdriver.jpg";
import VodkaSunrise from "../../../imgs/vodka-sunrise.jpg";
import GinSecret from "../../../imgs/gin-secret.jpg";
import LongIslandIcedTea from "../../../imgs/long-island-iced-tea.jpg";
import SexOnTheBeach from "../../../imgs/sex-on-the-beach.jpg";

import style from "./style.module.scss";

export default class Images extends Component {
  render() {
    switch (this.props.index) {
      case 0:
        return <img className={style.img} src={TequilaSunrise} />;
      case 1:
        return <img className={style.img} src={Margarita} />;
      case 2:
        return <img className={style.img} src={VodkaSunrise} />;
      case 3:
        return <img className={style.img} src={CubaLibre} />;
      case 4:
        return <img className={style.img} src={GinSecret} />;
      case 5:
        return <img className={style.img} src={Screwdriver} />;
      case 6:
        return <img className={style.img} src={Kamikaze} />;
      case 7:
        return <img className={style.img} src={Cosmopolitan} />;
      case 8:
        return <img className={style.img} src={SexOnTheBeach} />;
      case 9:
        return <img className={style.img} src={LongIslandIcedTea} />;
      case 10:
        return <img className={style.img} src={JungleJuice4Poor} />;

      default:
        return <img className={style.img} src={Cosmopolitan} />;
    }
  }
}
