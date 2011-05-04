#include "git2-perl.h"


MODULE = Git2::Odb  PACKAGE = Git2::Odb  PREFIX = git_odb_


SV*
git_odb_new(SV *class)
	PREINIT:
		git_odb *odb = NULL;
        int code;
        SV *self;

	CODE:
        code = git_odb_new(&odb);
        GIT2PERL_CROAK(code);
        GIT2PERL_BLESS_FROM_CLASS_SV(odb, class);

	OUTPUT:
		RETVAL


SV*
git_odb_open(SV *class, const char *objects_dir)
	PREINIT:
		git_odb *odb = NULL;
        int code;

	CODE:
        code = git_odb_open(&odb, objects_dir);
        GIT2PERL_CROAK(code);
        GIT2PERL_BLESS_FROM_CLASS_SV(odb, class);

	OUTPUT:
		RETVAL


int
git_odb_exists(git_odb *odb, git_oid *oid)
	CODE:
        RETVAL = git_odb_exists(odb, oid);

	OUTPUT:
		RETVAL


SV*
git_odb_read(git_odb *db, git_oid *id);
	PREINIT:
		git_odb_object *object;
		int code;

	CODE:
		code = git_odb_read(&object, db, id);
		GIT2PERL_CROAK(code);
		GIT2PERL_BLESS_FROM_CLASSNAME(object, "Git2::Odb::Object");

	OUTPUT:
		RETVAL

void
git_odb_read_header(git_odb *db, git_oid *id)
	PREINIT:
		size_t len;
		git_otype type;
		int code;

	PPCODE:
		code = git_odb_read_header(&len, &type, db, id);
		if (code == GIT_ENOTFOUND) {
			/* Return emty stack: empty list: */
			XSRETURN_EMPTY;
		}

		/* Return (len, type) */
		EXTEND(SP, 2);
		PUSHs(sv_2mortal(newSViv(len)));
		PUSHs(sv_2mortal(newSViv(type)));


void
git_odb_close(git_odb *odb)
