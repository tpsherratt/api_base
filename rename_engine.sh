#!/bin/bash

# Check we're in a directory with the same name as the argument
# so we don't accidently so some find and replace magic
pwd=`pwd`
if [ `basename $pwd` != $1 ]; then
  echo "ERROR: exiting as I think you might be in the wrong dir: $pwd"
  exit 1
fi

# # Check that we have access to gsed
if ! hash gsed 2>/dev/null; then
  echo "ERROR: This script requires gnu sed (rather than the one shipped with OSX)" 
  echo "install with: '$ brew install gnu-sed' an re-run script"
  exit 1
fi

# move the files
for file in $(find . -name "*engine_template*")
do
  mv $file `echo $file | gsed s/engine_template/$1/`
done

# camel case the name
camel_case=`echo $1 | gsed -E -e 's/_([a-z0-9])/\u\1/g' -e 's/^([a-z0-9])/\u\1/g'`

# find and replace engine_template -> my_sweet_new_engine
find . ! -name 'rename_engine.sh' -type f -print0 | xargs -0 gsed -silent -i "s/engine_template/$1/g"

# find and replace EngineTemplate -> MySweetNewEngine
find . ! -name 'rename_engine.sh' -type f -print0 | xargs -0 gsed -silent -i "s/EngineTemplate/$camel_case/g"

echo "success!"
echo "for root Gemfile                   :  gem 'new_engine_name', path: 'components/$1'"
echo "for root routes.rb (if web engine) :  mount $camel_case::Engine, at: '/whatever_engine_route'"
