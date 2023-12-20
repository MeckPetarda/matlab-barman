export default class DataControll {
  static sendSignal(name, data) {
    document.body.dispatchEvent(
      new CustomEvent("sendSignal", {
        detail: { label: name, data },
      })
    );
  }
}
