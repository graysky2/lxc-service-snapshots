VERSION = 2.10
PN = lxc-service-snapshots

PREFIX ?= /usr
BINDIR = $(PREFIX)/lib/$(PN)
INITDIR = $(PREFIX)/lib/systemd/system
SHAREDIR = $(PREFIX)/share/$(PN)
CONFDIR = /etc/conf.d
MANDIR = $(PREFIX)/share/man/man1

RM = rm
SED = sed
INSTALL = install -p
INSTALL_PROGRAM = $(INSTALL) -m755
INSTALL_DATA = $(INSTALL) -m644
INSTALL_DIR = $(INSTALL) -d
Q = @

common/$(PN):
	$(Q)$(SED) 's/@VERSION@/'$(VERSION)'/' common/openvpn.in > common/openvpn
	$(Q)$(SED) 's/@VERSION@/'$(VERSION)'/' common/pihole.in > common/pihole
	$(Q)$(SED) 's/@VERSION@/'$(VERSION)'/' common/wireguard.in > common/wireguard

install-common:
	$(INSTALL_DIR) "$(DESTDIR)$(CONFDIR)"
	$(INSTALL_DIR) "$(DESTDIR)$(SHAREDIR)"
	$(INSTALL_DATA) common/openvpn-lss.conf "$(DESTDIR)$(CONFDIR)/openvpn-lss.conf"
	$(INSTALL_DATA) common/pihole-lss.conf "$(DESTDIR)$(CONFDIR)/pihole-lss.conf"
	$(INSTALL_DATA) common/wireguard-lss.conf "$(DESTDIR)$(CONFDIR)/wireguard-lss.conf"
	$(INSTALL_PROGRAM) common/autodev "$(DESTDIR)$(SHAREDIR)/autodev"
	$(INSTALL_DATA) common/config "$(DESTDIR)$(SHAREDIR)/config"

install-init:
	$(INSTALL_DIR) "$(DESTDIR)$(BINDIR)"
	$(INSTALL_DIR) "$(DESTDIR)$(INITDIR)"
	$(INSTALL_PROGRAM) common/openvpn "$(DESTDIR)$(BINDIR)/openvpn"
	$(INSTALL_PROGRAM) common/pihole "$(DESTDIR)$(BINDIR)/pihole"
	$(INSTALL_PROGRAM) common/wireguard "$(DESTDIR)$(BINDIR)/wireguard"
	$(INSTALL_DATA) init/openvpn-lss.service "$(DESTDIR)$(INITDIR)/openvpn-lss.service"
	$(INSTALL_DATA) init/pihole-lss.service "$(DESTDIR)$(INITDIR)/pihole-lss.service"
	$(INSTALL_DATA) init/wireguard-lss.service "$(DESTDIR)$(INITDIR)/wireguard-lss.service"

install-man:
	$(INSTALL_DIR) "$(DESTDIR)$(MANDIR)"
	$(INSTALL_DATA) doc/$(PN).1 "$(DESTDIR)$(MANDIR)/$(PN).1"
	gzip -9 "$(DESTDIR)$(MANDIR)/$(PN).1"

uninstall:
	$(RM) "$(DESTDIR)$(BINDIR)/openvpn"
	$(RM) "$(DESTDIR)$(BINDIR)/pihole"
	$(RM) "$(DESTDIR)$(BINDIR)/wireguard"
	$(RM) "$(DESTDIR)$(INITDIR)/openvpn-lss.service"
	$(RM) "$(DESTDIR)$(INITDIR)/pihole-lss.service"
	$(RM) "$(DESTDIR)$(INITDIR)/wireguard-lss.service"
	$(RM) -rf "$(DESTDIR)$(CONFDIR)" "$(DESTDIR)$(SHAREDIR)" "$(DESTDIR)$(BINDIR)" "$(DESTDIR)$(MANDIR)/$(PN).1.gz"

install: install-common install-init install-man

clean:
	$(RM) -f common/openvpn
	$(RM) -f common/pihole
	$(RM) -f common/wireguard

.PHONY: install-common install-init install-man uninstall
