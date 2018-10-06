import socket from "./socket";
import $ from "jquery";

let channel = socket.channel("song:lobby", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("new_song", ({ template }) => {
  $("[data-songlist]").append(template)
})
