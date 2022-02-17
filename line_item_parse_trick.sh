# Pipe previous stdout lines into a line reader, breakdown each line by delimiter " ", utilize individual value freely
ls -ld * | 
 while IFS= read -r line; do 
   ninth=$(echo $line | cut -d " " -f9)
   eighth=$(echo $line | cut -d " " -f8)
   echo now I can use $eighth and $ninth item however I want 
 done
