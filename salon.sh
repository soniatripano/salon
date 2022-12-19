#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
  #check that everything is ok
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "Welcome to My Salon, how can I help you?"
  #get the available services from the db
  SERVICES=$($PSQL "SELECT * FROM services order by SERVICE_ID") 
  #display a list of the available services
  echo "$SERVICES" | while read ID BAR NAME
  do
   echo -e "\n$ID) $NAME"
  done

  read SERVICE_ID_SELECTED

  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")

  if [[ -z $SERVICE ]]
  then
    MAIN_MENU "Invalid selection"
  else
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    #look for the phone number in the db
    FIND_PHONE=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    
    #if the phone number is not in the db
    if [[ -z $FIND_PHONE ]]
    then
      echo -e "\nWhat's your name?"
      read CUSTOMER_NAME
      #put name and phone number in the customers table
      INSERT_NAME=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
      else
      #get the name associated to that phone number
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    fi

    echo -e "\nWhat time would you prefer?"
    read SERVICE_TIME

    #get the customer_id from the customer table
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME' AND name='$CUSTOMER_NAME'")
    
    #put the new appointment line in the appointments table
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")

    echo -e "\nI have put you down for a$SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
  fi

}
MAIN_MENU
