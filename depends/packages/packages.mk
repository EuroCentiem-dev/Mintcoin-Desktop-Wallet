packages:=boost openssl libevent
darwin_packages:=zeromq
linux_packages:=zeromq
native_packages := native_ccache native_comparisontool

qt_native_packages = native_protobuf 
qt_packages = qrencode protobuf zlib

qt_linux_packages= qt596 expat dbus libxcb xcb_proto libXau xproto freetype fontconfig libX11 xextproto libXext xtrans
qt_darwin_packages=qtqt596
qt_mingw32_packages=qtqt596


wallet_packages=bdb

upnp_packages=miniupnpc

ifneq ($(build_os),darwin)
darwin_native_packages=native_cctools native_cdrkit native_libdmg-hfsplus
endif
