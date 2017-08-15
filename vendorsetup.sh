function deso-sync() {

if [ $ANDROID_BUILD_TOP == null ]; then
echo ANDROID_BUILD_TOP not defined. Aborting ...
else

if [ $PWD != $ANDROID_BUILD_TOP ]; then
cd $ANDROID_BUILD_TOP
fi

# sync-paths file was obtained using this command
# grep -r 'remote="deso"' ./manifest | sed 's/" remote.*//' | sed 's/.*path="//' >> vendor/deso/sync-paths 

for line in $(cat vendor/deso/sync-paths) ; do
    cd $line
    repo-compare $line deso n
    #echo $PWD
    cd $ANDROID_BUILD_TOP
done
fi
}

function repo-compare() {

BRANCH="$(git rev-parse --abbrev-ref HEAD)"

echo
echo checking $1
echo git url = $2
echo branch = $3

# bash replace - replace @ with :password@ in the GIT URL
FOO="$(git ls-remote $2 -h $3 2> /dev/null)"
if [ "$?" != "0" ]; then
  echo cannot get remote status
fi
FOO_ARRAY=($FOO)
BAR=${FOO_ARRAY[0]}
echo [$BAR]

LOCALBAR="$(git rev-parse HEAD)"
echo [$LOCALBAR]
echo

if [ "$BAR" == "$LOCALBAR" ]; then
  #read -t10 -n1 -r -p 'Press any key in the next ten seconds...' key
  echo No changes
else
  #read -t10 -n1 -r -p 'Press any key in the next ten seconds...' key
  #echo pressed $key
  echo There are changes between local and remote repositories.
  echo syncing . . .
  repo sync .
fi
}
