# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# Add color output to various commands that don't have color by default
#
# Currently covers:
# * mvn
#

# Color themselves are copy&pasted from oh-my-zsh:
# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/mvn/mvn.plugin.zsh

BOLD=`tput bold`
UNDERLINE_ON=`tput smul`
UNDERLINE_OFF=`tput rmul`
TEXT_BLACK=`tput setaf 0`
TEXT_RED=`tput setaf 1`
TEXT_GREEN=`tput setaf 2`
TEXT_YELLOW=`tput setaf 3`
TEXT_BLUE=`tput setaf 4`
TEXT_MAGENTA=`tput setaf 5`
TEXT_CYAN=`tput setaf 6`
TEXT_WHITE=`tput setaf 7`
BACKGROUND_BLACK=`tput setab 0`
BACKGROUND_RED=`tput setab 1`
BACKGROUND_GREEN=`tput setab 2`
BACKGROUND_YELLOW=`tput setab 3`
BACKGROUND_BLUE=`tput setab 4`
BACKGROUND_MAGENTA=`tput setab 5`
BACKGROUND_CYAN=`tput setab 6`
BACKGROUND_WHITE=`tput setab 7`
RESET_FORMATTING=`tput sgr0`

# Maven

# Find maven home
LOCAL_MAVEN_BIN_PATH=`which mvn`
export MAVEN_BIN_PATH=${MAVEN_BIN_PATH:-$LOCAL_MAVEN_BIN_PATH}

# Wrapper function for Maven's mvn command.
mvn-color()
{
  (
  # Filter mvn output using sed. Before filtering set the locale to C, so invalid characters won't break some sed implementations
  unset LANG
  LC_CTYPE=C $MAVEN_BIN_PATH $@ | sed -e "s/\(\[INFO\]\)\(.*\)/${TEXT_BLUE}${BOLD}\1${RESET_FORMATTING}\2/g" \
               -e "s/\(\[INFO\]\ BUILD SUCCESSFUL\)/${BOLD}${TEXT_GREEN}\1${RESET_FORMATTING}/g" \
               -e "s/\(\[WARNING\]\)\(.*\)/${BOLD}${TEXT_YELLOW}\1${RESET_FORMATTING}\2/g" \
               -e "s/\(\[ERROR\]\)\(.*\)/${BOLD}${TEXT_RED}\1${RESET_FORMATTING}\2/g" \
               -e "s/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/${BOLD}${TEXT_GREEN}Tests run: \1${RESET_FORMATTING}, Failures: ${BOLD}${TEXT_RED}\2${RESET_FORMATTING}, Errors: ${BOLD}${TEXT_RED}\3${RESET_FORMATTING}, Skipped: ${BOLD}${TEXT_YELLOW}\4${RESET_FORMATTING}/g"
 
  # Make sure formatting is reset
  echo -ne ${RESET_FORMATTING}
  )
}

# And finally alias the mvn command:
alias mvn='mvn-color'
