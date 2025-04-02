#!/bin/bash

#Colors
greenColor="\e[0;32m\033[1m"
endColor="\033[0m\e[0m"
redColor="\e[0;31m\033[1m"
blueColor="\e[0;34m\033[1m"
yellowColor="\e[0;33m\033[1m"
purpleColor="\e[0;35m\033[1m"
turquoiseColor="\e[0;36m\033[1m"
grayColor="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n${redColor}[!] Saliendo....${endColor}\n"
  tput cnorm; exit 1
}

# Ctrl+c

trap ctrl_c INT 
function helpPanel(){
  
  echo -e  "\n${yellowColor}[+]${endColor}${grayColor}Uso:${endColor}${purpleColor}$0${endColor}\n" 
  echo -e "\t${blueColor}-m)${endColor}\t${grayColor}Dinero con el que se desea jugar${endColor}"
  echo -e "\t${blueColor}-t)${endColor}\t${grayColor}Técnica a utilizar${endColor}${purpleColor}(${endCoolr}${yellowColor}martingala${endColor}${blueColor}/${endColor}${yellowColor}inverseLabrouchere${endColor}${purpleColor})${endColor}\n"
  exit 1
}

function martingala(){
  echo -e "\n${yellowColor}[+]${endColor}${grayColor} Dinero actual: ${endColor} ${greenColor}S/.$money${endColor}"
  echo -ne "${yellowColor}[+]${endColor}${grayColor} ¿Cuánto dinero tienes pensado apostar? -> ${endColor}" && read initial_bet
  echo -ne "${yellowColor}[+]${endColor}${grayColor} ¿A qué deseas apostar continuamente (par/impar)? -> ${endColor}" && read par_impar
#  echo -e "\n${yellowColor}[+]${endColor}${grayColor} Vamos a jugar con una cantidad inicial de${endColor}${greenColor} $initial_bet${endColor}${grayColor} a${endColor}${greenColor} $par_impar${endColor}"
  backup_bet=$initial_bet
  play_counter=1
  play_win=0
  bigger_price=$money
  jugadas_perdidas=" "
  tput civis
  while true; do
    money=$(($money-$initial_bet))
#    echo -e "\n${yellowColor}[+]${endColor}${grayColor} Acabas de apostar${endColor}${greenColor} S/.$initial_bet${endColor}${blueColor}${grayColor} y tienes${endColor}${greenColor} S/.$money${endColor}"
    random_number="$(( $RANDOM % 37 ))"
#    echo -e "\n${yellowColor}[+]${endColor}${grayColor} Ha salido el número ${endColor}${blueColor}$random_number${endColor}"
    if [ "$money" -gt 0 ]; then
      if [ "$par_impar" == "par" ]; then
        if [ "$(($random_number % 2))" -eq 0 ]; then
          if [ "$random_number" -eq 0 ]; then
#            echo -e "${yellowColor}[+]${endColor}${purpleColor} Ha saliedo el 0, ¡pierdes!${endColor}"
            initial_bet=$(($initial_bet*2))
            jugadas_perdidas+="$random_number "
#            echo -e "${yellowColor}[+]${endColor}${grayColor} Ahora mismo te quedas con${endColor}${greenColor} S/.$money${endColor}"
          fi
#          echo -e "${yellowColor}[+]${endColor}${grayColor} El número que ha salido es par,${endColor}${greenColor} ¡ganas!${endColor}"
          reward=$(($initial_bet*2))
#          echo -e "${yellowColor}[+]${endColor}${grayColor} Ganas un total de${endColor}${greenColor} S/.$reward${endColor}"
          money=$(($money+$reward))
#          echo -e "${yellowColor}[+]${endColor}${grayColor} Tienes${endColor}${greenColor} S/.$money${endColor}"
          initial_bet=$backup_bet
          play_win=$(($play_win+1))
          if [ "$money" -ge "$bigger_price" ]; then
            bigger_price=$money
          fi
        else
#          echo -e "${yellowColor}[+]${endColor}${redColor} Salio un número impar ¡pierdes!${endColor}"
          initial_bet=$(($initial_bet*2))
          jugadas_perdidas+="$random_number "
#          echo -e "${yellowColor}[+]${endColor}${grayColor} Ahora mismo te quedas con${endColor}${greenColor} S/.$money${endColor}"
        fi
      elif [ "$par_impar" == "impar" ]; then
          if [ "$(($random_number % 2))" -eq 1 ]; then
#               echo -e "${yellowColor}[+]${endColor}${grayColor} El número que ha salido es impar,${endColor}${greenColor} ¡ganas!${endColor}"
            reward=$(($initial_bet*2))
#               echo -e "${yellowColor}[+]${endColor}${grayColor} Ganas un total de${endColor}${greenColor} S/.$reward${endColor}"
            money=$(($money+$reward))
#               echo -e "${yellowColor}[+]${endColor}${grayColor} Tienes${endColor}${greenColor} S/.$money${endColor}"
            initial_bet=$backup_bet
            play_win=$(($play_win+1))
              if [ "$money" -ge "$bigger_price" ]; then
                bigger_price=$money
              fi
          else
#           echo -e "${yellowColor}[+]${endColor}${redColor} Salio un número par ¡pierdes!${endColor}"
            initial_bet=$(($initial_bet*2))
            jugadas_perdidas+="$random_number "
#           echo -e "${yellowColor}[+]${endColor}${grayColor} Ahora mismo te quedas con${endColor}${greenColor} S/.$money${endColor}"
          fi
      else
        echo -e "\n${yellowColor}[!]${endColor}${redColor} Valor introducido incorrecto ingrese par o impar${endColor}"
        tput cnorm; exit 1
      fi
  else
      jugadas_perdidas+="$random_number "
      #Nos quedamos sin dinero
      echo -e "\n${redColor}[!] Te has quedado sín dinero${endColor}\n"
      echo -e "\n${yellowColor}[!]${endColor}${grayColor} Han habido un total de ${endColor}${yellowColor}$play_counter${endColor}${grayColor} jugadas${endColor}"
      echo -e "\n\t${yellowColor}[!]${endColor}${grayColor} Han habido un total de ${endColor}${yellowColor}$play_win${endColor}${grayColor} partidas ganadas${endColor}"
      echo -e "\n\t${yellowColor}[!]${endColor}${grayColor} Han habido un total de ${endColor}${yellowColor}$(($play_counter - $play_win))${endColor}${grayColor} partidas perdidas${endColor}"
      echo -e "\n${yellowColor}[+]${endColor}${grayColor} La mayor cantidad de dinero de las apuestas es :${endColor}${greenColor} $bigger_price${endColor}"
      echo -e "\n${yellowColor}[+]${endColor}${grayColor}A continuación se van a represtar las malas jugadas consecutivas que han salido:${endColor}\n"
      echo -e "${blueColor}[$jugadas_perdidas]${endColor}"
      tput cnorm; exit 0
  fi
    let play_counter+=1
  done
  tput cnorm
}
function inverseLabrouchere(){
  echo -e "\n${yellowColor}[+]${endColor}${grayColor} Dinero actual: ${endColor} ${greenColor}S/.$money${endColor}"
  echo -ne "${yellowColor}[+]${endColor}${grayColor} ¿A qué deseas apostar continuamente (par/impar)? -> ${endColor}" && read par_impar
  declare -a my_sequence=(1 2 3 4)
  echo -e "\n${yellowColor}[+]${endColor}${grayColor} Comenzamos con la secuencia${endColor}${greenColor} [${my_sequence[@]}]${endColor}"
  bet=$((${my_sequence[0]}+${my_sequence[-1]}))
  jugadas_totales=0
  jugadas_ganadas=0
  bigger_price=$money
  bet_to_renew=$(($money+50)) #Dinero el cual una vez alcansado renovemos a una secuencia [1 2 3 4]
  echo -e "${yellowColor}[+]${endColor} ${grayColor}El tope a renovar la secuencia está establecido por encima de los ${endColor}${greenColor}S/.$bet_to_renew${endColor}"
  tput civis
  while true; do
    random_number=$(( $RANDOM % 37))
    if [  "$money" -gt 0 ];then
      let jugadas_totales+=1
      if [ "$money" -gt "$bet_to_renew" ]; then
        let bet_to_renew+=50
        my_sequence=(1 2 3 4)
        bet=$((${my_sequence[0]}+${my_sequence[-1]}))
        echo -e "${yellowColor}[+]${endColor}${grayColor} Restablecemos la secuencia a${endColor}${greenColor} [${my_sequence[@]}]${endColor}${grayColor} y mi nuevo limite es de${endColor}${greenColor} S/. ${bet_to_renew}${endColor}"
      elif [ "$money" -lt $(($bet_to_renew-100)) ]; then 
        echo -e "${yellowColor}[+]${endColor}${grayColor} Hemos llegado a un mínimo crítico, se procede a reajustar el tope${endColor}"
        bet_to_renew=$(($bet_to_renew-100))
        echo -e "${yellowColor}[+]${endColor}${grayColor} El tope ha sido renovada a ${endColor}${greenColor}S/.$bet_to_renew${endColor}"
      fi
      money=$(($money - $bet))
      echo -e "${yellowColor}[+]${endColor}${grayColor} Invertimos${endColor} ${greenColor}S/.${bet}${endColor}"
      echo -e "${yellowColor}[+]${endColor}${grayColor} Tenemos${endColor}${greenColor} S/.$money${endColor}"
      echo -e "\n${yellowColor}[+]${endColor}${grayColor}Ha salido el número ${endColor}${blueColor}$random_number${endColor}"
    
    if [ "$par_impar" == "par" ];then
      if [ "$(($random_number % 2))" -eq 0 ] && [ "$random_number" -ne 0 ]; then
        echo -e "${yellowColor}[+]${endColor}${grayColor} El número es par, ¡ganas!${endColor}"
        let jugadas_ganadas+=1
        reward=$(($bet*2))
        let money+=$reward
          if [ "$money" -gt "$bigger_price" ]; then
            bigger_price=$money
          fi
        echo -e "${yellowColor}[+]${endColor}${grayColor} Tienes${endColor}${greenColor} S/.$money${endColor}"
        my_sequence+=($bet)
        my_sequence=(${my_sequence[@]})
        echo -e "${yellowColor}[+]${endColor}${grayColor} La nueva secuencia es${endColor} ${greenColor}[${my_sequence[@]}]${endColor}"
        if [ "${#my_sequence[@]}" -ne 1 ]; then
          bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
        elif [ "${#my_sequence[@]}" -eq 1 ]; then
          bet=${my_sequence[0]}
        fi
      elif [ "$(($random_number % 2))" -eq 1 ] || [ "$random_number" -eq 0 ]; then
        if [ "$(($random_number % 2))" -eq 1 ]; then
          echo -e "${redColor}[+] El número es impar, ¡pierdes!${endColor}"
        else 
          echo -e "${redColor}[+] EL número es cero , ¡pierdes!${endColor}"
        fi
        unset my_sequence[0]
        unset my_sequence[-1] 2>/dev/null
        my_sequence=(${my_sequence[@]})
        echo -e "${yellowColor}[+]${endColor}${grayColor} La secuencia se nos queda de la siguiente forma:${endColor}${greenColor} [${my_sequence[@]}]${endColor}"
          if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ] ; then
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
          elif [ "${#my_sequence[@]}" -eq 1 ]; then
            bet=${my_sequence[0]}
          else
            echo -e "${redColor}[+] Hemos perdidos nuestra secuencia${endColor}"
            my_sequence=(1 2 3 4)
            echo -e "${yellowColor}[+]${endColor}${grayColor} Restablecemos la secuencia a${endColor}${greenColor} [${my_sequence[@]}]${endColor}"
            bet=$((${my_sequence[0]}+${my_sequence[-1]}))
          fi
      fi
    elif [ "$par_impar" == "impar" ];then
        if [ "$(($random_number % 2))" -eq 1 ]; then
        echo -e "${yellowColor}[+]${endColor}${grayColor} El número es impar, ¡ganas!${endColor}"
        let jugadas_ganadas+=1
        reward=$(($bet*2))
        let money+=$reward
          if [ "$money" -gt "$bigger_price" ]; then
            bigger_price=$money
          fi
        echo -e "${yellowColor}[+]${endColor}${grayColor} Tienes${endColor}${greenColor} S/.$money${endColor}"
        my_sequence+=($bet)
        my_sequence=(${my_sequence[@]})
        echo -e "${yellowColor}[+]${endColor}${grayColor} La nueva secuencia es${endColor} ${greenColor}[${my_sequence[@]}]${endColor}"
        if [ "${#my_sequence[@]}" -ne 1 ]; then
          bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
        elif [ "${#my_sequence[@]}" -eq 1 ]; then
          bet=${my_sequence[0]}
        fi
      elif [ "$(($random_number % 2))" -eq 0 ]; then
          echo -e "${redColor}[+] El número es par, ¡pierdes!${endColor}"
        unset my_sequence[0]
        unset my_sequence[-1] 2>/dev/null
        my_sequence=(${my_sequence[@]})
        echo -e "${yellowColor}[+]${endColor}${grayColor} La secuencia se nos queda de la siguiente forma:${endColor}${greenColor} [${my_sequence[@]}]${endColor}"
          if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ] ; then
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
          elif [ "${#my_sequence[@]}" -eq 1 ]; then
            bet=${my_sequence[0]}
          else
            echo -e "${redColor}[+] Hemos perdidos nuestra secuencia${endColor}"
            my_sequence=(1 2 3 4)
            echo -e "${yellowColor}[+]${endColor}${grayColor} Restablecemos la secuencia a${endColor}${greenColor} [${my_sequence[@]}]${endColor}"
            bet=$((${my_sequence[0]}+${my_sequence[-1]}))
          fi
      fi
    else
      echo -e "${redColor}[!] Ingrese un valor correcto${endColor}"
      tput cnorm; exit 1
    fi
  else 
    echo -e "\n${redColor}[!] Te has quedado sín dinero${endColor}\n"
    echo -e "\n${yellowColor}[!]${endColor}${grayColor} Han habido un total de ${endColor}${yellowColor}$jugadas_totales${endColor}${grayColor} jugadas${endColor}"
    echo -e "\n\t${yellowColor}[!]${endColor}${grayColor} Han habido un total de ${endColor}${yellowColor}$jugadas_ganadas${endColor}${grayColor} partidas ganadas${endColor}"
    echo -e "\n\t${yellowColor}[!]${endColor}${grayColor} Han habido un total de ${endColor}${yellowColor}$(($jugadas_totales - $jugadas_ganadas))${endColor}${grayColor} partidas perdidas${endColor}"
    echo -e "\n${yellowColor}[+]${endColor}${grayColor} La mayor cantidad de dinero de las apuestas es :${endColor}${greenColor}S/. $bigger_price${endColor}"
    tput cnorm; exit 1
  fi
#  sleep 0.5
  done
  put cnorm
}
while getopts "m:t:h" arg; do
  case $arg in 
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) helpPanel;;
  esac
done

if [ $money ] && [ $technique ]; then
  if [ "$technique" == "martingala" ]; then
    martingala
  elif [ "$technique" == "inverseLabrouchere" ]; then
    inverseLabrouchere
  else
    echo -e "\n${redColor}[!] La técnica introducida no existe${endColor}"
    helpPanel
  fi
else
  helpPanel
fi