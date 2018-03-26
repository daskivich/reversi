# Reversi
# by Daniel Daskivich


Introduction and Game Description

Reversi (also known by its trademarked name Othello) is a two-player board game played on an eight-by-eight grid. Each square in this grid can be empty or contain one game piece. Game pieces come in one of two colors: dark and light. In my version of Reversi, the player who creates the game plays with the dark pieces; the player who joins an already created game plays with the light pieces. The game starts with four pieces placed in the center of the game board: two dark pieces diagonally across from each other and two light pieces diagonally across from each other. The players alternate turns with dark playing first. A legal move consists of a player placing one of his/her pieces on the game board in an empty square as follows: this new piece must be an endpoint on at least one line segment (vertical, horizontal, or diagonal) of connected pieces (with no intervening empty squares); the other endpoint of this line segment must be another of his/her pieces, and all intervening pieces (and there must be at least one) must be opponent pieces. Upon each legal move, all intervening opponent pieces on all such lines formed with the placement of the newest piece are flipped. If a player does not have a legal move, his/her turn is skipped. If neither player has a legal move, the game is over. In my version of Reversi, a player who is losing can use his/her turn to concede the game. At the end of the game, the player with more pieces on the board wins; if both players have the same number of pieces, the game is a draw. A more detailed description of game play can be found at https://en.wikipedia.org/wiki/Reversi#Rules.


UI Design

