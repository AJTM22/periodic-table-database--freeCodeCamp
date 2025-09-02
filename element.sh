#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

# If script run with no argument, output should be "Please provide an element as an argument" and finish running
if [[ -z $1 ]];
then
echo Please provide an element as an argument.

else
  if [[ $1 =~ ^[0-9]+$ ]]; then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1;")
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]; then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1';")
  elif [[ $1 =~ ^[A-Za-z]+$ ]]; then
  ATOMIC_NUMBER=$($PSQL " SELECT atomic_number FROM elements WHERE name = '$1';")
  fi

    # If script run with invalid argument, output should be "I could not find that element in the database"
    if [[ -z $ATOMIC_NUMBER ]];
    then
    echo I could not find that element in the database.

    # If script run with a valid argument, either atomic number, symbol, or element name, it should output the element and its properties. Sample output: "The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius."
    else
    ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER;")
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER;")
    ELEMENT_TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    ELEMENT_TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $ELEMENT_TYPE_ID;")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")

    echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    fi
fi

