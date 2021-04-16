% Kevin Nguyen
% 15/12/2017
% Mr. Rosen
/* This program will output a song guessing game with 3 levels: easy, normal, and hard. The user will have 5 different songs
 to guess per level and each level will have 10 songs. Harder levels will play a shorter melody and the program will keep track
 of the player's score and display a score in percent at the end of the game.*/

% Set screen up
import GUI

% Declaration Section
var mainMenuButton, easyButton, normalButton, hardButton, instructionsButton, quitButton, optionOne, optionTwo, optionThree, optionFour, optionReplay,
    tries, songChoice, replayedSong : int /* A variety of buttons that will store the button that goes to mainMenu, userInputEasy, userInputNormal,
 userInputHard, instructions and quits the program, respectively. Also has the four options to guess during a game. Finally, it contains the number of songs the user has
 listened to, the songChoice which will be randomized, and the song choice which will be replayed. */
var mainWin := Window.Open ("graphics:640;400")  % opens a window which can be closed
var correctGuesses : real := 0  % the number of songs the user guessed correctly
var playedSong : array 1 .. 30 of boolean /* The 10 song options per level and whether they have been played already or not. This array corresponds with the whichSong array.
 False songs haven't been played yet, while true songs have been played.*/
var whichSong : array 1 .. 30 of string := init ("DespacitoEASY.wav", "AttentionEASY.wav", "OneDanceEASY.wav", "Don'tWannaKnowEASY.wav", "AllOfMeEASY.wav",
    "SendMyLoveEASY.wav", "BelieverEASY.wav", "TheGreatestEASY.wav", "BeautifulNowEASY.wav", "LightsOutEASY.wav", "AWholeNewWorldNORMAL.wav", "MillionReasonsNORMAL.wav",
    "LoveYourselfNORMAL.wav", "ShapeOfYouNORMAL.wav", "SayYouWon'tLetGoNORMAL.wav", "RockabyeNORMAL.wav", "ScarsToYourBeautifulNORMAL.wav", "StarboyNORMAL.wav",
    "StitchesNORMAL.wav", "CraveNORMAL.wav", "ElectricLoveHARD.wav", "HandClapHARD.wav", "JarOfHeartsHARD.wav", "SeasonsOfLoveHARD.wav", "ShakeItOffHARD.wav", "BadLiarHARD.wav",
    "ImmortalsHARD.wav", "BeatItHARD.wav", "TheLazySongHARD.wav", "You'reWelcomeHARD.wav") /* An array of all the songs availablie in each level.
 Easy songs are 5 seconds, normal songs are 3 seconds, and hard songs are 2 seconds long.*/
var replayed : boolean := false % Whether the user has replayed a song or not

% Forwarding the procedures
forward procedure mainMenu
forward procedure instructions
forward procedure userInputEasy
forward procedure userInputNormal
forward procedure userInputHard
forward procedure replaySong
forward procedure buttonDisposal
forward procedure correctGuess
forward procedure displayProcessing

procedure title
    cls
    var titleFont := Font.New ("lato:12:bold,italic")
    Font.Draw ("Song", 260, 380, titleFont, 42)
    Font.Draw ("Guesser", 305, 380, titleFont, 53)
    Font.Free (titleFont)
end title

% The process that will be forked when the curtains open or close to play music
process curtainMusic
    Music.PlayFile ("OpenandClose.wav")
end curtainMusic

% The introduction to the game with an animated logo
procedure introduction
    easyButton := GUI.CreateButton (285, 340, 0, "Easy", userInputEasy)
    normalButton := GUI.CreateButton (278, 310, 0, "Normal", userInputNormal)
    hardButton := GUI.CreateButton (285, 280, 0, "Hard", userInputHard)
    instructionsButton := GUI.CreateButton (268, 250, 0, "Instructions", instructions)
    quitButton := GUI.CreateButton (285, 220, 0, "Quit", GUI.Quit)
    GUI.Hide (easyButton)
    GUI.Hide (normalButton)
    GUI.Hide (hardButton)
    GUI.Hide (instructionsButton)
    GUI.Hide (quitButton)
    fork curtainMusic
    % Static Stage
    for x : 0 .. 320
	drawbox (0 + x, 0, 640 - x, 9, 186)
    end for
    % Stage lines
    drawline (320, 0, 320, 9, black) % Middle Line

    % Right Lines
    drawline (360, 0, 360, 9, black)
    drawline (400, 0, 400, 9, black)
    drawline (440, 0, 440, 9, black)
    drawline (480, 0, 480, 9, black)
    drawline (520, 0, 520, 9, black)
    drawline (560, 0, 560, 9, black)
    drawline (600, 0, 600, 9, black)

    % Left lines
    drawline (280, 0, 280, 9, black)
    drawline (240, 0, 240, 9, black)
    drawline (200, 0, 200, 9, black)
    drawline (160, 0, 160, 9, black)
    drawline (120, 0, 120, 9, black)
    drawline (80, 0, 80, 9, black)
    drawline (40, 0, 40, 9, black)

    % Opening the Curtains
    for x : 0 .. 350
	drawfillbox (321 - x, 10, -1 - x, 400, white)     % Erase of Left Curtain
	drawfillbox (320 - x, 20, 0 - x, 400, red)     % Left Curtain

	% Bottom of the Left Curtain
	drawfilloval (300 - x, 20, 20, 10, red)
	drawfilloval (260 - x, 20, 20, 10, red)
	drawfilloval (220 - x, 20, 20, 10, red)
	drawfilloval (180 - x, 20, 20, 10, red)
	drawfilloval (140 - x, 20, 20, 10, red)
	drawfilloval (100 - x, 20, 20, 10, red)
	drawfilloval (60 - x, 20, 20, 10, red)
	drawfilloval (20 - x, 20, 20, 10, red)
	drawfilloval (-20 - x, 20, 20, 10, red)

	% Lines of the Left Curtain
	drawline (280 - x, 20, 280 - x, 400, black)
	drawline (240 - x, 20, 240 - x, 400, black)
	drawline (200 - x, 20, 200 - x, 400, black)
	drawline (160 - x, 20, 160 - x, 400, black)
	drawline (120 - x, 20, 120 - x, 400, black)
	drawline (80 - x, 20, 80 - x, 400, black)
	drawline (40 - x, 20, 40 - x, 400, black)

	drawfillbox (319 + x, 10, 639 + x, 400, white)     % Erase of Right Curtain
	drawfillbox (320 + x, 20, 640 + x, 400, red)     % Right Curtain

	% Bottom of the Right Curtain
	drawfilloval (340 + x, 20, 20, 10, red)
	drawfilloval (380 + x, 20, 20, 10, red)
	drawfilloval (420 + x, 20, 20, 10, red)
	drawfilloval (460 + x, 20, 20, 10, red)
	drawfilloval (500 + x, 20, 20, 10, red)
	drawfilloval (540 + x, 20, 20, 10, red)
	drawfilloval (580 + x, 20, 20, 10, red)
	drawfilloval (620 + x, 20, 20, 10, red)
	drawfilloval (660 + x, 20, 20, 10, red)

	% Lines of the Right Curtain
	drawline (360 + x, 20, 360 + x, 400, black)
	drawline (400 + x, 20, 400 + x, 400, black)
	drawline (440 + x, 20, 440 + x, 400, black)
	drawline (480 + x, 20, 480 + x, 400, black)
	drawline (520 + x, 20, 520 + x, 400, black)
	drawline (560 + x, 20, 560 + x, 400, black)
	drawline (600 + x, 20, 600 + x, 400, black)
	delay (9)
    end for
    title
    locate (3, 40 - length ("See if you can guess a song by listening to a short melody!") div 2)
    put "See if you can guess a song by listening to a short melody!"
    % Static Stage
    for x : 0 .. 320
	drawbox (0 + x, 0, 640 - x, 9, 186)
    end for
    % Stage lines
    drawline (320, 0, 320, 9, black) % Middle Line

    % Right Lines
    drawline (360, 0, 360, 9, black)
    drawline (400, 0, 400, 9, black)
    drawline (440, 0, 440, 9, black)
    drawline (480, 0, 480, 9, black)
    drawline (520, 0, 520, 9, black)
    drawline (560, 0, 560, 9, black)
    drawline (600, 0, 600, 9, black)

    % Left lines
    drawline (280, 0, 280, 9, black)
    drawline (240, 0, 240, 9, black)
    drawline (200, 0, 200, 9, black)
    drawline (160, 0, 160, 9, black)
    drawline (120, 0, 120, 9, black)
    drawline (80, 0, 80, 9, black)
    drawline (40, 0, 40, 9, black)
    % Animating the Logo
    for x : 0 .. 300
	drawfillbox (-41 + x, 180, 9 + x, 250, white)     % Erase of the S
	drawfillbox (-40 + x, 240, 10 + x, 250, 42)     % The top of the S
	drawfillbox (-40 + x, 210, -30 + x, 240, 42)     % The left side of the S
	drawfillbox (-40 + x, 210, 10 + x, 220, 42)     % The middle of the S
	drawfillbox (10 + x, 220, 0 + x, 190, 42)     % The right side of the S
	drawfillbox (10 + x, 190, -40 + x, 180, 42)     % The bottom of the S

	drawfillbox (631 - x, 180, 681 - x, 250, white)     % Erase of the G
	drawfillbox (630 - x, 240, 680 - x, 250, 53)     % The top of the G
	drawfillbox (630 - x, 180, 640 - x, 240, 53)     % The left side of the G
	drawfillbox (630 - x, 180, 680 - x, 190, 53)     % The bottom of the G
	drawfillbox (680 - x, 190, 670 - x, 220, 53)     % The centre of the G
	drawfillbox (670 - x, 220, 655 - x, 210, 53)     % The curve of the G

	drawfillbox (-231 + x, 170, -71 + x, 260, white)     % Erase of the Left Musical Note
	drawfillbox (-170 + x, 250, -180 + x, 190, black)     % The Stem of the First Note in the Left Eighth Note
	drawfilloval (-200 + x, 190, 30, 20, black)     % The Notehead of the First Note in the Left Eighth Note
	drawfillbox (-80 + x, 200, -70 + x, 260, black)     % The Stem of the Second Note in the Left Eighth Note
	drawfilloval (-100 + x, 200, 30, 20, black)     % The Notehead of the Second Note in the Left Eighth Note
	drawline (-80 + x, 260, -170 + x, 250, black)     % Top Line of the Left Bar
	drawline (-80 + x, 250, -170 + x, 240, black)     % Bottom Line of the Left Bar
	drawfill (-120 + x, 250, black, black)     % Fill of the Bar

	drawfillbox (871 - x, 170, 709 - x, 260, white)     % Erase of the Right Musical Note
	drawfillbox (710 - x, 200, 720 - x, 260, black)     % The Stem of the First Note in the Right Eighth Note
	drawfilloval (740 - x, 200, 30, 20, black)     % The Notehead of the First Note in the Right Eighth Note
	drawfillbox (810 - x, 190, 820 - x, 250, black)     % The Stem of the Second Note in the Right Eighth Note
	drawfilloval (840 - x, 190, 30, 20, black)     % The Notehead of the Second Note in the Right Eighth Note
	drawline (810 - x, 250, 720 - x, 260, black)     % Top Line of the Left Bar
	drawline (810 - x, 240, 720 - x, 250, black)     % Bottom Line of the Left Bar
	drawfill (770 - x, 250, black, black)     % Fill of the Bar
	delay (8)
    end for
    % Static Drawing of the Logo
    for x : 0 .. 10
	drawline (260, 240 + x, 310, 240 + x, 42)     % The top of the S
	drawline (260 + x, 210, 260 + x, 240, 42)     % The left side of the S
	drawline (260, 210 + x, 310, 210 + x, 42)     % The middle of the S
	drawline (300 + x, 190, 300 + x, 220, 42)     % The right side of the S
	drawline (310, 180 + x, 260, 180 + x, 42)     % The bottom of the S

	drawline (330, 240 + x, 380, 240 + x, 53)     % The top of the G
	drawline (330 + x, 180, 330 + x, 240, 53)     % The left side of the G
	drawline (330, 180 + x, 380, 180 + x, 53)     % The bottom of the G
	drawline (370 + x, 190, 370 + x, 220, 53)     % The centre of the G
	drawline (370, 210 + x, 355, 210 + x, 53)     % The curve of the G

	drawline (120 + x, 250, 120 + x, 190, black)     % The Stem of the First Note in the Left Eighth Note
	drawfillbox (220 + x, 200, 220 + x, 260, black)     % The Stem of the Second Note in the Left Eighth Note
	drawline (220 + x, 250 + x, 130, 240 + x, black)     % The Left Bar

	drawfillbox (410 + x, 200, 410 + x, 260, black)     % The Stem of the First Note in the Right Eighth Note
	drawfillbox (510 + x, 190, 510 + x, 250, black)     % The Stem of the Second Note in the Right Eighth Note
	drawline (510, 240 + x, 420, 250 + x, black)     % The Left Bar
    end for
    for x : 0 .. 30
	drawoval (100, 190, 30 - x, 20, black)     % The Notehead of the First Note in the Left Eighth Note
	drawoval (200, 200, 30 - x, 20, black)     % The Notehead of the Second Note in the Left Eighth Note
	drawoval (440, 200, 30 - x, 20, black)     % The Notehead of the First Note in the Right Eighth Note
	drawoval (540, 190, 30 - x, 20, black)     % The Notehead of the Second Note in the Right Eighth Note
    end for
    Music.PlayFile ("LogoMusic.mp3")
    mainMenuButton := GUI.CreateButton (255, 300, 0, "Go to Main Menu", mainMenu)
end introduction

% The process that will be forked in the mainMenu to play music
process menuMusic
    Music.PlayFileLoop ("MenuMusic.mp3")
end menuMusic

% The main menu of the game, where the user can choose which level they want to play, learn how to play the game, or exit the game
body procedure mainMenu
    Music.PlayFileStop
    title
    GUI.Hide (mainMenuButton)
    correctGuesses := 0
    tries := 1
    for x : 1 .. 30
	playedSong (x) := false
    end for
    GUI.Show (easyButton)
    GUI.Show (normalButton)
    GUI.Show (hardButton)
    GUI.Show (instructionsButton)
    GUI.Show (quitButton)
    % Static Drawing of the Logo
    for x : 0 .. 10
	drawline (260, 190 + x, 310, 190 + x, 42)         % The top of the S
	drawline (260 + x, 160, 260 + x, 190, 42)         % The left side of the S
	drawline (260, 160 + x, 310, 160 + x, 42)         % The middle of the S
	drawline (300 + x, 140, 300 + x, 170, 42)         % The right side of the S
	drawline (310, 130 + x, 260, 130 + x, 42)         % The bottom of the S

	drawline (330, 190 + x, 380, 190 + x, 53)         % The top of the G
	drawline (330 + x, 130, 330 + x, 190, 53)         % The left side of the G
	drawline (330, 130 + x, 380, 130 + x, 53)         % The bottom of the G
	drawline (370 + x, 140, 370 + x, 170, 53)         % The centre of the G
	drawline (370, 160 + x, 355, 160 + x, 53)         % The curve of the G

	drawline (120 + x, 200, 120 + x, 140, black)         % The Stem of the First Note in the Left Eighth Note
	drawfillbox (220 + x, 150, 220 + x, 210, black)         % The Stem of the Second Note in the Left Eighth Note
	drawline (220 + x, 200 + x, 130, 190 + x, black)         % The Left Bar

	drawfillbox (410 + x, 150, 410 + x, 210, black)         % The Stem of the First Note in the Right Eighth Note
	drawfillbox (510 + x, 140, 510 + x, 200, black)         % The Stem of the Second Note in the Right Eighth Note
	drawline (510, 190 + x, 420, 200 + x, black)         % The Left Bar
    end for
    for x : 0 .. 30
	drawoval (100, 140, 30 - x, 20, black)         % The Notehead of the First Note in the Left Eighth Note
	drawoval (200, 150, 30 - x, 20, black)         % The Notehead of the Second Note in the Left Eighth Note
	drawoval (440, 150, 30 - x, 20, black)         % The Notehead of the First Note in the Right Eighth Note
	drawoval (540, 140, 30 - x, 20, black)         % The Notehead of the Second Note in the Right Eighth Note

	drawoval (100, 140, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the First Note in the Left Eighth Note
	drawoval (200, 150, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the Second Note in the Left Eighth Note
	drawoval (440, 150, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the First Note in the Right Eighth Note
	drawoval (540, 140, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the Second Note in the Right Eighth Note
    end for
    fork menuMusic
end mainMenu

% The process that will be forked in the instructions to play music
process instructionsMusic
    Music.PlayFileLoop ("JeopardyTheme.mp3")
end instructionsMusic

% The instructions of the game
body procedure instructions
    Music.PlayFileStop
    title
    GUI.Hide (easyButton)
    GUI.Hide (normalButton)
    GUI.Hide (hardButton)
    GUI.Hide (instructionsButton)
    GUI.Hide (quitButton)
    GUI.Show (mainMenuButton)
    var picture := Pic.FileNew ("Microphone.jpg")
    Pic.Draw (picture, 275, 330, picCopy)
    Pic.Free (picture)
    % Static Drawing of the Logo
    for x : 0 .. 10
	drawline (260, 180 + x, 310, 180 + x, 42)         % The top of the S
	drawline (260 + x, 150, 260 + x, 180, 42)         % The left side of the S
	drawline (260, 150 + x, 310, 150 + x, 42)         % The middle of the S
	drawline (300 + x, 130, 300 + x, 160, 42)         % The right side of the S
	drawline (310, 120 + x, 260, 120 + x, 42)         % The bottom of the S

	drawline (330, 180 + x, 380, 180 + x, 53)         % The top of the G
	drawline (330 + x, 120, 330 + x, 180, 53)         % The left side of the G
	drawline (330, 120 + x, 380, 120 + x, 53)         % The bottom of the G
	drawline (370 + x, 130, 370 + x, 160, 53)         % The centre of the G
	drawline (370, 150 + x, 355, 150 + x, 53)         % The curve of the G

	drawline (120 + x, 190, 120 + x, 130, black)         % The Stem of the First Note in the Left Eighth Note
	drawfillbox (220 + x, 140, 220 + x, 200, black)         % The Stem of the Second Note in the Left Eighth Note
	drawline (220 + x, 190 + x, 130, 180 + x, black)         % The Left Bar

	drawfillbox (410 + x, 140, 410 + x, 200, black)         % The Stem of the First Note in the Right Eighth Note
	drawfillbox (510 + x, 130, 510 + x, 190, black)         % The Stem of the Second Note in the Right Eighth Note
	drawline (510, 180 + x, 420, 190 + x, black)         % The Left Bar
    end for
    for x : 0 .. 30
	drawoval (100, 130, 30 - x, 20, black)         % The Notehead of the First Note in the Left Eighth Note
	drawoval (200, 140, 30 - x, 20, black)         % The Notehead of the Second Note in the Left Eighth Note
	drawoval (440, 140, 30 - x, 20, black)         % The Notehead of the First Note in the Right Eighth Note
	drawoval (540, 130, 30 - x, 20, black)         % The Notehead of the Second Note in the Right Eighth Note

	drawoval (100, 130, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the First Note in the Left Eighth Note
	drawoval (200, 140, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the Second Note in the Left Eighth Note
	drawoval (440, 140, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the First Note in the Right Eighth Note
	drawoval (540, 130, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the Second Note in the Right Eighth Note
    end for
    locate (8, 40 - length ("Try to guess a song by listening to a short melody!") div 2)
    put "Try to guess a song by listening to a short melody!"
    locate (9, 40 - length ("Each level will have 5 songs for you to guess.") div 2)
    put "Each level will have 5 songs for you to guess."
    locate (10, 40 - length ("Each melody will have 4 options for you to choose from.") div 2)
    put "Each melody will have 4 options for you to choose from."
    locate (11, 40 - length ("The length of each melody will be shorter in more difficult levels.") div 2)
    put "The length of each melody will be shorter in more difficult levels."
    locate (12, 40 - length ("Good luck!") div 2)
    put "Good luck!" ..
    fork instructionsMusic
end instructions

% The Easy Level of the game
body procedure userInputEasy
    Music.PlayFileStop
    title
    GUI.Hide (easyButton)
    GUI.Hide (normalButton)
    GUI.Hide (hardButton)
    GUI.Hide (instructionsButton)
    GUI.Hide (quitButton)
    randint (songChoice, 1, 10)
    % Static Drawing of the Logo
    for x : 0 .. 10
	drawline (260, 190 + x, 310, 190 + x, 42)         % The top of the S
	drawline (260 + x, 160, 260 + x, 190, 42)         % The left side of the S
	drawline (260, 160 + x, 310, 160 + x, 42)         % The middle of the S
	drawline (300 + x, 140, 300 + x, 170, 42)         % The right side of the S
	drawline (310, 130 + x, 260, 130 + x, 42)         % The bottom of the S

	drawline (330, 190 + x, 380, 190 + x, 53)         % The top of the G
	drawline (330 + x, 130, 330 + x, 190, 53)         % The left side of the G
	drawline (330, 130 + x, 380, 130 + x, 53)         % The bottom of the G
	drawline (370 + x, 140, 370 + x, 170, 53)         % The centre of the G
	drawline (370, 160 + x, 355, 160 + x, 53)         % The curve of the G

	drawline (120 + x, 200, 120 + x, 140, black)         % The Stem of the First Note in the Left Eighth Note
	drawfillbox (220 + x, 150, 220 + x, 210, black)         % The Stem of the Second Note in the Left Eighth Note
	drawline (220 + x, 200 + x, 130, 190 + x, black)         % The Left Bar

	drawfillbox (410 + x, 150, 410 + x, 210, black)         % The Stem of the First Note in the Right Eighth Note
	drawfillbox (510 + x, 140, 510 + x, 200, black)         % The Stem of the Second Note in the Right Eighth Note
	drawline (510, 190 + x, 420, 200 + x, black)         % The Left Bar
    end for
    for x : 0 .. 30
	drawoval (100, 140, 30 - x, 20, black)         % The Notehead of the First Note in the Left Eighth Note
	drawoval (200, 150, 30 - x, 20, black)         % The Notehead of the Second Note in the Left Eighth Note
	drawoval (440, 150, 30 - x, 20, black)         % The Notehead of the First Note in the Right Eighth Note
	drawoval (540, 140, 30 - x, 20, black)         % The Notehead of the Second Note in the Right Eighth Note

	drawoval (100, 140, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the First Note in the Left Eighth Note
	drawoval (200, 150, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the Second Note in the Left Eighth Note
	drawoval (440, 150, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the First Note in the Right Eighth Note
	drawoval (540, 140, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the Second Note in the Right Eighth Note
    end for
    % This if statement determines if the user has clicked replay song or not
    if replayed = true then
	tries := tries - 1
	songChoice := replayedSong
	playedSong (songChoice) := false
	replayed := false
    end if
    if tries not= 6 then
	locate (3, 40 - length ("Song ## - Easy") div 2)
	put "Song #", tries, " - Easy"
	if playedSong (songChoice) = false then
	    tries := tries + 1
	    playedSong (songChoice) := true
	    optionReplay := GUI.CreateButton (270, 240, 0, "Replay Song", replaySong)
	    if songChoice = 1 then
		% Despacito
		optionOne := GUI.CreateButton (230, 320, 0, "Havana", buttonDisposal)
		optionTwo := GUI.CreateButton (320, 320, 0, "Despacito", correctGuess)
		optionThree := GUI.CreateButton (190, 280, 0, "Almost Like Praying", buttonDisposal)
		optionFour := GUI.CreateButton (340, 280, 0, "Échame la Culpa", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 2 then
		% Attention
		optionOne := GUI.CreateButton (200, 320, 0, "One Call Away", buttonDisposal)
		optionTwo := GUI.CreateButton (320, 320, 0, "See You Again", buttonDisposal)
		optionThree := GUI.CreateButton (190, 280, 0, "We Don't Talk Anymore", buttonDisposal)
		optionFour := GUI.CreateButton (360, 280, 0, "Attention", correctGuess)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 3 then
		% One Dance
		optionOne := GUI.CreateButton (180, 320, 0, "Hold On, We're Going Home", buttonDisposal)
		optionTwo := GUI.CreateButton (370, 320, 0, "Hotline Bling", buttonDisposal)
		optionThree := GUI.CreateButton (210, 280, 0, "One Dance", correctGuess)
		optionFour := GUI.CreateButton (310, 280, 0, "Started From the Bottom", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 4 then
		% Don't Wanna Know
		optionOne := GUI.CreateButton (180, 320, 0, "Don't Wanna Know", correctGuess)
		optionTwo := GUI.CreateButton (330, 320, 0, "Moves Like Jagger", buttonDisposal)
		optionThree := GUI.CreateButton (240, 280, 0, "Payphone", buttonDisposal)
		optionFour := GUI.CreateButton (340, 280, 0, "Sugar", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 5 then
		% All of Me
		optionOne := GUI.CreateButton (210, 320, 0, "Love Me Now", buttonDisposal)
		optionTwo := GUI.CreateButton (320, 320, 0, "Like I'm Gonna Lose You", buttonDisposal)
		optionThree := GUI.CreateButton (240, 280, 0, "All of Me", correctGuess)
		optionFour := GUI.CreateButton (330, 280, 0, "Stay With Me", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 6 then
		% Send my Love
		optionOne := GUI.CreateButton (210, 320, 0, "Skyfall", buttonDisposal)
		optionTwo := GUI.CreateButton (290, 320, 0, "Rolling in the Deep", buttonDisposal)
		optionThree := GUI.CreateButton (230, 280, 0, "Send My Love", correctGuess)
		optionFour := GUI.CreateButton (350, 280, 0, "Hello", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 7 then
		% Believer
		optionOne := GUI.CreateButton (230, 320, 0, "Radioactive", buttonDisposal)
		optionTwo := GUI.CreateButton (330, 320, 0, "Believer", correctGuess)
		optionThree := GUI.CreateButton (230, 280, 0, "Thunder", buttonDisposal)
		optionFour := GUI.CreateButton (320, 280, 0, "Demons", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 8 then
		% The Greatest
		optionOne := GUI.CreateButton (230, 320, 0, "Chandelier", buttonDisposal)
		optionTwo := GUI.CreateButton (330, 320, 0, "Elastic Heart", buttonDisposal)
		optionThree := GUI.CreateButton (210, 280, 0, "Cheap Thrills", buttonDisposal)
		optionFour := GUI.CreateButton (320, 280, 0, "The Greatest", correctGuess)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 9 then
		% Beautiful Now
		optionOne := GUI.CreateButton (230, 320, 0, "Beautiful Now", correctGuess)
		optionTwo := GUI.CreateButton (350, 320, 0, "Clarity", buttonDisposal)
		optionThree := GUI.CreateButton (240, 280, 0, "Ignite", buttonDisposal)
		optionFour := GUI.CreateButton (320, 280, 0, "True Colours", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    else
		% Lights Out
		optionOne := GUI.CreateButton (230, 320, 0, "We Are Stars", buttonDisposal)
		optionTwo := GUI.CreateButton (340, 320, 0, "Selfish", buttonDisposal)
		optionThree := GUI.CreateButton (190, 280, 0, "Lights Out", correctGuess)
		optionFour := GUI.CreateButton (290, 280, 0, "Don't Fight the Music", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    end if
	else
	    userInputEasy
	end if
    else
	buttonDisposal
    end if
end userInputEasy

% The Normal Level of the game
body procedure userInputNormal
    Music.PlayFileStop
    title
    GUI.Hide (easyButton)
    GUI.Hide (normalButton)
    GUI.Hide (hardButton)
    GUI.Hide (instructionsButton)
    GUI.Hide (quitButton)
    randint (songChoice, 11, 20)
    % Static Drawing of the Logo
    for x : 0 .. 10
	drawline (260, 190 + x, 310, 190 + x, 42)         % The top of the S
	drawline (260 + x, 160, 260 + x, 190, 42)         % The left side of the S
	drawline (260, 160 + x, 310, 160 + x, 42)         % The middle of the S
	drawline (300 + x, 140, 300 + x, 170, 42)         % The right side of the S
	drawline (310, 130 + x, 260, 130 + x, 42)         % The bottom of the S

	drawline (330, 190 + x, 380, 190 + x, 53)         % The top of the G
	drawline (330 + x, 130, 330 + x, 190, 53)         % The left side of the G
	drawline (330, 130 + x, 380, 130 + x, 53)         % The bottom of the G
	drawline (370 + x, 140, 370 + x, 170, 53)         % The centre of the G
	drawline (370, 160 + x, 355, 160 + x, 53)         % The curve of the G

	drawline (120 + x, 200, 120 + x, 140, black)         % The Stem of the First Note in the Left Eighth Note
	drawfillbox (220 + x, 150, 220 + x, 210, black)         % The Stem of the Second Note in the Left Eighth Note
	drawline (220 + x, 200 + x, 130, 190 + x, black)         % The Left Bar

	drawfillbox (410 + x, 150, 410 + x, 210, black)         % The Stem of the First Note in the Right Eighth Note
	drawfillbox (510 + x, 140, 510 + x, 200, black)         % The Stem of the Second Note in the Right Eighth Note
	drawline (510, 190 + x, 420, 200 + x, black)         % The Left Bar
    end for
    for x : 0 .. 30
	drawoval (100, 140, 30 - x, 20, black)         % The Notehead of the First Note in the Left Eighth Note
	drawoval (200, 150, 30 - x, 20, black)         % The Notehead of the Second Note in the Left Eighth Note
	drawoval (440, 150, 30 - x, 20, black)         % The Notehead of the First Note in the Right Eighth Note
	drawoval (540, 140, 30 - x, 20, black)         % The Notehead of the Second Note in the Right Eighth Note

	drawoval (100, 140, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the First Note in the Left Eighth Note
	drawoval (200, 150, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the Second Note in the Left Eighth Note
	drawoval (440, 150, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the First Note in the Right Eighth Note
	drawoval (540, 140, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the Second Note in the Right Eighth Note
    end for
    % This if statement determines if the user has clicked replay song or not
    if replayed = true then
	tries := tries - 1
	songChoice := replayedSong
	playedSong (songChoice) := false
	replayed := false
    end if
    if tries not= 6 then
	locate (3, 40 - length ("Song ## - Normal") div 2)
	put "Song #", tries, " - Normal"
	if playedSong (songChoice) = false then
	    tries := tries + 1
	    playedSong (songChoice) := true
	    optionReplay := GUI.CreateButton (270, 240, 0, "Replay Song", replaySong)
	    if songChoice = 11 then
		% A Whole New World
		optionOne := GUI.CreateButton (200, 320, 0, "Let It Go", buttonDisposal)
		optionTwo := GUI.CreateButton (290, 320, 0, "A Whole New World", correctGuess)
		optionThree := GUI.CreateButton (190, 280, 0, "Beauty and the Beast", buttonDisposal)
		optionFour := GUI.CreateButton (340, 280, 0, "Under the Sea", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 12 then
		% Million Reasons
		optionOne := GUI.CreateButton (230, 320, 0, "Poker Face", buttonDisposal)
		optionTwo := GUI.CreateButton (330, 320, 0, "Bad Romance", buttonDisposal)
		optionThree := GUI.CreateButton (190, 280, 0, "The Edge of Glory", buttonDisposal)
		optionFour := GUI.CreateButton (330, 280, 0, "Million Reasons", correctGuess)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 13 then
		% Love Yourself
		optionOne := GUI.CreateButton (150, 320, 0, "As Long As You Love Me", buttonDisposal)
		optionTwo := GUI.CreateButton (330, 320, 0, "What do you mean?", buttonDisposal)
		optionThree := GUI.CreateButton (210, 280, 0, "Love Yourself", correctGuess)
		optionFour := GUI.CreateButton (330, 280, 0, "Where are U Now", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 14 then
		% Shape of You
		optionOne := GUI.CreateButton (210, 320, 0, "Shape of You", correctGuess)
		optionTwo := GUI.CreateButton (330, 320, 0, "Thinking Out Loud", buttonDisposal)
		optionThree := GUI.CreateButton (230, 280, 0, "Photograph", buttonDisposal)
		optionFour := GUI.CreateButton (340, 280, 0, "Perfect", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 15 then
		% Say You Won't Let Go
		optionOne := GUI.CreateButton (210, 320, 0, "Rockstar", buttonDisposal)
		optionTwo := GUI.CreateButton (300, 320, 0, "Too Good At Goodbyes", buttonDisposal)
		optionThree := GUI.CreateButton (200, 280, 0, "Say You Won't Let Go", correctGuess)
		optionFour := GUI.CreateButton (360, 280, 0, "Wolves", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 16 then
		% Rockabye
		optionOne := GUI.CreateButton (230, 320, 0, "Rather Be", buttonDisposal)
		optionTwo := GUI.CreateButton (330, 320, 0, "Symphony", buttonDisposal)
		optionThree := GUI.CreateButton (230, 280, 0, "Rockabye", correctGuess)
		optionFour := GUI.CreateButton (330, 280, 0, "I Miss You", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 17 then
		% Scars to Your Beautiful
		optionOne := GUI.CreateButton (210, 320, 0, "Here", buttonDisposal)
		optionTwo := GUI.CreateButton (280, 320, 0, "Scars to Your Beautiful", correctGuess)
		optionThree := GUI.CreateButton (230, 280, 0, "Wild Things", buttonDisposal)
		optionFour := GUI.CreateButton (340, 280, 0, "Stay", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 18 then
		% Starboy
		optionOne := GUI.CreateButton (210, 320, 0, "Earned It", buttonDisposal)
		optionTwo := GUI.CreateButton (310, 320, 0, "Can't Feel My Face", buttonDisposal)
		optionThree := GUI.CreateButton (220, 280, 0, "The Hills", buttonDisposal)
		optionFour := GUI.CreateButton (320, 280, 0, "Starboy", correctGuess)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 19 then
		% Stitches
		optionOne := GUI.CreateButton (230, 320, 0, "Stitches", correctGuess)
		optionTwo := GUI.CreateButton (330, 320, 0, "Mercy", buttonDisposal)
		optionThree := GUI.CreateButton (190, 280, 0, "Something Big", buttonDisposal)
		optionFour := GUI.CreateButton (320, 280, 0, "Treat You Better", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    else
		% Crave
		optionOne := GUI.CreateButton (230, 320, 0, "Freedom", buttonDisposal)
		optionTwo := GUI.CreateButton (330, 320, 0, "Happy", buttonDisposal)
		optionThree := GUI.CreateButton (230, 280, 0, "Crave", correctGuess)
		optionFour := GUI.CreateButton (320, 280, 0, "Frontin'", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    end if
	else
	    userInputNormal
	end if
    else
	buttonDisposal
    end if
end userInputNormal

% The Hard Level of the game
body procedure userInputHard
    Music.PlayFileStop
    title
    GUI.Hide (easyButton)
    GUI.Hide (normalButton)
    GUI.Hide (hardButton)
    GUI.Hide (instructionsButton)
    GUI.Hide (quitButton)
    randint (songChoice, 21, 30)
    % Static Drawing of the Logo
    for x : 0 .. 10
	drawline (260, 190 + x, 310, 190 + x, 42)         % The top of the S
	drawline (260 + x, 160, 260 + x, 190, 42)         % The left side of the S
	drawline (260, 160 + x, 310, 160 + x, 42)         % The middle of the S
	drawline (300 + x, 140, 300 + x, 170, 42)         % The right side of the S
	drawline (310, 130 + x, 260, 130 + x, 42)         % The bottom of the S

	drawline (330, 190 + x, 380, 190 + x, 53)         % The top of the G
	drawline (330 + x, 130, 330 + x, 190, 53)         % The left side of the G
	drawline (330, 130 + x, 380, 130 + x, 53)         % The bottom of the G
	drawline (370 + x, 140, 370 + x, 170, 53)         % The centre of the G
	drawline (370, 160 + x, 355, 160 + x, 53)         % The curve of the G

	drawline (120 + x, 200, 120 + x, 140, black)         % The Stem of the First Note in the Left Eighth Note
	drawfillbox (220 + x, 150, 220 + x, 210, black)         % The Stem of the Second Note in the Left Eighth Note
	drawline (220 + x, 200 + x, 130, 190 + x, black)         % The Left Bar

	drawfillbox (410 + x, 150, 410 + x, 210, black)         % The Stem of the First Note in the Right Eighth Note
	drawfillbox (510 + x, 140, 510 + x, 200, black)         % The Stem of the Second Note in the Right Eighth Note
	drawline (510, 190 + x, 420, 200 + x, black)         % The Left Bar
    end for
    for x : 0 .. 30
	drawoval (100, 140, 30 - x, 20, black)         % The Notehead of the First Note in the Left Eighth Note
	drawoval (200, 150, 30 - x, 20, black)         % The Notehead of the Second Note in the Left Eighth Note
	drawoval (440, 150, 30 - x, 20, black)         % The Notehead of the First Note in the Right Eighth Note
	drawoval (540, 140, 30 - x, 20, black)         % The Notehead of the Second Note in the Right Eighth Note

	drawoval (100, 140, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the First Note in the Left Eighth Note
	drawoval (200, 150, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the Second Note in the Left Eighth Note
	drawoval (440, 150, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the First Note in the Right Eighth Note
	drawoval (540, 140, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the Second Note in the Right Eighth Note
    end for
    % This if statement determines if the user has clicked replay song or not
    if replayed = true then
	tries := tries - 1
	songChoice := replayedSong
	playedSong (songChoice) := false
	replayed := false
    end if
    if tries not= 6 then
	locate (3, 40 - length ("Song ## - Hard") div 2)
	put "Song #", tries, " - Hard"
	if playedSong (songChoice) = false then
	    tries := tries + 1
	    playedSong (songChoice) := true
	    optionReplay := GUI.CreateButton (270, 240, 0, "Replay Song", replaySong)
	    if songChoice = 21 then
		% Electric Love
		optionOne := GUI.CreateButton (230, 320, 0, "Stompa", buttonDisposal)
		optionTwo := GUI.CreateButton (320, 320, 0, "Electric Love", correctGuess)
		optionThree := GUI.CreateButton (190, 280, 0, "What I Wouldn't Do", buttonDisposal)
		optionFour := GUI.CreateButton (340, 280, 0, "Together We Are One", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 22 then
		% HandClap
		optionOne := GUI.CreateButton (220, 320, 0, "How Long", buttonDisposal)
		optionTwo := GUI.CreateButton (320, 320, 0, "Feel It Still", buttonDisposal)
		optionThree := GUI.CreateButton (190, 280, 0, "Sorry Not Sorry", buttonDisposal)
		optionFour := GUI.CreateButton (330, 280, 0, "HandClap", correctGuess)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 23 then
		% Jar of Hearts
		optionOne := GUI.CreateButton (210, 320, 0, "Be My Forever", buttonDisposal)
		optionTwo := GUI.CreateButton (340, 320, 0, "Human", buttonDisposal)
		optionThree := GUI.CreateButton (210, 280, 0, "Jar of Hearts", correctGuess)
		optionFour := GUI.CreateButton (320, 280, 0, "A Thousand Years", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 24 then
		% Seasons of Love
		optionOne := GUI.CreateButton (180, 320, 0, "Seasons of Love", correctGuess)
		optionTwo := GUI.CreateButton (310, 320, 0, "Alexander Hamilton", buttonDisposal)
		optionThree := GUI.CreateButton (220, 280, 0, "What Time Is It", buttonDisposal)
		optionFour := GUI.CreateButton (340, 280, 0, "Tomorrow", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 25 then
		% Shake It Off
		optionOne := GUI.CreateButton (210, 320, 0, "Blank Space", buttonDisposal)
		optionTwo := GUI.CreateButton (320, 320, 0, "Look What You Made Me Do", buttonDisposal)
		optionThree := GUI.CreateButton (220, 280, 0, "Shake It Off", correctGuess)
		optionFour := GUI.CreateButton (330, 280, 0, "Gorgeous", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 26 then
		% Bad liar
		optionOne := GUI.CreateButton (210, 320, 0, "It Ain't Me", buttonDisposal)
		optionTwo := GUI.CreateButton (310, 320, 0, "I'm Trying", buttonDisposal)
		optionThree := GUI.CreateButton (220, 280, 0, "Bad Liar", correctGuess)
		optionFour := GUI.CreateButton (310, 280, 0, "Hands to Myself", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 27 then
		% Immortals
		optionOne := GUI.CreateButton (230, 320, 0, "Woahhhhhh", buttonDisposal)
		optionTwo := GUI.CreateButton (330, 320, 0, "Immortals", correctGuess)
		optionThree := GUI.CreateButton (230, 280, 0, "Centuries", buttonDisposal)
		optionFour := GUI.CreateButton (320, 280, 0, "Warriors", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 28 then
		% Beat It
		optionOne := GUI.CreateButton (190, 320, 0, "Man in the Mirror", buttonDisposal)
		optionTwo := GUI.CreateButton (330, 320, 0, "Billie Jean", buttonDisposal)
		optionThree := GUI.CreateButton (230, 280, 0, "Thriller", buttonDisposal)
		optionFour := GUI.CreateButton (320, 280, 0, "Beat It", correctGuess)
		Music.PlayFile (whichSong (songChoice))
	    elsif songChoice = 29 then
		% The lazy Song
		optionOne := GUI.CreateButton (210, 320, 0, "The Lazy Song", correctGuess)
		optionTwo := GUI.CreateButton (330, 320, 0, "24K Magic", buttonDisposal)
		optionThree := GUI.CreateButton (210, 280, 0, "Grenade", buttonDisposal)
		optionFour := GUI.CreateButton (300, 280, 0, "That's What I Like", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    else
		% You're Welcome
		optionOne := GUI.CreateButton (230, 320, 0, "I Won't Say", buttonDisposal)
		optionTwo := GUI.CreateButton (340, 320, 0, "My Shot", buttonDisposal)
		optionThree := GUI.CreateButton (190, 280, 0, "You're Welcome", correctGuess)
		optionFour := GUI.CreateButton (320, 280, 0, "Colours of the Wind", buttonDisposal)
		Music.PlayFile (whichSong (songChoice))
	    end if
	else
	    userInputHard
	end if
    else
	buttonDisposal
    end if
end userInputHard

% Allows the song to be replayed
body procedure replaySong
    replayedSong := songChoice
    replayed := true
    GUI.Dispose (optionOne)
    GUI.Dispose (optionTwo)
    GUI.Dispose (optionThree)
    GUI.Dispose (optionFour)
    GUI.Dispose (optionReplay)
    if songChoice >= 1 and songChoice <= 10 then
	userInputEasy
    elsif songChoice >= 11 and songChoice <= 20 then
	userInputNormal
    else
	userInputHard
    end if
end replaySong

% Disposes the option buttons each time the user takes a guess to prevent ghost buttons, then goes back to the correct level of the game
body procedure buttonDisposal
    GUI.Dispose (optionOne)
    GUI.Dispose (optionTwo)
    GUI.Dispose (optionThree)
    GUI.Dispose (optionFour)
    GUI.Dispose (optionReplay)
    if tries = 6 then
	tries := 1
	displayProcessing
    elsif songChoice >= 1 and songChoice <= 10 then
	userInputEasy
    elsif songChoice >= 11 and songChoice <= 20 then
	userInputNormal
    else
	userInputHard
    end if
end buttonDisposal

% Adds 1 to the variable correct guess when the user guesses correctly, then goes to buttonDisposal
body procedure correctGuess
    correctGuesses := correctGuesses + 1
    buttonDisposal
end correctGuess

% The process that will be forked to play music in displayProcessing
process winningMusic
    Music.PlayFileLoop ("WinningMusic.mp3")
end winningMusic

% Calculates and displays the user's score as a percent
body procedure displayProcessing
    title
    % Static Drawing of the Logo
    for x : 0 .. 10
	drawline (260, 240 + x, 310, 240 + x, 42)         % The top of the S
	drawline (260 + x, 210, 260 + x, 240, 42)         % The left side of the S
	drawline (260, 210 + x, 310, 210 + x, 42)         % The middle of the S
	drawline (300 + x, 190, 300 + x, 220, 42)         % The right side of the S
	drawline (310, 180 + x, 260, 180 + x, 42)         % The bottom of the S

	drawline (330, 240 + x, 380, 240 + x, 53)         % The top of the G
	drawline (330 + x, 180, 330 + x, 240, 53)         % The left side of the G
	drawline (330, 180 + x, 380, 180 + x, 53)         % The bottom of the G
	drawline (370 + x, 190, 370 + x, 220, 53)         % The centre of the G
	drawline (370, 210 + x, 355, 210 + x, 53)         % The curve of the G

	drawline (120 + x, 250, 120 + x, 190, black)         % The Stem of the First Note in the Left Eighth Note
	drawfillbox (220 + x, 200, 220 + x, 260, black)         % The Stem of the Second Note in the Left Eighth Note
	drawline (220 + x, 250 + x, 130, 240 + x, black)         % The Left Bar

	drawfillbox (410 + x, 200, 410 + x, 260, black)         % The Stem of the First Note in the Right Eighth Note
	drawfillbox (510 + x, 190, 510 + x, 250, black)         % The Stem of the Second Note in the Right Eighth Note
	drawline (510, 240 + x, 420, 250 + x, black)         % The Left Bar
    end for
    for x : 0 .. 30
	drawoval (100, 190, 30 - x, 20, black)         % The Notehead of the First Note in the Left Eighth Note
	drawoval (200, 200, 30 - x, 20, black)         % The Notehead of the Second Note in the Left Eighth Note
	drawoval (440, 200, 30 - x, 20, black)         % The Notehead of the First Note in the Right Eighth Note
	drawoval (540, 190, 30 - x, 20, black)         % The Notehead of the Second Note in the Right Eighth Note

	drawoval (100, 190, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the First Note in the Left Eighth Note
	drawoval (200, 200, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the Second Note in the Left Eighth Note
	drawoval (440, 200, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the First Note in the Right Eighth Note
	drawoval (540, 190, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the Second Note in the Right Eighth Note
    end for
    var correctPercent : real := correctGuesses / 5 * 100
    locate (3, 40 - length ("You guessed ##% of the songs correctly!") div 2)
    put "You guessed ", correctPercent, "% of the songs correctly!"
    GUI.Show (mainMenuButton)
    if correctPercent = 100 then
	locate (4, 40 - length ("That's a perfect score! Congratulations!") div 2)
	put "That's a perfect score! Congratulations!"
    elsif correctPercent = 80 then
	locate (4, 40 - length ("That's pretty good! Congratulations!") div 2)
	put "That's pretty good! Congratulations!"
    elsif correctPercent = 60 then
	locate (4, 40 - length ("That's not bad. Keep up the good effort!") div 2)
	put "That's not bad. Keep up the good effort!"
    elsif correctPercent = 40 then
	locate (4, 40 - length ("There's room for improvement. Keep it up!") div 2)
	put "There's room for improvement. Keep it up!"
    elsif correctPercent = 20 then
	locate (4, 40 - length ("Surely you can be better than that. Put more effort into it!") div 2)
	put "Surely you can be better than that. Put more effort into it!"
    else
	locate (4, 40 - length ("Not even one correct? All hope is lost.") div 2)
	put "Not even one correct? All hope is lost."
    end if
    fork winningMusic
end displayProcessing

% Displays an ending message and closes the window
procedure goodbye
    Music.PlayFileStop
    title
    locate (3, 40 - length ("Thank you for playing Song Guesser!") div 2)
    put "Thank you for playing Song Guesser!"
    locate (5, 40 - length ("Programmer: Kevin Nguyen") div 2)
    put "Programmer: Kevin Nguyen"
    % Static Drawing of the Logo
    for x : 0 .. 10
	drawline (260, 240 + x, 310, 240 + x, 42)         % The top of the S
	drawline (260 + x, 210, 260 + x, 240, 42)         % The left side of the S
	drawline (260, 210 + x, 310, 210 + x, 42)         % The middle of the S
	drawline (300 + x, 190, 300 + x, 220, 42)         % The right side of the S
	drawline (310, 180 + x, 260, 180 + x, 42)         % The bottom of the S

	drawline (330, 240 + x, 380, 240 + x, 53)         % The top of the G
	drawline (330 + x, 180, 330 + x, 240, 53)         % The left side of the G
	drawline (330, 180 + x, 380, 180 + x, 53)         % The bottom of the G
	drawline (370 + x, 190, 370 + x, 220, 53)         % The centre of the G
	drawline (370, 210 + x, 355, 210 + x, 53)         % The curve of the G

	drawline (120 + x, 250, 120 + x, 190, black)         % The Stem of the First Note in the Left Eighth Note
	drawfillbox (220 + x, 200, 220 + x, 260, black)         % The Stem of the Second Note in the Left Eighth Note
	drawline (220 + x, 250 + x, 130, 240 + x, black)         % The Left Bar

	drawfillbox (410 + x, 200, 410 + x, 260, black)         % The Stem of the First Note in the Right Eighth Note
	drawfillbox (510 + x, 190, 510 + x, 250, black)         % The Stem of the Second Note in the Right Eighth Note
	drawline (510, 240 + x, 420, 250 + x, black)         % The Left Bar
    end for
    for x : 0 .. 30
	drawoval (100, 190, 30 - x, 20, black)         % The Notehead of the First Note in the Left Eighth Note
	drawoval (200, 200, 30 - x, 20, black)         % The Notehead of the Second Note in the Left Eighth Note
	drawoval (440, 200, 30 - x, 20, black)         % The Notehead of the First Note in the Right Eighth Note
	drawoval (540, 190, 30 - x, 20, black)         % The Notehead of the Second Note in the Right Eighth Note

	drawoval (100, 190, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the First Note in the Left Eighth Note
	drawoval (200, 200, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the Second Note in the Left Eighth Note
	drawoval (440, 200, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the First Note in the Right Eighth Note
	drawoval (540, 190, 30, 20 - x, black)         % The ARTIFACT ERASE of the Notehead of the Second Note in the Right Eighth Note
    end for
    % Static Stage
    for x : 0 .. 320
	drawbox (0 + x, 0, 640 - x, 9, 186)
    end for
    % Stage lines
    drawline (320, 0, 320, 9, black) % Middle Line

    % Right Lines
    drawline (360, 0, 360, 9, black)
    drawline (400, 0, 400, 9, black)
    drawline (440, 0, 440, 9, black)
    drawline (480, 0, 480, 9, black)
    drawline (520, 0, 520, 9, black)
    drawline (560, 0, 560, 9, black)
    drawline (600, 0, 600, 9, black)

    % Left lines
    drawline (280, 0, 280, 9, black)
    drawline (240, 0, 240, 9, black)
    drawline (200, 0, 200, 9, black)
    drawline (160, 0, 160, 9, black)
    drawline (120, 0, 120, 9, black)
    drawline (80, 0, 80, 9, black)
    drawline (40, 0, 40, 9, black)

    Music.PlayFile ("LogoMusic.mp3")
    fork curtainMusic

    % Closing the Curtains
    for x : 0 .. 350
	drawfillbox (-31 + x, 10, -349 + x, 400, white)     % Erase of Left Curtain
	drawfillbox (-30 + x, 20, -350 + x, 400, red)     % Left Curtain

	% Bottom of the Left Curtain
	drawfilloval (-50 + x, 20, 20, 10, red)
	drawfilloval (-90 + x, 20, 20, 10, red)
	drawfilloval (-130 + x, 20, 20, 10, red)
	drawfilloval (-170 + x, 20, 20, 10, red)
	drawfilloval (-210 + x, 20, 20, 10, red)
	drawfilloval (-250 + x, 20, 20, 10, red)
	drawfilloval (-290 + x, 20, 20, 10, red)
	drawfilloval (-330 + x, 20, 20, 10, red)
	drawfilloval (-370 + x, 20, 20, 10, red)

	% Lines of the Left Curtain
	drawline (-70 + x, 20, -70 + x, 400, black)
	drawline (-110 + x, 20, -110 + x, 400, black)
	drawline (-150 + x, 20, -150 + x, 400, black)
	drawline (-190 + x, 20, -190 + x, 400, black)
	drawline (-230 + x, 20, -230 + x, 400, black)
	drawline (-270 + x, 20, -270 + x, 400, black)
	drawline (-310 + x, 20, -310 + x, 400, black)

	drawfillbox (671 - x, 10, 991 - x, 400, white)     % Erase of Right Curtain
	drawfillbox (670 - x, 20, 990 - x, 400, red)     % Right Curtain

	% Bottom of the Right Curtain
	drawfilloval (690 - x, 20, 20, 10, red)
	drawfilloval (730 - x, 20, 20, 10, red)
	drawfilloval (770 - x, 20, 20, 10, red)
	drawfilloval (810 - x, 20, 20, 10, red)
	drawfilloval (850 - x, 20, 20, 10, red)
	drawfilloval (890 - x, 20, 20, 10, red)
	drawfilloval (930 - x, 20, 20, 10, red)
	drawfilloval (970 - x, 20, 20, 10, red)
	drawfilloval (1010 - x, 20, 20, 10, red)

	% Lines of the Right Curtain
	drawline (710 - x, 20, 710 - x, 400, black)
	drawline (750 - x, 20, 750 - x, 400, black)
	drawline (790 - x, 20, 790 - x, 400, black)
	drawline (830 - x, 20, 830 - x, 400, black)
	drawline (870 - x, 20, 870 - x, 400, black)
	drawline (910 - x, 20, 910 - x, 400, black)
	drawline (950 - x, 20, 950 - x, 400, black)
	delay (16)
    end for
    drawline (320, 20, 320, 400, black)
    delay (1000)
    Window.Close (mainWin)
end goodbye

% Main Program
introduction
loop
    exit when GUI.ProcessEvent
end loop
goodbye
% End of Main Program
