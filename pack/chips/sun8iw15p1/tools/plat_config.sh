#!/bin/bash

#set -e

#
# 3:ddr3 4:ddr4 7:lpddr3 8:lpddr4
#
DRAM_TYPE=0
DRAM_NAME="null"
PACK_CHIP="sun8iw15p1"

if [ -n "${LICHEE_BUSSINESS}" ] && [ -d chips/${PACK_CHIP}/${LICHEE_BUSSINESS} ]; then
	RES_DIR=chips/${PACK_CHIP}/${LICHEE_BUSSINESS}
else
	RES_DIR=chips/${PACK_CHIP}
fi

copy_boot_file()
{
	DRAM_TYPE=`awk  '$0~"dram_type"{printf"%d", $3}' out/sys_config.fex`

	case $DRAM_TYPE in
		3) DRAM_NAME="ddr3"
		;;
		4) DRAM_NAME="ddr4"
		;;
		7) DRAM_NAME="lpddr3"
		;;
		8) DRAM_NAME="lpddr4"
		;;
		*) DRAM_NAME="unknow"
		exit 0
		;;
	esac

	plat_boot_file_list=(
		${RES_DIR}/bin/boot0_nand_${PACK_CHIP}_${DRAM_NAME}.bin:out/boot0_nand.fex
		${RES_DIR}/bin/boot0_sdcard_${PACK_CHIP}_${DRAM_NAME}.bin:out/boot0_sdcard.fex
		${RES_DIR}/bin/fes1_${PACK_CHIP}_${DRAM_NAME}.bin:out/fes1.fex
		${RES_DIR}/bin/sboot_${PACK_CHIP}_${DRAM_NAME}.bin:out/sboot.bin
		${RES_DIR}/bin/scp_${DRAM_NAME}.bin:out/scp.fex
	)


	printf "copying boot file for  ${DRAM_NAME}\n"
	for file in ${plat_boot_file_list[@]} ; do
		cp -f $(echo $file | sed -e 's/:/ /g') 2>/dev/null
	done
}

copy_boot_file
