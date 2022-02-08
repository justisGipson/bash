#!/usr/bin/env bash
printf '%d%d' "${CHARS:=5}" "${ROUNDS:=6}" &>/dev/null || set 1
[[ $# != 0 ]] && { printf '[CHARS=n] [ROUNDS=n] [WORDLIST=file] %s\n' "${0##*/}" >&2; exit 1; }
printf 'Letters: %d Rounds: %d\n' "${CHARS#-}" "$ROUNDS"
mapfile -t words < <(grep -x '[a-z]\{'"${CHARS#-}"'\}' "${WORDLIST:-/usr/share/dict/words}")
word=${words[RANDOM % ${#words[@]}]} pool=abcdefghijklmnopqrstuvwxyz
for ((round=1; round <= $ROUNDS; round++)); do
	while read -rp "$round/$ROUNDS: " guess || exit 1; do
		[[ " ${words[*]} " == *" ${guess,,} "* ]] && guess=${guess,,} && break
	done
	for ((i=0, chars=0; i < ${#word}; i++)); do
		[[ ${word:i:1} != "${guess:i:1}" ]] && chars+=${word:i:1}
	done
	for ((i=0; color=7, i < ${#guess}; i++)); do char=${guess:i:1}
		{ [[ ${word:i:1} == "$char" ]] && color=2; } ||
		{ [[ ${chars#0} == *"$char"* ]] && color=3 chars=${chars/$char/}; }
		[[ $word != *"$char"* ]] && pool=${pool/$char/}
		printf '\033[30;4%dm %s \033[0m' "$color" "${char^^}"
	done
	printf ' %s\n' "$pool"
	[[ $guess == "$word" ]] && exit
done
! printf 'The word was "%s"\n' "$word" && false
