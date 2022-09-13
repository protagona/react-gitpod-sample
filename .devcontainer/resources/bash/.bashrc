   #    ####### ####### ####### #     # #######   ###   ####### #     #
  # #      #       #    #       ##    #    #       #    #     # ##    #
 #   #     #       #    #       # #   #    #       #    #     # # #   #
#     #    #       #    #####   #  #  #    #       #    #     # #  #  #
#######    #       #    #       #   # #    #       #    #     # #   # #
#     #    #       #    #       #    ##    #       #    #     # #    ##
#     #    #       #    ####### #     #    #      ###   ####### #     #

# DO NOT CHANGE THIS FILE UNLESS REALLY NECESSARY.
# To add functionality, use the folder ./.zshrc.d

. $HOME/.asdf/asdf.sh
complete -C 'aws_completer' aws
for PROFILE_SCRIPT in $( ls $HOME/bashrc.d/*.sh ); do
  . $PROFILE_SCRIPT
done
