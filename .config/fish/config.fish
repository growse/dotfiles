function fish_prompt
    powerline-rust-bare $status
end

set -U fish_user_paths $HOME/bin $HOME/.cargo/bin $HOME/.krew/bin $fish_user_paths
export HELM_NAMESPACE="helmthings"

