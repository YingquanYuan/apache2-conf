TARGET_DIR	:=	./target
SRC_DIR		:=	./src
DEB_DIR		:=	./deb
INSTALL_DIR	:=	/etc

DATE		:=	$(shell date +"%Y%m%d%H%M")
COMMIT		:=	$(shell git rev-parse --short HEAD)

.PHONY: package
package: clean $(TARGET_DIR)/apache2-conf.deb

.PHONY: deb
%.deb: $(wildcard $(SRC_DIR)/*) $(DEB_DIR)/*
	mkdir -p $(TARGET_DIR)/`basename $(@:.deb=)`$(INSTALL_DIR)
	mkdir -p $(TARGET_DIR)/`basename $(@:.deb=)`/DEBIAN
	cp $(DEB_DIR)/* $(TARGET_DIR)/`basename $(@:.deb=)`/DEBIAN
	-cp -r $(SRC_DIR)/* $(TARGET_DIR)/`basename $(@:.deb=)`$(INSTALL_DIR)
	cd $(TARGET_DIR); sed -i.sedbak 's/Version: \([^-]*\).*/Version: 0-$(DATE)-$(COMMIT)/' `basename $(@:.deb=)`/DEBIAN/control; rm `basename $(@:.deb=)`/DEBIAN/*.sedbak
	cd $(TARGET_DIR); dpkg-deb --build `basename $(@:.deb=)`
	@# rm -r $(TARGET_DIR)/`basename $(@:.deb=)`

.PHONY: clean
clean:
	@rm -rf $(TARGET_DIR)
