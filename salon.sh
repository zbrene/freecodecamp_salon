#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\nWelcome to My Salon, how can I help you?"
  echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim"

  read SERVICE_ID_SELECTED
  SERVICE_SELECTION_NAME=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")

#if input isn't a number
if  [[ ! $SERVICE_ID_SELECTED =~ ^[1-5]+$ ]]
then
  #repeat service list
  MAIN_MENU "I could not find that service. What would you like today?"
else
  #get customer info
  echo "What's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  
  #if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    #get new customer_name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    
    #insert new customer
    CUSTOMER_NAME_RESULT=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")

  else
    #get customer_id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  fi

  FORMATTED_SERVICE_SELECTION_NAME=$(echo $SERVICE_SELECTION_NAME | sed 's/ *//')

  #ask for appointment time
  echo -e "\nWhat time would you like your $FORMATTED_SERVICE_SELECTION_NAME, $CUSTOMER_NAME"
  read SERVICE_TIME
    
  #get customer_id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name = '$CUSTOMER_NAME'")
  
  #insert appointment time
  INSERT_SERVICE_TIME_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")



  #send to main menu
  echo "I have put you down for a $FORMATTED_SERVICE_SELECTION_NAME at $SERVICE_TIME, $CUSTOMER_NAME." 
  
fi
}

EXIT(){
echo "I have put you down for a $SERVICE_SELECTION_NAME at $"
} 

MAIN_MENU