import { Elm } from "./build/elm.js";
import { whisper, ui } from "@oliveai/ldk";

var app = Elm.Main.init({ flags: 0 });

app.ports.newWhisper.subscribe((md) => {
  whisper.create({
    label: "hello elm",
    components: [md],
    onClose: () => {},
  });
});

ui.listenGlobalSearch((text) => {
  app.ports.onSearch.send(text);
});

ui.listenSearchbar((text) => {
  app.ports.onSearch.send(text);
});
