# Platform detection (borrowed from Omnitruck install script)
# Debian-family and RedHat-family are currently supported
# FIXME move platform detection to seperate file, use env var
os=`uname -s | tr '[A-Z]' '[a-z]'`

if test -f "/etc/lsb-release" && grep -q DISTRIB_ID /etc/lsb-release && ! grep -q wrlinux /etc/lsb-release; then
  platform=`grep DISTRIB_ID /etc/lsb-release | cut -d "=" -f 2 | tr '[A-Z]' '[a-z]'`
  platform_version=`grep DISTRIB_RELEASE /etc/lsb-release | cut -d "=" -f 2`

elif test -f "/etc/debian_version"; then
  platform="debian"
  platform_version=`cat /etc/debian_version`

elif test -f "/etc/redhat-release"; then
  platform=`sed 's/^\(.\+\) release.*/\1/' /etc/redhat-release | tr '[A-Z]' '[a-z]'`
  platform_version=`sed 's/^.\+ release \([.0-9]\+\).*/\1/' /etc/redhat-release`

  # If /etc/redhat-release exists, we act like RHEL by default
  if test "$platform" != "fedora"; then
    platform="el"
  fi

fi

if [ $platform == 'el' ]; then
  yum install -y git ansible
  hostname=$(hostname -s)
fi

ansible=$(mktemp -d)

git clone https://github.com/raykrist/ansible-cloud ${ansible}
pushd $ansible

ansible-galaxy install -r requirements.yaml
echo ${hostname} > inventory
mkdir host_vars
echo 'ansible_connection: local' > host_vars/${hostname}.yaml
ansible-playbook lib/common.yaml

popd
rm -rf ${ansible}
