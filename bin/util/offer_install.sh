#
# Install 'package' ($2) if 'command' ($1) is not on the PATH.
# Uses either apt-get or yum.
# This should only be used if package:command is 1:1 and the package name is the same for apt-get and yum.
#
function offer_install_with_yum_or_apt_ifnowhich {
   # See also https://github.com/timrdf/csv2rdf4lod-automation/blob/master/bin/util/install-csv2rdf4lod-dependencies.sh
   # See also https://github.com/timrdf/DataFAQs/blob/master/bin/install-datafaqs-dependencies.sh
   # See also Prizms bin/install.sh
   if [[ -n "$sudo" ]]; then
      command="$1"
      package="$2"
         if [[ -n "$command" && -n "$package" ]]; then

            already_there='no'
            if [[ "$command" == '.' ]]; then
               if [[ `which apt-get    &> /dev/null` && \
                     `dpkg -s $package &> /dev/null` ]]; then # 0 is true, 1 is false
                  already_there='yes'
               elif [[ `which yum 2> /dev/null` ]]; then
                  already_there='TODO'
               fi
            else
               if [[ `$sudo which $command 2> /dev/null` ]]; then
                  already_there='yes'
               fi
            fi

            #if [[ ! `$sudo which $command 2> /dev/null` ]]; then
            if [[ "$already_there" != 'yes' ]]; then
               if [ "$dryrun" != "true" ]; then
                  echo
               fi
               if [[ `which apt-get 2> /dev/null` ]]; then
                  echo $TODO $sudo apt-get install $package
               elif [[ `which yum 2> /dev/null` ]]; then
                  echo $TODO $sudo yum install $package
               else
                  echo "WARNING: how to install $package without apg-get or yum?"
               fi
               if [[ "$dryrun" != "true" && ( `which apt-get 2> /dev/null` || `which yum 2> /dev/null` ) ]]; then
                  read -p "Q: Could not find $command on path. Try to install with command shown above? (y/n): " -u 1 install_it
                  if [[ "$install_it" == [yY] ]]; then
                     if [[ `which apt-get 2> /dev/null` ]]; then
                        echo $sudo apt-get install $package
                             $sudo apt-get install $package
                     elif [[ `which yum 2> /dev/null` ]]; then
                        echo $sudo yum install $package
                             $sudo yum install $package
                     fi
                  fi
               fi
            else
               echo "[okay] $command already available at `which $command 2> /dev/null`"
            fi
         fi
      which $command >& /dev/null
      return $?
   else
      echo "[WARNING] Skipping $1 $2 b/c no sudo." >&2
   fi
}