Throughout this web site, a triad color scheme based on pool felt green (#277714) was used (as specified here: http://rgb.to/color/14402/pool-felt-green), to include a particular dark blue (#142876) and dark red (#761428). Motivating this decision was a desire to convey a classic game feel—and my memories of playing Othello as a child on a green felt game board. The traditional white and black of the pieces were softened to a specific dark gray (#323232) and light gray (Gainsboro) to reduce eye strain; a complementary middle gray (#777777) was used as a neutral midpoint for contrast.

A universal navigation bar visible upon log-in helps users navigate the site. The name of the game (Reversi) and the name of the current user flank a list of helpful in-site links.

Throughout the site, various Bootstrap “col-*-*” classes are used (e.g., col-lg-2, col-md-8) to make the content responsive to various and changing screen sizes.

The initial landing page of the site, page/index.html, presents form inputs for email and password, and buttons for logging in and creating a new account. The color scheme attempts to draw attention to the inputs—with the “create an account” button in red to indicate an unusual (one-time only) action. Textual content has been strategically minimized to allow for a better visual experience.

The landing page for the “create an account” button and (once logged in) the “my profile” link in the navigation bar both utilize the user/form.html template, which mimics the input design of the main log-in page.

The “about” page, accessed via the main navigation bar, provides information on the game, game play, and the functionality of the various pages of the site—and is laid out with a simple Bootstrap grid of Bootstrap “card” classes.

The “games” page, accessed via the main navigation bar, displays a filtered list of games. The topmost button allows a user to create a new game. Two responsive rows of four buttons provide the filtering options. The list of games is created as a Bootstrap “table”; each row includes helpful information on the status of the game and ends with an action button that varies depending on the current user’s role and the status of the that particular game. The button text changes based on these circumstances, so it should be apparent what action a user will be taking when clicking this button: joining a game, playing a game, or viewing a game. Table rows are sorted in descending date/time order, with the most recently created games at the top.

Each game has its own page, created as a main “Reversi” React component (see reversi.jsx). The game number and status, dark player info, and light player info are displayed along the top of the page. The game board is displayed in the middle. And various control buttons and a concession button are displayed at the bottom. Game/player info is responsive and will shrink and stack as the screen size shrinks. The game board shrinks responsively. And the buttons at the bottom will shrink and stack as well. Depending on the state of the game (and the state being displayed), the game status info will change. If the game is ongoing and the state being displayed is current, the game status will list whose turn it is. If a user is not playing as dark or light in a game he/she is viewing, then he/she cannot make any moves in the game but will see the game board change in real time as the players make their moves. By default, the current state of the game is displayed upon the initial loading of the game page—but players and viewers alike can use the “init”, “now”, “prev”, and “next” buttons at the bottom to navigate through past states of the game. “init” displays the initial state of the game. “now” displays the current state of the game. “prev” and “next” display the previous or next state before or after the state being displayed (if it exists). Hovering above an empty game board square as the player whose turn it is will display a new game piece with a box shadow, indicating where the next move would be made if that square were clicked. Once the active player clicks to make a legal move, the box shadow disappears and all surrounded opponent pieces are flipped through a progression of 15-degree increments from 0 to 180 degrees. Clicking through the historical states of the game also flip pieces that remain but are of the opposite color in the new state. The game status will note “historical view” when the state being displayed is not the current state. When a player’s display is in “historical view”, he/she cannot make a move, even if it’s his/her turn; he/she must first return the display to the current state by clicking the “now” button (or the “next” button repeatedly until the current state is reached). A player’s name and score (according to the currently displayed state) is displayed in a box with a thick gray border. The background of this box is dark gray for the dark player, light gray for the light player, and the border of a player’s box lights up pool felt green when it’s his/her turn to play.

The “leader board” page, accessed through the main navigation bar, lists each player by rank in Bootstrap “table” format. A “games” button is provided for each player. When a user clicks a “games” button for a particular player, a list of his/her competitive, completed games is displayed—from which a user can click the “view” button to view a particular game. An explanation of the meaning of the various statics and algorithm for rank ordering can be found in the “Leader Board” section of the “about” page (reversi.daskivich.com/about).


UI to Server Protocol

The main Reversi React component communicates with the server via a web socket through a games channel. The front-end view state consists of the following: an array of 64 values (0, 1, or 2) representing whether a game board square is empty (0) or occupied by a piece (1 for a dark piece, 2 for a light piece); an array of angles (0-165) representing the display angle of a piece in degrees, for the purposes of animating the piece-flipping process; the id, name, and score of players one and two; whose turn it is; whether the game is over or still in progress; the id of the game being displayed; the id of the back-end game state being displayed; and whether the back-end game state being displayed is the current state of the game. When a player clicks on a game board square (a React-strap Button wrapped in a custom Tile React element), a “select” message is sent to the games channel (via a handle_in() method call) specifying the grid index of the selected Tile, the id of the current user, the id of the back-end game state being displayed, and a boolean to represent whether any pieces are currently in the process of being flipped. The main Reversi React component then awaits a response in the form of a new front-end view state to render through its gotView() method. Note that the games channel broadcasts this new front-end view state to every user accessing that particular game channel to provide real-time game display updates to both players and all viewers, not just the player who made the selection; this broadcast is received by the channel.on() method, which calls gotView() to refresh the display. Additionally, the “concede” button sends a “concede” message (via a handle_in() method call) to the games channel, specifying the id of the current user and the id of the back-end game state being displayed. As with the “select” action, the “concede” message triggers a new front-end view state response and a “new_state” broadcast. Finally, the “init”, “now”, “prev”, and “next” buttons each send their own handle_in() messages to the games channel, specifying the id of the back-end game state being displayed, and await a new front-end view state response.

All other communication between the front-end and the back-end, outside of the main Reversi React component, takes place via standard Phoenix router/controller protocol. The following paths are handled by the following controllers using the following methods. And for filtering the list of games displayed on the games page, a “which” parameter is added to the :home path to allow the server to determine which games to include in the list it returns.

	view the main log-in page
	page_path	GET		/			ReversiWeb.PageController		:index

	log in
	session_path	POST		/session		ReversiWeb.SessionController	:create

	log out
	session_path	DELETE	/session		ReversiWeb.SessionController	:delete

	create an account
	user_path	POST 		/users			ReversiWeb.UserController		:create

	view your profile
	user_path	GET		users/:id		ReversiWeb.UserController		:show

	update your profile
	user_path	PATCH	/users/:id		ReversiWeb.UserController		:update
			PUT		/users/:id		ReversiWeb.UserController		:update

	cancel account creation
	page_path	GET		/			ReversiWeb.PageController		:index

	cancel profile update
	page_path	GET		/home			ReversiWeb.PageController		:home

	view the about page
	page_path	GET		/about			ReversiWeb.PageController		:about

	view the games page
	page_path	GET		/home			ReversiWeb.PageController		:home
	game_path	GET		/games			ReversiWeb.GameController		:index

	filter the games list on the games page
	page_path	GET		/home			ReversiWeb.PageController		:home

	create a new game (with corresponding new state)
	game_path	POST		/games			ReversiWeb.GameController		:create
	state_path	POST		/api/v1/states		ReversiWeb.StateController		:create

	join a game (and then play that game)
	game_path	GET		/games/:id/edit	ReversiWeb.GameController		:edit
	page_path	GET		/game/:game		ReversiWeb.PageController		:game

	view or play a game
	page_path	GET		/game/:game		ReversiWeb.PageController		:game

	view the leader board
	user_path	GET		/users			ReversiWeb.UserController		:index

	view a users completed games
	game_path	GET		/games			ReversiWeb.GameController		:index


Data structures on server

A server-side relational database with three tables/entities was implemented to store persistent data. A “users” table stores each user’s email (which must be unique), name, password hash value, number of attempted log-ins since the last successful log-in (or since expiration of the lock-out time span), and the time of the last log-in attempt. For each game, a “games” table stores the user id of that game’s player one, the user id of that game’s player two, and a boolean to indicate whether that particular game is over or still in progress. For each back-end game state, a “states” table stores each state’s game id, a boolean to indicate whose turn it is (player one’s or player two’s), and 64 values representing whether a specific grid square on the game board is empty (val=0), contains a dark piece (val=1), or contains a light piece (val=2).

With respect to relationships, a user can have many games where he/she is player one and many games where he/she is player two; a game must have one user (player one), can have two users (player one and player two), and can have many states; and a state must have one and only one game.

The “users” and “games” tables were created as Phoenix HTML resources to simplify front-end control of certain aspects of these entities: specifically, user creation, updating, and indexing, and game indexing. The “states” table was created as a Phoenix JSON resource; since state creation and updating was handled entirely by the back-end through information received through a web socket/channel, and state display was handled entirely by the main Reversi React component, there was no need for traditional HTML display or form submission templates for this resource.


Implementation of game rules

By default, when a game record is created in the “games” table, the current user is set as player one, player two is left null, and the “is over” boolean is set to false (to indicate that the game is not over yet)--and a new state record is created in the “states” table with the standard opening grid values and the “player one’s turn” boolean set to true (since the game starts with it being player one’s turn). When a second player joins a game, that game record is updated with the joining player’s id as player two, and the initial “client view”, as constructed by Play.client_view(), is sent to the front end. In the games_channel, calls to handle_in(“select”) in turn call Play.select(), which implements the game logic for every move except concession (which is handled through handle_in(“concede”) by Play.concede()).

Play.select() first checks to make sure the given index is a valid selection for the current state of the game: moves are not allowed if pieces are in the process of being flipped from the previous move, the state being displayed by the front end must be the current state of the game, the game must still be in progress, and the selected game board grid square must be empty. If all of these conditions pass, Play.select() determines what pieces would be flipped by this move by calling get_indexes_to_flip(), which in turn uses eight helper methods to check each of the eight directions radiating from the selected game board grid square: east, southeast, south, southwest, west, northwest, north, and northeast. Each of these helper methods checks the vals of the grid indexes in its direction and returns a list of all consecutive indexes (starting immediately adjacent to the selected index) that contain opposing vals (ending with an immediately following val of the selecting player), in accordance with game rules; recursion is used for this purpose within the Play.valid_move() method. If no pieces are to be flipped by the current selection, this selection is deemed invalid; if at least one piece would be flipped, the move is deemed valid and a new back-end game state is created using get_new_state_attrs() and create_state(). get_new_state_attrs() copies the current state and then changes the val of the selected index and the vals of indexes to be flipped; by default, it flips the “player_ones_turn” flag to indicate that it should be the opposing player’s turn next—but it must first be verified that the opposing player has at least one valid move after the current selection. This is accomplished by the use of the has_next_move() method: first a call for the opposing player and then, if the opposing player doesn’t have a valid move after the current selection, a call for the current player. If neither player has a valid move after the current selection, the game is updated with a true game_over, indicating the game is over. For valid moves, the id of the new state is returned; otherwise, the given state_id is returned, indicating no changes to the state were made with the invalid selection.

Play.concede() simply checks to make sure it’s the current user’s turn and that the current user is losing before updating the game’s game_over flag to true, indicating the game is over.


Challenges and Solutions

One major challenge was designing the structures for persistent game data in such a way that allowed for players/viewers to walk through the history of a game one move at a time. To do this, each game state had to be stored, not just the current game state. Furthermore, to be able to move both forward and backward, I decided to store the values of every game board grid square. To move forward through a game’s moves, one could simply store the index of the newly played piece for each state, as the values for the rest of the grid squares could be inferred from the previous state and the new index. This approach is very efficient in terms of space while somewhat less efficient in terms of time, as the pieces to be flipped must be recalculated with every step through the game. In order to move backwards through the historical moves in a game, however, the approach of storing just the index of the newly played piece for each move does not work. It is impossible to infer what pieces should be unflipped based on the current game state and the index of the previously placed piece, thus my decision to store the values of all grid squares for each state. While this approach may be less efficient in terms of space, it is very efficient in terms of time, as calculations to determine what pieces to flip/unflip only happen once, during the course or real-time game play, and not every time the historical moves of a game are viewed.

Another challenge was adding password security. I followed the guidance in Nat’s Notes (http://www.ccs.neu.edu/home/ntuck/courses/2018/01/cs4550/notes/17-passwords/notes.html) using Comeonin’s Argon2 password hashing module via Accounts.get_and_auth_user() and throttling log-in attempts via Accounts.verify_tries().

Similar to the design of our previous assignment’s Memory game, I used sessions to allow multiple players/viewers to play/view the same game at the same time. Clicks on the game board and concession button are handled through the games channel by the Play.select() and Play.concede() methods in such a way as to be ignored if the clicking user is not listed as one of the players in the game record, thus making that user a viewer and not a player.

Ecto queries were used to filter the list of games being displayed in games/index.html through the Play.list_games(which_games, user_id) and Play.get_list_games_query(which_games, user_id) methods. Ecto queries (in Play.competitive_games(), Play.victories(), Play.defeats(), and Play.differential()) and a custom comparator function (Accounts.compare_users()) were used in Accounts.get_users_with_stats() to get a list of users with their statistics in sorted rank order for the leader board.

Another challenge was to make the game board grid squares perfectly square and to maintain this 1:1 aspect ratio in a responsive fashion. The general approach to this challenge’s solution came from the Bootply user “jquery” (https://www.bootply.com/99278), though some customization was required to get this solution to work within the context of my application. A Bootstrap “row” is used for each row of game board grid squares. A Bootstrap “col” is used for each square. A spacer div is used to set the height of each col, and then the game piece button is positioned in an absolute manner with respect to the col. Since the game piece is smaller than the game board grid square, the absolute position of the game piece button is a little in from the left and down from the top. And since Bootstrap cols include gutters, the height of the spacer div has to be 100% its width plus the size of the gutters (which turns out to be 15px each) in order to make the col perfectly square.

A final challenge was figuring out how to animate the flipping of the game pieces. My solution to this challenge involved a concerted effort across many application layers, as follows. Each game board grid square contains a circular React-strap Button wrapped in a custom React Tile element. Changing the class (and thus the corresponding CSS) for a Button changes the color and shape of the Button. Manipulating the height and positioning attributes of these classes squashes the circularity of the Button to mimic a different angle of view. By stepping through a series of progressively more and then less squashed circles, the game piece can be made to look as though it’s being flipped (in conjunction with a color change halfway through the progression). A game’s front-end view state stores numbers representing the view angles of each piece. (There’s no need to store these in the back-end game state, as the progression is the same for every flip and they contribute no significant knowledge about the state of the game apart from one temporary aspect of its appearance.) These numbers from the view state trigger different CSS classes for the various grid square Buttons when passed as props while constructing the Tile element for each grid square. The view-state angles themselves are set and re-set through a 180-degree progression (in 15-degree increments) in the gotView() method of the main Reversi React game component. When a Reversi component receives a new view state to display, it identifies what pieces have changed color from the previous state and then steps through the flipping process by re-setting the Reversi state every 0.09 seconds (through progressively lengthier calls to setTimeout()), giving each piece that’s to be flipped the next angle in the progression. The front-end view state keeps track of whether pieces are in the process of being flipped and passes this as a boolean through its sendSelection() method to the games channel to prevent a player from making the next move while pieces are in the process of being flipped (and thus messing with the animation), and the Play.select() method checks this boolean on the server side before validating the next selection.

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
