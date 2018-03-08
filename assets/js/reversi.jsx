import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function run_reversi(root, channel) {
  ReactDOM.render(<Reversi channel={channel}/>, root);
}

/*
state
  vals: the tile values to be displayed as a list of 16 values
  colors: the colors of the tiles as a list of 16 colors
  score: the current game score
*/
class Reversi extends React.Component {
  constructor(props) {
    super(props);
    this.channel = props.channel;

     this.state = {
      vals: [0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 2, 1, 0, 0, 0,
        0, 0, 0, 1, 2, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0],
      name_one: 'player one',
      color_one: 'info',
      score_one: 2,
      name_two: 'player two',
      color_two: 'warning',
      score_two: 2,
      player_ones_turn: true,
      is_over: false
    };

    this.channel.join()
      .receive("ok", this.gotView.bind(this))
      .receive("error", resp => {console.log("Unable to join", resp)});
  }

  // resets the view upon receiving an updated game state from the controller
  // sends a subsequent "match" message to the channel if two tiles are selected
  gotView(view) {
    // console.log("New view", view);
    this.setState(view.game);

    // let selections = _.filter(this.state.colors, (c) => c == "primary");
    //
    // if (selections.length == 2) {
    //   setTimeout(
    //     () => this.channel.push("match").receive("ok", this.gotView.bind(this)),
    //     1000
    //   );
    // }
  }

  // event handler for tile selections
  // uses closure to pass tile index to the channel message
  sendSelection(index) {
      let i = index;
      let u = current_user_id;
      let c = this.channel;
      let gv = this.gotView.bind(this);

      return function (ev) {
        c.push("select", { grid_index: i, current_user_id: window.currentUserId})
          .receive("ok", gv);
      }
  }

  // resets the state of the game with newly randomized tile values
  // waits a second before executing to allow previously waiting calls
  // to complete their execution
  concede() {
    this.channel.push("concede").receive("ok", this.gotView.bind(this));

    // setTimeout(
    //   () => this.channel.push("concede").receive("ok", this.gotView.bind(this)),
    //   1000
    // );
  }

  render() {
    return (
      <div>
        <div className="row">
          <div className="col text-center">
            <p>player one: {this.state.name_one}</p>
            <p>score: {this.state.score_one}</p>
          </div>
          <div className="col text-center">
            <p>player two: {this.state.name_two}</p>
            <p>score: {this.state.score_two}</p>
          </div>
        </div>
        <div className="container game">
          <div className="row">
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r1c1"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r1c2"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r1c3"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r1c4"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r1c5"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r1c6"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r1c7"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r1c8"} />
          </div>
          <div className="row">
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r2c1"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r2c2"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r2c3"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r2c4"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r2c5"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r2c6"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r2c7"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r2c8"} />
          </div>
          <div className="row">
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r3c1"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r3c2"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r3c3"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r3c4"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r3c5"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r3c6"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r3c7"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r3c8"} />
          </div>
          <div className="row">
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r4c1"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r4c2"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r4c3"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r4c4"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r4c5"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r4c6"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r4c7"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r4c8"} />
          </div>
          <div className="row">
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r5c1"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r5c2"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r5c3"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r5c4"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r5c5"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r5c6"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r5c7"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r5c8"} />
          </div>
          <div className="row">
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r6c1"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r6c2"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r6c3"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r6c4"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r6c5"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r6c6"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r6c7"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r6c8"} />
          </div>
          <div className="row">
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r7c1"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r7c2"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r7c3"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r7c4"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r7c5"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r7c6"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r7c7"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r7c8"} />
          </div>
          <div className="row">
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r8c1"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r8c2"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r8c3"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r8c4"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r8c5"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r8c6"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r8c7"} />
            <Tile
              state={this.state}
              select={this.sendSelection.bind(this)}
              index={"r8c8"} />
          </div>
          <div className="row">
            <div className="col">
              <Button className="btn btn-primary btn-block bp border-0" color="warning"
                onClick={this.concede.bind(this)}>
                concede
              </Button>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

// the main component of the game containing a Button
function Tile(props) {
  let indexString = props.index;
  let row = indexString.charAt(1);
  let col = indexString.charAt(3);
  let index = ((row - 1) * 8) + (col - 1);
  let val = props.state.vals[index];

  var clr;

  if (val == 1) {
    clr = "info";
  } else if (val == 2) {
    clr = "warning";
  } else {
    clr = "success";
  }

  return (
    <div className="col-sm border border-dark">
      <div className="spacer"></div>
      <Button className="cell rounded-circle border-0" color={clr} onClick={props.select(indexString, props.state.current_user_id)}>
      </Button>
    </div>
  );
}
