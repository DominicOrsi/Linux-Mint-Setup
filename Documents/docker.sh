if [ ! -f /home/$USER/.dockerUser ]
then    
    echo $USER:10000:65536 >> /etc/subuid
    echo $USER:10000:65536 >> /etc/subgid
    touch /home/$USER/.dockerUser
fi 
