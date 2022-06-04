#!/bin/bash

echo '[+] Creating Docker containers'
echo 
# directory with dockerfile
mkdir Dockerfile
cd Dockerfile
touch Dockerfile

echo 'FROM alpine:3.4' > Dockerfile 

# building docker containers
sudo docker build --tag docker-container1 .
echo '[+] Docker 1 created...'
sudo docker build --tag docker-container2 .
echo '[+] Docker 2 created...'
sudo docker build --tag docker-container3 .
echo '[+] Docker 3 created...'
echo 

echo '[+] Starting dockers'
# starting docker contianers in interactive mode 
sudo docker run --name docker1 -it -d docker-container1
sudo docker run --name docker2 -it -d docker-container2
sudo docker run --name docker3 -it -d docker-container3

# navigate back to main directory
cd ..
echo

# copy files to docker containers
echo '[+] Loading files to Docker1...'
sudo docker cp 'Docker Files'/Docker1 docker1:/.
echo '[+] Loading files to Docker2...'
sudo docker cp 'Docker Files'/Docker2 docker2:/.
echo '[+] Loading files to Docker3...'
sudo docker cp 'Docker Files'/Docker3 docker3:/.

# text file Fine Book Chapter
echo 
echo '[+] Begining text creation GAME_OF_DOCKERS.txt'
echo
touch 'Final Book Chapter'.txt

# array, each number represent docker container, 1 - order files by size, 0 - do not order
matric_num=40495492
ordered_docks=(0 0 0)
if [ "$(( $matric_num % 3 ))" -eq 0 ]; then
	ordered_docks[1]=1
	ordered_docks[2]=1
	echo '[+] Sorting files of Dockers 2 and 3 by size'
elif [ "$(( $matric_num % 3 ))" -eq 1 ]; then
	ordered_docks[0]=1
	ordered_docks[1]=1
	echo '[+] Sorting files of Dockers 1 and 2 by size'
else
	ordered_docks[0]=1
	ordered_docks[2]=1
	echo '[+] Sorting files of Dockers 1 and 3 by size'
fi

# get the highest number of text files in dockers
max_loop=0
files=$(sudo docker exec -it docker1 ls -rt1 /Docker1 | wc -l)
if [ $files -gt $max_loop ]; then
	max_loop=$files
fi
files=$(sudo docker exec -it docker2 ls -rt1 /Docker2 | wc -l)
if [ $files -gt $max_loop ]; then
	max_loop=$files
fi
files=$(sudo docker exec -it docker3 ls -rt1 /Docker3 | wc -l)
if [ $files -gt $max_loop ]; then
	max_loop=$files
fi

