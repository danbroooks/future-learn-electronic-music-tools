import './main.css';
import { Main } from './Main.elm';

const app = Main.embed(document.getElementById('root'));

const ctx = new AudioContext();

var osc;

app.ports.start.subscribe(() => {
  osc = ctx.createOscillator()
  osc.connect(ctx.destination);
  osc.start();
});

app.ports.stop.subscribe(() => {
  if (!osc.stopped) {
    osc.stop();
    osc.stopped = true;
  }
});

