sudo apt-get update && sudo apt-get upgrade -y

# Check if Git is already installed; if not, install it using APT
if ! command -v git 2>&1 >/dev/null
then
    sudo apt-get install git -y
fi


# Check if Tmux is already installed; if not, download git repo and install it
if ! command -v tmux 2>&1 >/dev/null
then
    git clone https://github.com/tmux/tmux.git
    cd tmux
    sh autogen.sh
    ./configure
    make && sudo make install
    cd ..
fi

# Check if Helm is already installed; if not, add its repository to Apt and install it
if ! command -v helm 2>&1 >/dev/null
then    
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
    sudo apt-get install apt-transport-https --yes
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt-get update
    sudo apt-get install helm -y
fi

# Check if Tailscale is already installed and if os release is bookworm; if not, add its repository to Apt and install it
if ! command -v tailscale 2>&1 >/dev/null && grep -q "bookworm" /etc/os-release; 
then
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
    sudo apt-get update
    sudo apt-get install tailscale -y
fi