# load text from dockers to Final Book Chapter
# loop over max number of text files in dockers
# loop counter increased by 2 --> 2 files in one iteration
loop_counter=0
while [ $loop_counter -le $max_loop ]
do
	# loop 3 times - number of dockers
	for docker_num in 1 2 3
	do
		counter=0
		if [ ${ordered_docks[docker_num-1]} -eq 1 ];then # docker text files should be ordered
			# loop over ordered files in current docker, color characters are removed, special '\r' is removed if exists
			for f in $(sudo docker exec -it docker$docker_num ls -rS /Docker$docker_num | sed -r 's/\x1B\[(;?[0-9]{1,3})+[mGK]//g' | tr -d '\r'); do
				# numbers represent dockers; 'counter' is index of text file in docker
				# 'loop_counter' sets index of file that should be copied in current iteration
				case $docker_num in
					1)
						if [ $counter -eq $loop_counter ]; then
							sudo docker exec -it docker1 cat /Docker1/$f >> 'Final Book Chapter'.txt
							echo '[+] Loading' $((counter+1)) $f 'text from 1st Docker container…'
						elif [ $((counter-1)) -eq $loop_counter ]; then
							sudo docker exec -it docker1 cat /Docker1/$f >> 'Final Book Chapter'.txt
							echo '[+] Loading' $((counter+1)) $f 'text from 1st Docker container…'
						fi
						;;
					2)
						if [ $counter -eq $loop_counter ]; then
							sudo docker exec -it docker2 cat /Docker2/$f >> 'Final Book Chapter'.txt
							echo '[+] Loading' $((counter+1)) $f 'text from 2nd Docker container…'
						elif [ $((counter-1)) -eq $loop_counter ]; then
							sudo docker exec -it docker2 cat /Docker2/$f >> 'Final Book Chapter'.txt
							echo '[+] Loading' $((counter+1)) $f 'text from 2nd Docker container…'
						fi
						;;
					3)
						if [ $counter -eq $loop_counter ]; then
							sudo docker exec -it docker3 cat /Docker3/$f >> 'Final Book Chapter'.txt
							echo '[+] Loading' $((counter+1)) $f 'text from 3rd Docker container…'
						elif [ $((counter-1)) -eq $loop_counter ]; then
							sudo docker exec -it docker3 cat /Docker3/$f >> 'Final Book Chapter'.txt
							echo '[+] Loading' $((counter+1)) $f 'text from 3rd Docker container…'
						fi
						;;
				esac
				let "counter=counter+1" # counter increased, next text file in the docker
			done
		else # docker text files should be ordered
			# loop over unordered files in current docker, color characters are removed, special '\r' is removed if exists
			for f in $(sudo docker exec -it docker$docker_num ls /Docker$docker_num| sed -r 's/\x1B\[(;?[0-9]{1,3})+[mGK]//g' | tr -d '\r'); do
				# numbers represent dockers; 'counter' is index of text file in docker
				# 'loop_counter' sets index of file that should be copied in current iteration
				case $docker_num in
					1)
						if [ $counter -eq $loop_counter ]; then
							echo '[+] Loading' $((counter+1)) $f 'text from 1st Docker container…'
							sudo docker exec -it docker1 cat /Docker1/$f >> 'Final Book Chapter'.txt
						elif [ $((counter-1)) -eq $loop_counter ]; then
							echo '[+] Loading' $((counter+1)) $f 'text from 1st Docker container…'
							sudo docker exec -it docker1 cat /Docker1/$f >> 'Final Book Chapter'.txt
						fi
						;;
					2)
						if [ $counter -eq $loop_counter ]; then
							sudo docker exec -it docker2 cat /Docker2/$f >> 'Final Book Chapter'.txt
							echo '[+] Loading' $((counter+1)) $f 'text from 2nd Docker container…'
						elif [ $((counter-1)) -eq $loop_counter ]; then
							sudo docker exec -it docker2 cat /Docker2/$f >> 'Final Book Chapter'.txt
							echo '[+] Loading' $((counter+1)) $f 'text from 2nd Docker container…'
						fi
						;;
					3)
						if [ $counter -eq $loop_counter ]; then
							sudo docker exec -it docker3 cat /Docker3/$f >> 'Final Book Chapter'.txt
							echo '[+] Loading' $((counter+1)) $f 'text from 3rd Docker container…'
						elif [ $((counter-1)) -eq $loop_counter ]; then
							sudo docker exec -it docker3 cat /Docker3/$f >> 'Final Book Chapter'.txt
							echo '[+] Loading' $((counter+1)) $f 'text from 3rd Docker container…'
						fi
						;;
				esac
				let "counter=counter+1" # counter increased, next text file in the docker
			done
		fi
	done
	let "loop_counter=loop_counter+2" # next pair of files
done

echo '[+] Finished loading text'

# loop to accept user command
user_command=0
while [[ ! "$user_command" -eq 4 ]] # 4 is to terminate program
do
	echo 
	echo '1 - read Final Book Chapter' 
	echo '2 - add text' 
	echo '3 - remove text' 
	echo '4 - terminate program' 
	read -p 'What would you like to do? ' user_command
	echo 
	case $user_command in 
		1)	
			# read file
			cat 'Final Book Chapter'.txt
			;;
		2)
			# get input and redirect it to file
			read -p "What text would you like to add? " add_text
			echo -n $add_text >> 'Final Book Chapter'.txt
			echo '[+] Text successfully added!' 
			;;
		3)
			# get input, count number of occurrences in the file
			read -p "What text would you like to remove? " rm_text
			case $(grep "$rm_text" 'Final Book Chapter'.txt | wc -l) in
				0)
					# input not found in the file
					echo '[+] The search text was not found!'
					;;	
				1)	
					# 1 match
					sed -i "s/$rm_text//" 'Final Book Chapter'.txt
					echo '[+] Text successfully removed!'	
					;;
				*)
					# multiple matches, user can delete all or nothing
					echo '[+] Multiple lines found. '
					read -p 'Do you like to remove all occurrences?(y/n) ' rm_all
					if [[ "$rm_all" =~ ^(yes|y)$ ]]; then
						# remove all occurrences (substitute given pattern with nothing)
						sed -i "s/$rm_text//" 'Final Book Chapter'.txt
						echo '[+] Text successfully removed!'
					else
						echo '[+] Task terminated!'
					fi
					;;
			esac
			;;
		4)
			# stop dockers and end loop
			echo '[+] Docker containers are being stopped!'
			sudo docker stop docker1
			sudo docker stop docker2
			sudo docker stop docker3
			echo '[+] Thank you for the game!'
			;;
		*)
			echo 'Invalid Input!'
			;;
	esac
done

