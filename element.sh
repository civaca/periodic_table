#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]] # if there is no argument
then 
  echo Please provide an element as an argument.
else 
  #if is a number 
  if [[ $1 =~ ^[0-9]+$ ]]
  then 
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number='$1'")
  fi

  # if is a one o two letter 
  if [[ $1 =~ ^[A-Z]$ ]] || [[ $1 =~ ^[A-Z][a-z]$ ]]
  then 
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
  fi 

  # if is a name 
  if [[ $1 =~ ^[A-Z][a-z][a-z]+ ]]
  then 
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM ELEMENTS WHERE name='$1'")
  fi

  if [[ -z $ATOMIC_NUMBER ]]
  then 
    echo I could not find that element in the database.
  else
  ELEMENT=$($PSQL "SELECT name FROM elements WHERE atomic_number='$ATOMIC_NUMBER'")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number='$ATOMIC_NUMBER'")
  TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number='$ATOMIC_NUMBER'")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")


  echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."

  fi # if not found atomic_Number
fi # if there is no argument