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
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0],
      angles: [0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0],
      id_one: -1,
      name_one: 'loading',
      score_one: '...',
      id_two: -1,
      name_two: 'loading',
      score_two: '...',
      player_ones_turn: true,
      is_over: false,
      game_id: ' loading',
      state_id: -1,
      is_current: true
    };

    this.channel.join()
      .receive("ok", this.gotView.bind(this))
      .receive("error", resp => {console.log("Unable to join", resp)});

    this.channel.on("new_state", payload => {
      if (this.state.is_current) {
        this.gotView(payload);
      }
    });
  }

  // resets the view upon receiving an updated game state from the controller
  // sends a subsequent "match" message to the channel if two tiles are selected
  gotView(view) {
    // identify index of new piece and pieces to be flipped
    var new_piece_index;
    var new_piece_val;
    var indexes_to_be_flipped = [];
    var i;

    for (i = 0; i < this.state.vals.length; i++) {
      if (this.state.vals[i] == 0 && view.game.vals[i] != 0) {
        new_piece_index = i;
        new_piece_val = view.game.vals[i];
      } else if (this.state.vals[i] != view.game.vals[i]) {
        indexes_to_be_flipped.push(i);
      }
    }

    // flip pieces 15 degrees
    for (i = 0; i < indexes_to_be_flipped.length; i++) {
      view.game.angles[indexes_to_be_flipped[i]] = 15;
    }

    this.setState(view.game);

    // flip pieces 30 degrees
    setTimeout(
      () => {
        for (i = 0; i < indexes_to_be_flipped.length; i++) {
          view.game.angles[indexes_to_be_flipped[i]] = 30;
        }
        this.setState(view.game);
      }, 90
    );

    // flip pieces 45 degrees
    setTimeout(
      () => {
        for (i = 0; i < indexes_to_be_flipped.length; i++) {
          view.game.angles[indexes_to_be_flipped[i]] = 45;
        }
        this.setState(view.game);
      }, 180
    );

    // flip pieces 60 degrees
    setTimeout(
      () => {
        for (i = 0; i < indexes_to_be_flipped.length; i++) {
          view.game.angles[indexes_to_be_flipped[i]] = 60;
        }
        this.setState(view.game);
      }, 270
    );

    // flip pieces 75 degrees
    setTimeout(
      () => {
        for (i = 0; i < indexes_to_be_flipped.length; i++) {
          view.game.angles[indexes_to_be_flipped[i]] = 75;
        }
        this.setState(view.game);
      }, 360
    );

    // flip pieces 90 degrees
    setTimeout(
      () => {
        for (i = 0; i < indexes_to_be_flipped.length; i++) {
          view.game.angles[indexes_to_be_flipped[i]] = 90;
        }
        this.setState(view.game);
      }, 450
    );

    // flip pieces 105 degrees
    setTimeout(
      () => {
        for (i = 0; i < indexes_to_be_flipped.length; i++) {
          view.game.angles[indexes_to_be_flipped[i]] = 105;
        }
        this.setState(view.game);
      }, 540
    );

    // flip pieces 120 degrees
    setTimeout(
      () => {
        for (i = 0; i < indexes_to_be_flipped.length; i++) {
          view.game.angles[indexes_to_be_flipped[i]] = 120;
        }
        this.setState(view.game);
      }, 630
    );

    // flip pieces 135 degrees
    setTimeout(
      () => {
        for (i = 0; i < indexes_to_be_flipped.length; i++) {
          view.game.angles[indexes_to_be_flipped[i]] = 135;
        }
        this.setState(view.game);
      }, 720
    );

    // flip pieces 150 degrees
    setTimeout(
      () => {
        for (i = 0; i < indexes_to_be_flipped.length; i++) {
          view.game.angles[indexes_to_be_flipped[i]] = 150;
        }
        this.setState(view.game);
      }, 810
    );

    // flip pieces 165 degrees
    setTimeout(
      () => {
        for (i = 0; i < indexes_to_be_flipped.length; i++) {
          view.game.angles[indexes_to_be_flipped[i]] = 165;
        }
        this.setState(view.game);
      }, 900
    );

    // flip pieces 180 degrees
    setTimeout(
      () => {
        for (i = 0; i < indexes_to_be_flipped.length; i++) {
          view.game.angles[indexes_to_be_flipped[i]] = 0;
        }
        this.setState(view.game);
      }, 990
    );
  }

  // event handler for tile selections
  // uses closure to pass tile index to the channel message
  sendSelection(index) {
    let c = this.channel;
      let i = index;
      let u = window.currentUserID;
      let si = this.state.state_id;
      let gv = this.gotView.bind(this);

      var pf = false;
      var j;

      for (j = 0; j < this.state.angles.length; j++) {
        if (this.state.angles[j] != 0) {
          pf = true;
          break;
        }
      }

      return function (ev) {
        c.push("select", { grid_index: i, current_user_id: u, state_id: si, pieces_flipping: pf }).receive("ok", gv);
      }
  }

  // resets the state of the game with newly randomized tile values
  // waits a second before executing to allow previously waiting calls
  // to complete their execution
  concede() {
    let u = window.currentUserID;
    let si = this.state.state_id;

    this.channel.push("concede", {current_user_id: u, state_id: si}).receive("ok", this.gotView.bind(this));

    // setTimeout(
    //   () => this.channel.push("concede").receive("ok", this.gotView.bind(this)),
    //   1000
    // );
  }

  init() {
    this.channel.push("init", {state_id: this.state.state_id}).receive("ok", this.gotView.bind(this));
  }

  now() {
    this.channel.push("now", {state_id: this.state.state_id}).receive("ok", this.gotView.bind(this));
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
    let dark_info = "col-md-2 text-center dark-info rounded pt-2 pb-0 float-left mb-4";
    let light_info = "col-md-2 text-center light-info rounded pt-2 pb-0 float-right mb-4";

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
          dark_info = "col-md-2 text-center darks-turn-info rounded pt-2 pb-0 float-left mb-4";
        } else {// if it's player two's turn (game over, not current state)
          status = "light's turn";
          mode = "(historical view)";
          light_info = "col-md-2 text-center lights-turn-info rounded pt-2 pb-0 float-right mb-4";
        }
      }
    } else {// if the game is not over
      if (this.state.is_current) {
        if (this.state.player_ones_turn) {
          status = "dark's turn";
          dark_info = "col-md-2 text-center darks-turn-info rounded pt-2 pb-0 float-left mb-4";
        } else {// if it's player two's turn (game not over, current state)
          status = "light's turn";
          light_info = "col-md-2 text-center lights-turn-info rounded pt-2 pb-0 float-right mb-4";
        }
      } else {// if the state is not current (and the game is not over)
        if (this.state.player_ones_turn) {
          status = "dark's turn";
          mode = "(historical view)";
          dark_info = "col-md-2 text-center darks-turn-info rounded pt-2 pb-0 float-left mb-4";
        } else {
          status = "light's turn";
          mode = "(historical view)";
          light_info = "col-md-2 text-center lights-turn-info rounded pt-2 pb-0 float-right mb-4";
        }
      }
    }

    return (
      <div>
        <div className="row justify-content-center">
          <div className={dark_info}>
            <p className="mb-0 pb-0">{this.state.name_one}</p>
            <h1 className="mt-0 pt-0 mb-0 pb-0">{this.state.score_one}</h1>
          </div>

          <div className="col-md-4 text-center middle-grey-color pt-1 mb-4">
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
          <div className="col-md-8">
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
          </div>
        </div>

        <div className="row justify-content-center mb-4 mt-4">
          <div className="col-lg-1">
            <Button className="btn btn-primary btn-block bs border-0 mb-2"
              onClick={this.prev.bind(this)}>
              prev
            </Button>
          </div>

          <div className="col-lg-1">
            <Button className="btn btn-primary btn-block bs border-0 mb-2"
              onClick={this.next.bind(this)}>
              next
            </Button>
          </div>

          <div className="col-lg-1"></div>

          <div className="col-lg-2">
            <Button className="btn btn-block bd border-0 mb-2"
              onClick={this.concede.bind(this)}>
              concede
            </Button>
          </div>

          <div className="col-lg-1"></div>

          <div className="col-lg-1">
            <Button className="btn btn-primary btn-block bs border-0 mb-2"
              onClick={this.init.bind(this)}>
              init
            </Button>
          </div>

          <div className="col-lg-1">
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
  let angle = props.state.angles[index];

  var class_name;

  if (val == 1) {
    switch(angle) {
      case 15:
        class_name = "flip-15 rounded-circle border-0 btn-light"
        break;
      case 30:
        class_name = "flip-30 rounded-circle border-0 btn-light"
        break;
      case 45:
        class_name = "flip-45 rounded-circle border-0 btn-light"
        break;
      case 60:
        class_name = "flip-60 rounded-circle border-0 btn-light"
        break;
      case 75:
        class_name = "flip-75 rounded-circle border-0 btn-light"
        break;
      case 90:
        class_name = "flip-90 rounded-circle border-0 btn-dark"
        break;
      case 105:
        class_name = "flip-105 rounded-circle border-0 btn-dark"
        break;
      case 120:
        class_name = "flip-120 rounded-circle border-0 btn-dark"
        break;
      case 135:
        class_name = "flip-135 rounded-circle border-0 btn-dark"
        break;
      case 150:
        class_name = "flip-150 rounded-circle border-0 btn-dark"
        break;
      case 165:
        class_name = "flip-165 rounded-circle border-0 btn-dark"
        break;
      default:
        class_name = "cell rounded-circle border-0 btn-dark"
    }
  } else if (val == 2) {
    switch(angle) {
      case 15:
        class_name = "flip-15 rounded-circle border-0 btn-dark"
        break;
      case 30:
        class_name = "flip-30 rounded-circle border-0 btn-dark"
        break;
      case 45:
        class_name = "flip-45 rounded-circle border-0 btn-dark"
        break;
      case 60:
        class_name = "flip-60 rounded-circle border-0 btn-dark"
        break;
      case 75:
        class_name = "flip-75 rounded-circle border-0 btn-dark"
        break;
      case 90:
        class_name = "flip-90 rounded-circle border-0 btn-light"
        break;
      case 105:
        class_name = "flip-105 rounded-circle border-0 btn-light"
        break;
      case 120:
        class_name = "flip-120 rounded-circle border-0 btn-light"
        break;
      case 135:
        class_name = "flip-135 rounded-circle border-0 btn-light"
        break;
      case 150:
        class_name = "flip-150 rounded-circle border-0 btn-light"
        break;
      case 165:
        class_name = "flip-165 rounded-circle border-0 btn-light"
        break;
      default:
        class_name = "cell rounded-circle border-0 btn-light"
    }
  } else { // val == 0 for empty cells
    if (!props.state.is_over && props.state.player_ones_turn && props.state.id_one == window.currentUserID) {
      class_name = "cell rounded-circle border-0 btn-empty dark-success"
    } else if (!props.state.is_over && !props.state.player_ones_turn && props.state.id_two == window.currentUserID) {
      class_name = "cell rounded-circle border-0 btn-empty light-success"
    } else {
      class_name = "cell rounded-circle border-0 btn-empty game-over"
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
