extension_name := env("EXTENSION_NAME", "router-config")

default: generate-confext install

generate-confext $EXTENSION_NAME=extension_name $OUTDIR=env("OUTDIR", "./images-out/"):
    #!/usr/bin/env bash
    set -x
    if ! command -v mkfs.erofs &>/dev/null ; then
        echo "You need erofs-utils to run this command"
        exit 1
    fi
    if ! command -v podman &>/dev/null ; then
        echo "You need podman to run this command"
        exit 1
    fi

    ROOTFS_DIR="$(mktemp -d --tmpdir="${ROOTFS_BASE:-/tmp}")"
    trap 'rm -rf "${ROOTFS_DIR}"' EXIT
    NAME_TRIMMED=router-config

    cp -ar ./etc "${ROOTFS_DIR}"

    install -d "${ROOTFS_DIR}/etc/extension-release.d"
    echo 'ID="_any"' >> "${ROOTFS_DIR}/etc/extension-release.d/extension-release.${NAME_TRIMMED}" 
    TARGET_ARCH="${TARGET_ARCH:-$(arch)}"
    echo "ARCHITECTURE=${TARGET_ARCH//_/-}" >> "${ROOTFS_DIR}/etc/extension-release.d/extension-release.${NAME_TRIMMED}"

    filecontexts="/etc/selinux/targeted/contexts/files/file_contexts"
    if [ -e "${filecontexts}" ] ; then 
        sudo setfiles -r "${ROOTFS_DIR}" "${filecontexts}" "${ROOTFS_DIR}"
        sudo chcon --user=system_u --recursive "${ROOTFS_DIR}"
    fi

    if [ "${OUTDIR}" == "" ] ; then
        OUTDIR="$(mktemp -d)/"
    fi
    OUTDIR="$(realpath "${OUTDIR}")"
    mkdir -p "${OUTDIR}"
    mkfs.erofs "${OUTDIR}/${NAME_TRIMMED}.raw" "${ROOTFS_DIR}"

install $EXTENSION_NAME=extension_name $OUTDIR=env("OUTDIR", "./images-out/"):
    #/usr/bin/env bash
    sudo install -Dpm0644 -t /var/lib/confexts/ "$(realpath "${OUTDIR}")/${EXTENSION_NAME}.raw"
