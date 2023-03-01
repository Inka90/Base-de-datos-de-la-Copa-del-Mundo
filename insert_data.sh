#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_G OPPONENT_G
do
  if [[ $WINNER != "winner" ]]
  then
      # get name_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    # if not found
    if [[ -z $WINNER_ID ]]
    then
      # insert name
      INSERT_W=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_W == "INSERT 0 1" ]]
      then
        echo winners inserted into teams, $WINNER
      fi
    fi

    # get new WINNER_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  fi

  if [[ $OPPONENT != "opponent" ]]
  then
      # get name_id
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # if not found
    if [[ -z $OPP_ID ]]
    then
      # insert name
      INSERT_OPP=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPP == "INSERT 0 1" ]]
      then
        echo opponents inserted into teams, $OPPONENT
      fi
    fi
     # get name_id
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi

  if [[ $YEAR != "year" ]]
  then
    # insert name
      INSERT_GAME=$($PSQL "INSERT INTO games(year, winner_id, opponent_id, winner_goals, opponent_goals, round) VALUES($YEAR, $WINNER_ID, $OPP_ID, $WINNER_G, $OPPONENT_G, '$ROUND')")
      if [[ $INSERT_GAME == "INSERT 0 1" ]]
      then
        echo games inserted into teams, $YEAR $WINNER_ID $OPP_ID
      fi
      
  fi


done
