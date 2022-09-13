# $1 - name
# $2 - darwin/amd64 install command
# $3 - darwin/arm64 install command
# $4 - linux/amd64 install command
# $5 - linux/arm64 install command

select_by_platform() {
  name=$1
  darwin_amd64=$2
  darwin_arm64=$3
  linux_amd64=$4
  linux_arm64=$5

  system=$(uname -s)
  machine=$(uname -m)
  platform="$system/$machine"

  set -e
  case $platform in
    Darwin/x86_64 )
      echo $darwin_amd64
      ;;
    Darwin/arm64 )
      echo $darwin_arm64
      ;;
    Linux/x86_64 )
      echo $linux_aramd64
      ;;
    Linux/arm64 )
      echo $linux_arm64
      ;;
    Linux/aarch64 )
      echo $linux_arm64
      ;;
    *)
      echo "Unable to resolve platform for $name"
      exit 1
      ;;
  esac
  set +e
}
