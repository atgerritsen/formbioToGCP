# install Formbio CLI: https://docs.form.bio/form-bio-cli-sdk

curl -sSL https://storage.googleapis.com/formbio-go-releases/public/latest/install/linux | bash

sudo ln -s $HOME/.local/bin/formbio /usr/local/bin/formbio

# login with API token

formbio storage cp -r formbio://colossal/avian/shapiro_lab/seq/PE .

# this then errors out after downloading 1 bacth. 