obj-m	:= src/acer_control.o

KERNELDIR ?= /lib/modules/$(shell uname -r)/build
PWD       := $(shell pwd)

# Sign the kernel module for secure boot (Ubuntu)
# https://wiki.ubuntu.com/UEFI/SecureBoot/Signing
KEY := /var/lib/shim-signed/mok/MOK.priv
X509 := /var/lib/shim-signed/mok/MOK.der

ifdef LTS
    ccflags-y := -Dlts
endif

all: default

default:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

	if [ -f "$(KEY)" ] && [ -f "$(X509)" ]; then \
		sudo kmodsign sha512 $(KEY) $(X509) src/facer.ko; \
	fi

install:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules_install

clean:
	rm -rf src/*.o src/*~ src/.*.cmd src/*.ko src/*.mod.c \
		.tmp_versions modules.order Module.symvers

dkmsclean:
	@dkms remove acer-control/0.1 --all || true
	@dkms remove acer-control/0.2 --all || true

dkms: dkmsclean
	dkms add .
	dkms install -m acer-control -v 0.2

onboot:
	echo "acer-control" > /etc/modules-load.d/acer-control.conf

noboot:
	rm -f /etc/modules-load.d/acer-control.conf