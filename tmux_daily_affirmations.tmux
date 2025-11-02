CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
AFFIRMATION_SCRIPT="$CURRENT_DIR/scripts/daily_affirmations_plugin.sh"

# Expose the variable as a tmux format
tmux set-option -g '@tmux_daily_affirmation' "#(bash $AFFIRMATION_SCRIPT)"
