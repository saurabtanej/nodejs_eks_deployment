#!/bin/sh
# yq 1.14.1

ENCRYPTION_KEY="${SECRETS_KEY}"
SECRETS_FILE="helm/charts/*/*/secrets-*.yaml"

case "${1}" in
'' | help | --help)

	cat <<-EOF

		${0} handles transparent K8S secrets file encryption.


		Secrets files are configrued via .gitattributes i.e.

		.gitattributes:
        ${SECRETS_FILE} filter=yamlsecrets diff=yamlsecrets

		this file is provided with the repo.


		Running this script with "init" parameter will add the following
		following to .git/config:

		[filter "yamlsecrets"]
        smudge = ./utils/k8s-secrets.sh decrypt
        clean = ./utils/k8s-secrets.sh encrypt

		[diff "yamlsecrets"]
        textconv = cat

		and will search afterwards for files to be decrypted. This can manually
		be performed by invoking

		    git checkout your-secret-file.yaml


		The encryption key may either be provided as secondary argument to the
		init command. Then it will be stored in .git/config and needs not
		further be mentioned. Otherwise the encryption key can be provided via
		environment variable ENCRYPTION_KEY.



		*** don't use quotes and equal signs in passwords, please ***

		EOF

	exit 0

	;;
init)

	if [ ! -d .git ]; then
		echo "Please run again from the top-level of the repository for init to be complete."
		exit 1
	fi

	git config filter.yamlsecrets.smudge './utils/k8s-secrets.sh decrypt'
	git config filter.yamlsecrets.clean './utils/k8s-secrets.sh encrypt'
	git config diff.yamlsecrets.textconv cat

	if [ ! -r .gitattributes ] || ! grep -Eq "secrets-\*.yaml" .gitattributes; then
		echo "${SECRETS_FILE} filter=yamlsecrets diff=yamlsecrets" >>.gitattributes
	fi

	if [ -z "${ENCRYPTION_KEY}" ]; then
		echo
		echo "> SECRETS_KEY not set!"
		echo
	else
		echo "decrypting secret files now ..."
		find . -type f -regex '.*secrets-.*.yaml' -print | while read file; do
			grep -q 'ENC_' "${file}" && rm -vf "${file}"
			git checkout "${file}"
		done
	fi

	exit 0
	;;
encrypt | decrypt) ;;

*)
	echo "${0}: unknown argument ${1}" >&2
	exit 1
	;;
esac

if [ -z "${ENCRYPTION_KEY}" ]; then
	echo "SECRETS_KEY not set" >&2
	return 0
fi

ORIGINAL_FILE=$(cat -)
FIRST_LINE_PATTERN=$(echo "${ORIGINAL_FILE}" | head -n 1)
OUTPUT="${ORIGINAL_FILE}"

if [ "${FIRST_LINE_PATTERN}" != "secrets:" ]; then
	echo "# ERROR: Malformed secrets file (incorrect key on first line)."
	exit 1
fi

echo "${ORIGINAL_FILE}" | yq r - secrets | (
	while read line; do
		key="$(printf "${line}" | cut -d : -f 1)"
		value="$(printf "${line}" | cut -d : -f 2- | tr -d '[:space:]')"

		if [ -z "${value}" ]; then
			echo "# ERROR: malformed secrets file at key ${key}" >&2
			exit 1
		fi

		case "${1}" in
		decrypt)
			if [ "${value}" != "${value#ENC_}" ]; then
				value="$(printf "${value#ENC_}" | openssl enc -d -base64 -A -aes-256-cbc -md sha256 -nosalt -k ${ENCRYPTION_KEY})"
				OUTPUT="$(printf "${OUTPUT}" | yq w - secrets."${key}" "${value}")"
			else
				echo "# INFO: double-decryption attempt" >&2
			fi
			;;
		encrypt)
			if [ "${value}" = "${value#ENC_}" ]; then
				value="ENC_$(printf "${value}" | openssl enc -e -base64 -A -aes-256-cbc -md sha256 -nosalt -k ${ENCRYPTION_KEY})"
				OUTPUT="$(printf "${OUTPUT}" | yq w - secrets."${key}" "${value}")"
			else
				echo "# INFO: double-encryption attempt" >&2
			fi
			;;
		esac

		if [ -z "${value}" ]; then
			echo "# ERROR: empty value at key ${key}" >&2
			exit 1
		fi
	done
	echo "${OUTPUT}" | yq r -
)

# vim: set tabstop=4 softtabstop=0 noexpandtab shiftwidth=4:
