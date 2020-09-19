#! /bin/bash

buttons="0 1 2 3 4 5 6 7 8 9 GREEN RED BLUE YELLOW ENTER A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"

for i in $buttons; do

cat << EOF
begin
    prog   = irexec
    button = KEY_$i
    config = /queue_message_and_show_output.sh "$i"
end

EOF

done
