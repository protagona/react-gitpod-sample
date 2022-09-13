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
for PROFILE_SCRIPT in $( ls $HOME/zshrc.d/*.zsh ); do
  . $PROFILE_SCRIPT
done
