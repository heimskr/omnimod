SB  ?= ~/.local/share/Steam/steamapps/common/Starbound/linux/
UGC ?= ~/bin/
OLD_CWD := $(shell pwd)

pack:
	mkdir -p packed
	$(SB)/asset_packer mod packed/contents.pak

upload: pack
	cd $(UGC) && ./steamugc-uploader -a 211820 -i 3020859495 -t "Heimskr's Omnimod" -d "A mod for friends." -c $(OLD_CWD)/packed
