MAJOR = 0
MINOR = 0
MICRO = 0
SHLIB = libglob.so.$(MAJOR).$(MINOR).$(MICRO)
OBJS = glob.o

PREFIX ?= /usr/local
LIBDIR = $(PREFIX)/lib
INCDIR = $(PREFIX)/include/libglob


.PHONY: all install uninstall clean
all: libglob.so libglob.a

$(OBJS): %.o: %.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -fPIC -c $< -o $@

libglob.so: $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -shared -Wl,-soname,libglob.so.$(MAJOR) -o $(SHLIB)
	@-ln -sf $(SHLIB) libglob.so.$(MAJOR)
	@-ln -sf $(SHLIB) libglob.so

libglob.a: $(OBJS)
	$(AR) rcs $@ $^
	ranlib $@

install: all
	install -d $(DESTDIR)$(LIBDIR)
	install -m 644 libglob.a $(DESTDIR)$(LIBDIR)
	install -m 755 $(SHLIB) $(DESTDIR)$(LIBDIR)
	cp -a libglob.so $(DESTDIR)$(LIBDIR)
	cp -a libglob.so.$(MAJOR) $(DESTDIR)$(LIBDIR)
	install -d $(DESTDIR)$(INCDIR)
	install -m 644 glob.h $(DESTDIR)$(INCDIR)

uninstall:
	-rm -rf $(DESTDIR)$(INCDIR)
	-rm -f $(DESTDIR)$(LIBDIR)/libglob.*

clean:
	-rm -f libglob* $(OBJS)
