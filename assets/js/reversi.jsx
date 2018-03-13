import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function run_reversi(root, channel) {
  ReactDOM.render(<Reversi channel={channel}/>, root);
}

/*
state
  vals: the values of the grid cells of the game board
  name_one: the name of player name_one
  score_one: the score of player one
  name_two: the name of player name_two
  score_two: the score of player two
  player_ones_turn: a boolean to determine whose turn is it
  is_over: a boolean to determine if the game is is_over
  game_id: id of this game
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
      name_one: 'dark',
      score_one: 2,
      name_two: 'light',
      score_two: 2,
      player_ones_turn: true,
      is_over: false,
      game_id: -1,
      state_id: -1,
      is_current: true
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
      let u = window.currentUserID;
      let c = this.channel;
      let gv = this.gotView.bind(this);
      let ic = this.state.is_current;

      return function (ev) {
        c.push("select", { grid_index: i, current_user_id: u, is_current: ic }).receive("ok", gv);
      }
  }

  // resets the state of the game with newly randomized tile values
  // waits a second before executing to allow previously waiting calls
  // to complete their execution
  concede() {
    let u = window.currentUserID;

    this.channel.push("concede", {current_user_id: u}).receive("ok", this.gotView.bind(this));

    // setTimeout(
    //   () => this.channel.push("concede").receive("ok", this.gotView.bind(this)),
    //   1000
    // );
  }

  init() {
    this.channel.push("init").receive("ok", this.gotView.bind(this));
  }

  now() {
    this.channel.push("now").receive("ok", this.gotView.bind(this));
  }

  prev() {
    this.channel.push("prev", {state_id: this.state.state_id}).receive("ok", this.gotView.bind(this));
  }

  next() {
    this.channel.push("next", {state_id: this.state.state_id}).receive("ok", this.gotView.bind(this));
  }

  render() {
    let status = "";
    let mode = "";
    let dark_info = "col-2 text-center dark-info rounded pt-2 pb-0";
    let light_info = "col-2 text-center light-info rounded pt-2 pb-0";

    if (this.state.is_over) {
      if (this.state.is_current) {
        if (this.state.score_one > this.state.score_two) {
          status = "dark wins";
        } else if (this.state.score_two > this.state.score_one) {
          status = "light wins";
        } else {
          status = "draw";
        }
      } else {// if the state is not current (but the game is over)
        if (this.state.player_ones_turn) {
          status = "dark's turn";
          mode = "(historical view)";
          dark_info = "col-2 text-center darks-turn-info rounded pt-2 pb-0";
        } else {// if it's player two's turn (game over, not current state)
          status = "light's turn";
          mode = "(historical view)";
          light_info = "col-2 text-center lights-turn-info rounded pt-2 pb-0";
        }
      }
    } else {// if the game is not over
      if (this.state.is_current) {
        if (this.state.player_ones_turn) {
          status = "dark's turn";
          dark_info = "col-2 text-center darks-turn-info rounded pt-2 pb-0";
        } else {// if it's player two's turn (game not over, current state)
          status = "light's turn";
          light_info = "col-2 text-center lights-turn-info rounded pt-2 pb-0";
        }
      } else {// if the state is not current (and the game is not over)
        if (this.state.player_ones_turn) {
          status = "dark's turn";
          mode = "(historical view)";
          dark_info = "col-2 text-center darks-turn-info rounded pt-2 pb-0";
        } else {
          status = "light's turn";
          mode = "(historical view)";
          light_info = "col-2 text-center lights-turn-info rounded pt-2 pb-0";
        }
      }
    }

    return (
      <div>
        <div className="row justify-content-center mb-4">
          <div className={dark_info}>
            <p className="mb-0 pb-0">{this.state.name_one}</p>
            <h1 className="mt-0 pt-0 mb-0 pb-0">{this.state.score_one}</h1>
          </div>
          <div className="col-4 text-center middle-grey-color pt-1">
            <h2 className="mb-0">Game #{this.state.game_id}</h2>
            <p className="mb-0">{status}</p>
            <p className="mb-0">{mode}</p>
          </div>
          <div className={light_info}>
            <p className="mb-0 pb-0">{this.state.name_two}</p>
            <h1 className="mt-0 pt-0 mb-0 pb-0">{this.state.score_two}</h1>
          </div>
        </div>

        <div className="row justify-content-center">
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

        <div className="row justify-content-center">
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

        <div className="row justify-content-center">
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

        <div className="row justify-content-center">
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

        <div className="row justify-content-center">
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

        <div className="row justify-content-center">
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

        <div className="row justify-content-center">
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

        <div className="row justify-content-center">
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

        <div className="row justify-content-center mb-4 mt-4">
          <div className="col-1">
            <Button className="btn btn-primary btn-block bs border-0"
              onClick={this.prev.bind(this)}>
              prev
            </Button>
          </div>

          <div className="col-1">
            <Button className="btn btn-primary btn-block bs border-0"
              onClick={this.next.bind(this)}>
              next
            </Button>
          </div>

          <div className="col-1"></div>

          <div className="col-2">
            <Button className="btn btn-block bd border-0"
              onClick={this.concede.bind(this)}>
              concede
            </Button>
          </div>

          <div className="col-1"></div>

          <div className="col-1">
            <Button className="btn btn-primary btn-block bs border-0"
              onClick={this.init.bind(this)}>
              init
            </Button>
          </div>

          <div className="col-1">
            <Button className="btn btn-block bs border-0"
              onClick={this.now.bind(this)}>
              now
            </Button>
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

  var class_name;

  if (val == 1) {
    class_name = "cell rounded-circle border-0 btn-info"
  } else if (val == 2) {
    class_name = "cell rounded-circle border-0 btn-warning"
  } else {
    if (props.state.is_over) {
      class_name = "cell rounded-circle border-0 btn-success game-over"
    } else if (props.state.player_ones_turn) {
      class_name = "cell rounded-circle border-0 btn-success dark-success"
    } else {
      class_name = "cell rounded-circle border-0 btn-success light-success"
    }
  }

  return (
    <div className="col-1 game-board">
      <div className="spacer"></div>
      <Button className={class_name} onClick={props.select(indexString, props.state.current_user_id)}>
      </Button>
    </div>
  );
}
