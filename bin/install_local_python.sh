#!/usr/bin/env bash
#
# Ref https://askubuntu.com/questions/566324/how-to-install-python-as-a-user
#
# Install Python3 and Libraries as a local user.
python_config() {
        if [ $# -ne 1 ]
        then
                target_ver="3.10.5"
                echo "Installing default version $target_ver"
        else
                target_ver=$1
                echo "Install $target_ver"
        fi

        PYTHON_VER="$target_ver"
        export PYTHON_VER
        PYTHON_VER_SHORT="$(echo ${PYTHON_VER} | cut -d '.' -f1,2)"
        export PYTHON_VER_SHORT
        cd ~ || exit 4
        rm -rf ~/python && mkdir -p ~/python
        echo "" >> ~/.bashrc
        echo "export PATH=~/python/bin:$PATH" >> ~/.bashrc
        source ~/.bashrc
        wget --quiet --no-check-certificate "https://www.python.org/ftp/python/${PYTHON_VER}/Python-${PYTHON_VER}.tgz"
        tar -zxvf ~/Python-${PYTHON_VER}.tgz 1>/dev/null
        cd ~/Python-${PYTHON_VER}/ || exit 4
        echo "Python ${PYTHON_VER} - Installing in current logged-in user - $(whoami)"
        echo "Python ${PYTHON_VER} - Installation in-progress. Please wait..."
        ./configure --enable-optimizations --prefix="$HOME/python" > /dev/null 2>&1;
        echo "Python ${PYTHON_VER} - ETA: upto 5mins. Please wait..."
        make altinstall > /dev/null 2>&1;
        ln -s "$HOME/python/bin/python${PYTHON_VER_SHORT}" ~/python/bin/python3
        ln -s "$HOME/python/bin/pip${PYTHON_VER_SHORT}" ~/python/bin/pip3
        wget --quiet --no-check-certificate https://bootstrap.pypa.io/get-pip.py -O - | python3 - --prefix="$HOME/python"
        source ~/.bashrc
        ~/python/bin/pip3 install --upgrade pip
        ~/python/bin/pip3 install --upgrade pygithub
        ~/python/bin/pip3 install --upgrade --no-cache-dir -r /tmp/requirements.txt --use-pep517
        #cd ~ && rm -rf ~/Python-${PYTHON_VER}*
        ~/python/bin/python3 --version
        ~/python/bin/pip3 --version
        echo "Python ${PYTHON_VER} - Setup Completed!"
}

# Function Call
python_config "$@"
