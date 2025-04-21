#!/bin/sh

CMD='sed -i -e "1s/^/\/\/\ coverage:ignore-file\r\n/" "$1"'
if [[ "$OSTYPE" == "darwin"* ]]; then
 CMD='sed -i "" -e "1s/^/\/\/\ coverage:ignore-file\r\n/" "$1"'
fi

#echo 'sed -i -e "1s/^/\/\/\ coverage:ignore-file\r\n/" "$1"'
#echo "sed $SEDOPTION -e 1s/^/\/\/\ coverage:ignore-file\r\n/' '\$1'"
# add ignore coverage to generated files
find . -type f -name "messages_*.dart" -exec sh -c "$CMD" -- {} \;
find . -type f -name "l10n.dart" -exec sh -c "$CMD" -- {} \;
find . -type f -name "*.g.dart" -exec sh -c "$CMD" -- {} \;
find . -type f -name "*.mocks.dart" -exec sh -c "$CMD" -- {} \;
